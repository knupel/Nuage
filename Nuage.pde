/**
 * NUAGE 
 * v 0.0.1
 * 2021-2021
 * 
 * Algorithm exploration to create a cloud pixel around a root point
 * 
 * */
import rope.R_State.State;
import rope.core.*;
import rope.vector.vec;
import rope.vector.vec2;
Rope r;


void setup() {

	size(400,400,P2D);
	r = new Rope();
	State.init(this);
	dropdown_setup("chaos", "crazy walk", "circle", "spiral", "line");

}

void draw() {
	State.pointer(mouseX,mouseY);
  State.event(mousePressed);
	
	dropdown_update();
	if(mousePressed) {
		background(0);
		nuage();
	}
	

	State.reset_event();
}

void mouseWheel(MouseEvent e) {
  State.scroll(e);
}


void nuage() {
	int num = get_num();
	int algo = get_algorithm();
	float step = get_step();
	vec2 pos = new vec2(width/2, height/2);
	// vec2 angle = new vec2(-PI,PI);
	// vec2 angle = new vec2(0,PI);
	vec2 range = new vec2(0,width/4);

	R_Nuage nuage = new R_Nuage(range,algo);
	nuage.pos(pos).set_fov(-PI,PI).set_step(step).set_iter(num);
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
	private vec2 ref_pos;
	private vec2 pos;

  private vec2 angle;
  private float fov = 0;
  private float bissector = 0;
  private float focus = 0;

  private vec2 range;
  private float dist = 1.0f;

  private int type = 0;
  private float step = 1.0f;
  private int iter = 1;
  private int index = 0;


  public R_Nuage(vec2 range, int type) {
  	this.pos = new vec2(0);
    this.angle = new vec2(-PI, PI);
    this.fov = calc_fov(this.angle.x(),this.angle.y());
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
  	if(this.ref_pos == null) {
  		this.ref_pos = this.pos.copy();
  	} else {
  		this.ref_pos.set(this.pos);
  	}
    float bissector = (this.angle.x() + this.angle.y()) * 0.5;
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
	public R_Nuage set_fov(float min, float max) {
  	this.angle.set(min,max);
    this.fov = calc_fov(min,max);
  	return this;
  }

  public R_Nuage set_focus(float angle) {
    if(angle >= get_start_fov() && angle <= get_stop_fov()) {
      this.focus = angle;
      return this;
    }
    print_err("public R_Nuage set_focus(float angle)", angle, "is out of the range fov", get_start_fov(), get_stop_fov());
    exit();
    return this;
  }

  public float get_start_fov() {
    return this.angle.x();
  }

  public float get_stop_fov() {
    return this.angle.y();
  }

  public float get_fov() {
    return this.fov;
  }

  public float get_focus() {
    return this.focus;
  }

  public float get_bissector() {
    return this.bissector;
  }



  private float calc_fov(float min, float max) {
    if(max <= min) {
      print_err("WARNING: calc_fov(",min,max,") float calc_fov( float min, float max) 'min' must be < to 'max'");
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
		float dx = sin(get_focus());
		float dy = cos(get_focus());
    float ratio = 1;
    float dist = 1;


  	switch(this.type) {
  		case MAD:
      pos.add(dx * this.step, dy * this.step);
			if(ref_pos.dist(pos) > get_dist_max()) {
      	pos.set(ref_pos);
      }
      break;

      case CIRCULAR:
      pos.set(ref_pos.x() + (dx * dist), ref_pos.y() + (dy * dist));
      break;

      case LINE:
      dx = sin(get_bissector());
      dy = cos(get_bissector());
      dist = dist_impl();
      pos.set(ref_pos.x() + (dx * dist), ref_pos.y() + (dy * dist));
      break;


      case SPIRAL:
      float variance = random(this.iter/this.step, this.iter);
      float segment_fov = this.fov / variance;
      segment_fov *= (this.index * this.step);
      dx = sin(segment_fov);
      dy = cos(segment_fov);
      float buf_dist = get_dist_max();
      float segment = buf_dist / variance;
      segment *= this.index;
      segment /= this.step;

      pos.set(ref_pos.x() + (dx * segment), ref_pos.y() + (dy * segment));
      break;

			case CHAOS:
      dist = dist_impl();
      pos.set(ref_pos.x() + (dx * dist), ref_pos.y() + (dy * dist));
      break;

      default:
      pos.set(ref_pos.x() + (dx * dist), ref_pos.y() + (dy * dist));
      break;
  	}
  }

  private float dist_impl() {
    float dist =  get_dist();
    if(step > 1) {
      float k = random(1);
      k = pow(k,get_step());
      dist *= k;
    }
    return dist;
  }


  public void update() {
    set_focus(get_start_fov(),get_stop_fov());
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






