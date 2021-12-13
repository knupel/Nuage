
import rope.gui.R_Dropdown;
import rope.vector.vec2;
import rope.vector.ivec2;

R_Dropdown algo;
R_Dropdown mode;
R_Dropdown step;
R_Dropdown num;
R_Dropdown grid;
R_Dropdown fov;

void dropdown_setup() {
	int step_db = 130;
	int pos_x = 5;
	// algo / type
	String [] content = {"chaos", "mad", "circle", "spiral", "line", "polygon"};
	algo = new R_Dropdown();
	algo.pos(pos_x,5);
	algo.set_content(content);
	algo.set_label(content[0]);
	// step
	mode = new R_Dropdown();
	mode.pos(pos_x += step_db ,5);
	mode.set_content("0","1","2","3","4","5","6");
	String mode_str = "mode" + mode.get_content(0);
	mode.set_label(mode_str);
	// step
	step = new R_Dropdown();
	step.pos(pos_x += step_db,5);
	step.set_content("1","2","3","4","5","10","15","20","30","40","50","100");
	String step_str = "step" + step.get_content(0);
	step.set_label(step_str);
	// num
	num = new R_Dropdown();
	num.pos(pos_x += step_db,5);
	num.set_content("10","20","40","80","160","320","640","1240","2480");
	String num_str = "num" + num.get_content(0);
	num.set_label(num_str);
	// grid
	grid = new R_Dropdown();
	grid.pos(pos_x += step_db,5);
	grid.set_content("1/1","2/2","3/3","4/4","6/6","8/8","2/6","6/2");
	String grid_str = "grid" + grid.get_content(0);
	grid.set_label(grid_str);
	// fov
	fov = new R_Dropdown();
	fov.pos(pos_x += step_db,5);
	fov.set_content("360°","270°","240°", "180°","120°","90°","45°");
	String fov_str = "fov" + fov.get_content(0);
	fov.set_label(fov_str);
}

void dropdown_update() {
	algo.update();
	algo.show_struc();
	String algo_str = algo.get_value();
	algo.set_label(algo_str);
	// mode
	mode.update();
	mode.show_struc();
	String mode_str = "mode " + mode.get_value();
	mode.set_label(mode_str);
	// step
	step.update();
	step.show_struc();
	String step_str = "step " + step.get_value();
	step.set_label(step_str);
	// num
	num.update();
	num.show_struc();
	String num_str = "num " + num.get_value();
	num.set_label(num_str);
	// grid
	grid.update();
	grid.show_struc();
	String grid_str = "grid " + grid.get_value();
	grid.set_label(grid_str);
  // fov
	fov.update();
	fov.show_struc();
	String fov_str = "fov " + fov.get_value();
	fov.set_label(fov_str);


}


// get
vec2 gui_get_fov() {
	vec2 buf = new vec2(0,TAU);
	if(fov.get_value().equals("360°")) return buf;
	if(fov.get_value().equals("270°")) return buf.set(0,TAU * 0.75);
	if(fov.get_value().equals("240°")) return buf.set(0,TAU * 0.66);
	if(fov.get_value().equals("180°")) return buf.set(0,PI);
	if(fov.get_value().equals("120°")) return buf.set(0,TAU * 0.3333334);
	if(fov.get_value().equals("90°")) return buf.set(0, PI * 0.5);
	if(fov.get_value().equals("45°")) return buf.set(0, PI * 0.25);
	return buf;
}

ivec2 gui_get_grid() {
	ivec2 buf = new ivec2(1);
	if(grid.get_value().equals("1/1")) return buf.set(1);
	if(grid.get_value().equals("2/2")) return buf.set(2);
	if(grid.get_value().equals("3/3")) return buf.set(3);
	if(grid.get_value().equals("4/4")) return buf.set(4);
	if(grid.get_value().equals("6/6")) return buf.set(6);
	if(grid.get_value().equals("8/8")) return buf.set(8);
	if(grid.get_value().equals("2/6")) return buf.set(2,6);
	if(grid.get_value().equals("6/2")) return buf.set(6,2);
	return buf;
}

ivec2 gui_get_algorithm() {
	ivec2 buf = new ivec2(r.CHAOS, 0);
	if(algo.get_value().equals("chaos")) return buf;
	if(algo.get_value().equals("mad")) return buf.set(r.MAD,0);
	if(algo.get_value().equals("spiral")) return buf.set(r.SPIRAL,gui_get_mode());
	if(algo.get_value().equals("circle")) return buf.set(r.CIRCULAR,0);
	if(algo.get_value().equals("line")) return buf.set(r.LINE,gui_get_mode());
	if(algo.get_value().equals("polygon")) return buf.set(r.POLYGON,gui_get_mode());
	return buf;
}

int gui_get_mode() {
	if(str_is_numeric(mode.get_value())) {
		return Integer.parseInt(mode.get_value());
	}
	return 0;
}

float gui_get_step() {
	if(str_is_numeric(step.get_value())) {
		return Float.parseFloat(step.get_value());
	}
	return 1;
}

int gui_get_num() {
	if(str_is_numeric(num.get_value())) {
		return Integer.parseInt(num.get_value());
	}
	return 1;
}

boolean str_is_numeric(String str) {
	return str != null && str.matches("[0-9.]+");
}