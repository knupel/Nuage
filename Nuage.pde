/**
 * NUAGE 
 * v 0.1.1
 * 2021-2023
 * 
 * Algorithm exploration to create a cloud pixel around a root point
 * 
 * */
import rope.utils.R_State.State;
import rope.core.Rope;

/**
 * this sketch is used to work easily to class R_Nubo for Rope library
 * you can diable the tab class_nuage.pde and use directly by using the import from library
*/
import rope.pixo.R_Nubo;
Rope r = new Rope();

R_Nubo nuage;


void setup() {
	size(800,400,P2D);
	
	State.init(this);
	gui_setup();
	nuage = new R_Nubo(this);
	nuage.info();

}

void draw() {
	State.pointer(mouseX,mouseY);
  State.event(mousePressed);
	
	if(!keyPressed) {
		background(0);
		nuage();
	}
	gui_update_and_show();

	
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

  nuage.set_field(range);
  nuage.set_algo(algo).set_mode(mode);
  // r.print_out("type",algo,"mode",mode);
  nuage.pos(pos).set_fov(gui_get_fov()).set_step(step).set_iter(num);
  nuage.set_grid(gui_get_grid()).use_grid(true);

  float off_ang = (frameCount * 0.02)%TAU;
  nuage.offset_angle(off_ang);
	loadPixels();
	int ratio = 5;
	float off_x = map(mouseX,0,width, -width/ratio,width/ratio);
	float off_y = map(mouseY,0,height, -height/ratio,height/ratio);
	nuage.offset_pos(off_x,off_y);
	for(int i = 0 ; i < num ; i++) {
		nuage.update(i);
    if(nuage.pixel_is()) {
      set((int)nuage.x(),(int)nuage.y(),r.BLANC);
    }
	}
	updatePixels();
}
