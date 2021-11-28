
import rope.gui.R_Dropdown;

R_Dropdown algo;
R_Dropdown step;
R_Dropdown num;

void dropdown_setup(String... content) {
	algo = new R_Dropdown();
	algo.pos(5,5);
	algo.set_content(content);
	algo.set_label(content[0]);
	// step
	step = new R_Dropdown();
	step.pos(137,5);
	step.set_content("1","2","3","4","5","10","15","20","30","40","50","100");
	String step_str = "step" + step.get_content(0);
	step.set_label(step_str);
	// num
	num = new R_Dropdown();
	num.pos(270,5);
	num.set_content("10","20","40","80","160","320","640","1240","2480");
	String num_str = "num" + step.get_content(0);
	num.set_label(num_str);
}

void dropdown_update() {
	algo.update();
	algo.show_struc();
	String algo_str = algo.get_value();
	algo.set_label(algo_str);
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

int get_num() {
	if(str_is_numeric(num.get_value())) {
		return Integer.parseInt(num.get_value());
	}
	return 1;
}

boolean str_is_numeric(String str) {
	return str != null && str.matches("[0-9.]+");
}