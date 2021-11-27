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
	dropdown_setup("chaos", "walk", "circle");

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
	int num = 1000;
	int algo = get_algorithm();
	float step = get_step();
	vec2 pos = new vec2(width/2, height/2);
	vec2 angle = new vec2(-PI,PI);
	// vec2 angle = new vec2(0,PI);
	vec2 range = new vec2(0,width/4);

	R_Nuage nuage = new R_Nuage(angle,range,algo);
	nuage.pos(pos).set_step(step);
	loadPixels();
	for(int i = 0 ; i < num ; i++) {
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
  private vec2 range;
  private int type = 0;
  private float step = 1.0f;

  // private int index = 0;
  // private int num;

  private float dir = 0;
  private float dist = 1.0f;

  public R_Nuage(vec2 angle, vec2 range, int type) {
  	this.pos = new vec2(0);
    this.angle = angle.copy();
    this.range = range.copy();
		set_ref();
    set_type(type);
  }

  private R_Nuage set_num(int num) {
  	this.num = num;
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

	public R_Nuage set_range(float min, float max) {
  	this.range.set(min,max);
  	return this;
  }

	public R_Nuage set_angle(float min, float max) {
  	this.angle.set(min,max);
  	return this;
  }

  public float get_dist() {
    return this.dist;
  }
	
	public vec2 get_range() {
    return this.range;
  }

  public float get_dir() {
    return this.dir;
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
		float dy = cos(get_dir()) ;
		// print_err(dx, dy);


  	switch(this.type) {
  		case WALK:
      pos.add(dx * this.step, dy * this.step);
			if(ref.dist(pos) > get_range().max()) {
      	pos.set(ref);
      }
      break;

      case CIRCULAR:
      // try to make a spiral...
      if(get_step() > 1) {
      	this.index++;
      	float val = get_dist() / this.max;
      }
      pos.set(ref.x() + (dx *get_dist()), ref.y() + (dy * get_dist()));
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
      this.dist = range.max();
      break;

			case WALK:
      this.dist = random(range.min(), range.max());
      break;

      case CHAOS:
      this.dist = random(range.min(), range.max());
      break;

      case IMAGE:
      this.dist = random(range.min(), range.max());
      break;

      default:
      this.dist = random(range.min(), range.max());
      break;
    }
    update_pos();
  }
}






