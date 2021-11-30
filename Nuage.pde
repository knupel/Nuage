/**
 * NUAGE 
 * v 0.1.0
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
* v 0.1.0
*/

public class R_Nuage extends Rope {
	private vec2 ref_pos;
	private vec2 pos;

  private R_Focus focus;

  private vec2 range_angle;
  private float fov = 0;
  private float bissector = 0;

  private vec2 range_dist;

  private int type = 0;

  private float step = 1.0f;
  private int iter = 1;
  private int index = 0;


  public R_Nuage(vec2 range_dist, int type) {
    focus = new R_Focus();
  	this.pos = new vec2(0);
    this.range_angle = new vec2(-PI, PI);
    this.fov = calc_fov(this.range_angle.x(),this.range_angle.y());
    this.range_dist = range_dist.copy();
		set_ref();
    set_type(type);
  }


  // iteration & index
  public R_Nuage set_iter(int iter) {
  	this.iter = iter;
    return this;
  }

  public R_Nuage set_index(int index) {
  	this.index = index;
    return this;
  }

  // reference
  private void set_ref() {
  	if(this.ref_pos == null) {
  		this.ref_pos = this.pos.copy();
  	} else {
  		this.ref_pos.set(this.pos);
  	}
    float bissector = (this.range_angle.x() + this.range_angle.y()) * 0.5;
  }

  // type
  public R_Nuage set_type(int type) {
  	this.type = type;
  	return this;
  }

  // step
  public R_Nuage set_step(float step) {
  	this.step = step;
  	return this;
  }

  public float get_step() {
  	return this.step;
  }

  // focus
  public R_Focus get_focus() {
    return this.focus;
  }

  public R_Nuage set_focus(float angle, float dist) {
    set_focus_angle(angle);
    set_focus_dist(dist);
    return this;
  }

  public R_Nuage set_focus_angle(float angle) {
     boolean is = false;
    if(angle >= get_start_fov() && angle <= get_stop_fov()) {
      is = true;
    }
    if(is) {
      this.focus.set_angle(angle);
      return this;
    }
    print_err("public R_Nuage set_focus_angle(float angle)", angle, "is out of the range fov", get_start_fov(), get_stop_fov());
    exit();
    return this;
  }

  public R_Nuage set_focus_dist(float dist) {
     boolean is = false;
    if(dist >= get_dist_min() && dist <= get_dist_max()) {
      is = true;
    }
    if(is) {
      this.focus.set_dist(dist);
      return this;
    }
    print_err("public R_Nuage set_focus_dist(float dist)", dist, "is out of the range fov", get_dist_min(), get_dist_max());
    exit();
    return this;
  }


  // angle
	public R_Nuage set_fov(float min, float max) {
  	this.range_angle.set(min,max);
    this.fov = calc_fov(min,max);
  	return this;
  }

  public float get_start_fov() {
    return this.range_angle.x();
  }

  public float get_stop_fov() {
    return this.range_angle.y();
  }

  public float get_fov() {
    return this.fov;
  }

  public float get_angle() {
    return this.focus.get_angle();
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

  // range & dist
  public R_Nuage set_range_dist(float min, float max) {
  	this.range_dist.set(min,max);
  	return this;
  }

  public float get_dist() {
    return this.focus.get_dist();
  }

	public vec2 get_range_dist() {
    return this.range_dist;
  }

  public float get_dist_min() {
    return this.range_dist.x();
  }

  public float get_dist_max() {
    return this.range_dist.y();
  }


  // pos
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
		float dx = sin(get_focus().get_angle());
		float dy = cos(get_focus().get_angle());
    float ratio = ceil(random(this.step));;
    float dist = dist_impl();

  	switch(this.type) {
  		case MAD:
      pos.add(dx * this.step, dy * this.step);
			if(ref_pos.dist(pos) > get_dist_max()) {
      	pos.set(ref_pos);
      }
      break;

      case CIRCULAR:
      float seg_dist = get_dist() / this.step;
      dist = seg_dist * ratio;
      pos.set(ref_pos.x() + (dx * dist), ref_pos.y() + (dy * dist));
      break;

      case LINE:
      float ang = get_bissector();
      if(this.step > 1) {
        float seg_fov = get_fov() / this.step;
        seg_fov *= ratio;
        ang += seg_fov;
      }
      dx = sin(ang);
      dy = cos(ang);
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
      pos.set(ref_pos.x() + (dx * dist), ref_pos.y() + (dy * dist));
      break;

      default:
      pos.set(ref_pos.x() + (dx * dist), ref_pos.y() + (dy * dist));
      break;
  	}
  }

  private void update_focus() {
    float angle = random(get_start_fov(),get_stop_fov());
    float dist = 1;
    switch(this.type) {
      case CIRCULAR:
      dist = get_dist_max();
      break;

			case MAD:
      dist = random(get_dist_min(), get_dist_max());
      break;

      case SPIRAL:
      dist = random(get_dist_min(), get_dist_max());
      break;

      case CHAOS:
      dist = random(get_dist_min(), get_dist_max());
      break;

      case IMAGE:
      dist = random(get_dist_min(), get_dist_max());
      break;

      default:
      dist = random(get_dist_min(), get_dist_max());
      break;
    }
    set_focus(angle, dist);
  }

  public void update() {
    update_focus();  
    update_pos();
  }

  private float dist_impl() {
    float dist = this.focus.get_dist();
    if(step > 1) {
      float k = random(1);
      k = pow(k,get_step());
      dist *= k;
    }
    return dist;
  }
}


/**
* FOCUS
*/
public class R_Focus {
  private float angle = 0;
  private float distance = 1;

  public R_Focus() {}

  public R_Focus(float angle, float distance) {
    set_dist(distance);
    set_angle(angle);
  }

  public void set_dist(float distance) {
    this.distance = distance;
  }

  public float get_dist() {
    return this.distance;
  }

  public void set_angle(float angle) {
    this.angle = angle;
  }

  public float get_angle() {
    return this.angle;
  }
}






