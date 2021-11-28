import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import rope.R_State.State; 
import rope.core.*; 
import rope.vector.vec; 
import rope.vector.vec2; 
import rope.gui.R_Dropdown; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Nuage extends PApplet {

/**
 * NUAGE 
 * v 0.0.1
 * 2021-2021
 * 
 * Algorithm exploration to create a cloud pixel around a root point
 * 
 * */




Rope r;


public void setup() {

	
	r = new Rope();
	State.init(this);
	dropdown_setup("chaos", "crazy walk", "circle", "spiral");

}

public void draw() {
	State.pointer(mouseX,mouseY);
  State.event(mousePressed);
	
	dropdown_update();
	if(mousePressed) {
		background(0);
		nuage();
	}
	

	State.reset_event();
}

public void mouseWheel(MouseEvent e) {
  State.scroll(e);
}


public void nuage() {
	int num = 1000;
	int algo = get_algorithm();
	float step = get_step();
	vec2 pos = new vec2(width/2, height/2);
	vec2 angle = new vec2(-PI,PI);
	// vec2 angle = new vec2(0,PI);
	vec2 range = new vec2(0,width/4);

	R_Nuage nuage = new R_Nuage(angle,range,algo);
	nuage.pos(pos).set_step(step).set_iter(num);
	loadPixels();
	for(int i = 0 ; i < num ; i++) {
    nuage.set_index(i);
		nuage.update();
		// pixels[nuage.get_pixel_index(g)] = r.BLANC;
		set((int)nuage.x(),(int)nuage.y(),r.BLANC);
	}
	updatePixels();
}



/**
* v 0.0.2
*/

public class R_Nuage extends Rope {
	// private float ref_x;
	// private float ref_y;
	private vec2 ref;
	private vec2 pos;

  private vec2 angle;
  private float aperture = 0;
  private float dir = 0;

  private vec2 range;
  private float dist = 1.0f;

  private int type = 0;
  private float step = 1.0f;
  private int iter = 1;
  private int index = 0;

  // private float seg_aperture = 0;

  // private int index = 0;
  // private int num;


  public R_Nuage(vec2 angle, vec2 range, int type) {
  	this.pos = new vec2(0);
    this.angle = angle.copy();
    this.aperture = calc_aperture(this.angle.x(),this.angle.y());
    this.range = range.copy();
		set_ref();
    set_type(type);
  }



  public R_Nuage set_iter(int iter) {
  	this.iter = iter;
    return this;
  }

  public R_Nuage set_index(int index) {
  	this.index = index;
    return this;
  }


  private void set_ref() {
  	if(this.ref == null) {
  		this.ref = this.pos.copy();
  	} else {
  		this.ref.set(this.pos);
  	}
  }

  public R_Nuage set_type(int type) {
  	this.type = type;
  	return this;
  }

  public R_Nuage set_step(float step) {
  	this.step = step;
  	return this;
  }

  public float get_step() {
  	return this.step;
  }


  // angle
	public R_Nuage set_angle(float min, float max) {
  	this.angle.set(min,max);
    this.aperture = calc_aperture(min,max);
  	return this;
  }

  public float get_dir() {
    return this.dir;
  }

  public float get_aperture() {
    return this.aperture;
  }

  private float calc_aperture(float min, float max) {
    if(max <= min) {
      print_err("WARNING: calc_aperture(",min,max,") float calc_aperture( float min, float max) 'min' must be < to 'max'");
      exit();
    }
    if(min < 0 && max >= 0) {
      return abs(min) + abs(max);
    }

    if(min < 0 && max < 0) {
      return abs(min) - abs(max);
    }
    return max - min;
  }



	
  // range and dist
  public R_Nuage set_range(float min, float max) {
  	this.range.set(min,max);
  	return this;
  }

  public float get_dist() {
    return this.dist;
  }

	public vec2 get_range() {
    return this.range;
  }

  public float get_dist_min() {
    return this.range.min();
  }

  public float get_dist_max() {
    return this.range.max();
  }



  public float x() {
  	return pos.x();
  }

  public float y() {
  	return pos.y();
  }

  public vec2 pos() {
  	return pos;
  }

  public R_Nuage pos(vec pos) {
  	this.pos(pos.x(),pos.y());
  	set_ref();
  	return this;
  }

	public R_Nuage pos(float x, float y) {
  	this.pos.set(x,y);return this;
  }

  public int get_pixel_index(PGraphics pg) {
  	return this.index_pixel_array((int)x(),(int)y(),pg.width);
  }



  // UPDATE
  private void update_pos() {
		float dx = sin(get_dir());
		float dy = cos(get_dir());


  	switch(this.type) {
  		case MAD:
      pos.add(dx * this.step, dy * this.step);
			if(ref.dist(pos) > get_dist_max()) {
      	pos.set(ref);
      }
      break;

      case CIRCULAR:
      pos.set(ref.x() + (dx *get_dist()), ref.y() + (dy * get_dist()));
      break;


      case SPIRAL:
      float seg_aperture = this.aperture / this.iter;
      seg_aperture *= (this.index * this.step);
      dx = sin(seg_aperture);
      dy = cos(seg_aperture);
      float buf_dist = get_dist_max();
      float segment = (buf_dist / this.iter);
      segment *= this.index;

      pos.set(ref.x() + (dx * segment), ref.y() + (dy * segment));
      break;

			case CHAOS:
			float ratio = 1;
			float dist =  get_dist();
			if(step > 1) {
				float k = random(1);
				k = pow(k,get_step());
				dist *= k;
			}

			
      pos.set(ref.x() + (dx * dist), ref.y() + (dy * dist));
      break;

      default:
      pos.set(ref.x() + (dx *get_dist()), ref.y() + (dy * get_dist()));
      break;
  	}
  }


  public void update() {
    this.dir = random(angle.min(),angle.max());
    switch(this.type) {
      case CIRCULAR:
      this.dist = get_dist_max();
      break;

			case MAD:
      this.dist = random(get_dist_min(), get_dist_max());
      break;

      case SPIRAL:
      this.dist = random(get_dist_min(), get_dist_max());
      break;

      case CHAOS:
      this.dist = random(get_dist_min(), get_dist_max());
      break;

      case IMAGE:
      this.dist = random(get_dist_min(), get_dist_max());
      break;

      default:
      this.dist = random(get_dist_min(), get_dist_max());
      break;
    }
    update_pos();
  }
}









R_Dropdown algo;
R_Dropdown step;

public void dropdown_setup(String... content) {
	algo = new R_Dropdown();
	algo.pos(5,5);
	algo.set_content(content);
	algo.set_label(content[0]);
	// step
	step = new R_Dropdown();
	step.pos(140,5);
	step.set_content("1","2","3","4","5","10","15","20","30","40","50","100");
	String str = "step" + step.get_content(0);
	step.set_label(str);
}

public void dropdown_update() {
	algo.update();
	algo.show_struc();
	String str = algo.get_value();
	algo.set_label(str);
	// step
	step.update();
	step.show_struc();
	str = "step " + step.get_value();
	step.set_label(str);


}


// get
public int get_algorithm() {
	if(algo.get_value().equals("crazy walk")) return r.MAD;
	if(algo.get_value().equals("spiral")) return r.SPIRAL;
	if(algo.get_value().equals("circle")) return r.CIRCULAR;
	if(algo.get_value().equals("chaos")) return r.CHAOS;
	return -1;
}

public float get_step() {
	if(str_is_numeric(step.get_value())) {
		return Float.parseFloat(step.get_value());
	}
	return 1;
}

public boolean str_is_numeric(String str) {
	return str != null && str.matches("[0-9.]+");
}
  public void settings() { 	size(400,400,P2D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Nuage" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
