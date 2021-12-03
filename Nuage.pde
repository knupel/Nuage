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

Rope r;


void setup() {

	size(800,400,P2D);
	r = new Rope();
	State.init(this);
	dropdown_setup();

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
	int num = gui_get_num();
	int algo = gui_get_algorithm().x();
  int mode =  gui_get_algorithm().y();
	float step = gui_get_step();
	vec2 pos = new vec2(width/2, height/2);
	vec2 range = new vec2(0,height *0.33);

  R_Nuage nuage = new R_Nuage();
  nuage.set_field(range);
  nuage.set_type(algo).set_mode(mode);
  r.print_out("type",algo,"mode",mode);
  nuage.pos(pos).set_fov(gui_get_fov()).set_step(step).set_iter(num);
  nuage.set_grid(gui_get_grid()).use_grid(true);

  // float off_ang = map(sin(frameCount * 0.02), -1, 1, -PI, PI);
  float off_ang = (frameCount * 0.02)%TAU;
  nuage.offset_angle(off_ang);
	loadPixels();
	for(int i = 0 ; i < num ; i++) {
    nuage.set_index(i);
		nuage.update();
    if(nuage.pixel_is()) {
      set((int)nuage.x(),(int)nuage.y(),r.BLANC);
    }
	}
	updatePixels();
}










