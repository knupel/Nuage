
import rope.gui.R_Dropdown;

R_Dropdown algo;
R_Dropdown step;

void dropdown_setup(String... content) {
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

void dropdown_update() {
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
int get_algorithm() {
	if(algo.get_value().equals("crazy walk")) return r.MAD;
	if(algo.get_value().equals("spiral")) return r.SPIRAL;
	if(algo.get_value().equals("circle")) return r.CIRCULAR;
	if(algo.get_value().equals("chaos")) return r.CHAOS;
	return -1;
}

float get_step() {
	if(str_is_numeric(step.get_value())) {
		return Float.parseFloat(step.get_value());
	}
	return 1;
}

boolean str_is_numeric(String str) {
	return str != null && str.matches("[0-9.]+");
}