
import rope.gui.R_Dropdown;

R_Dropdown menu;

void dropdown_setup(String... content) {
	menu = new R_Dropdown();
	menu.pos(5,5);
	menu.set_content(content);
	menu.set_label(content[0]);
}

void dropdown_update() {
	menu.update();
	menu.show_struc();
	String str = menu.get_value();
	menu.set_label(str);
}

int get_algorithm() {
	if(menu.get_value().equals("walk")) return r.WALK;
	if(menu.get_value().equals("circle")) return r.CIRCULAR;
	if(menu.get_value().equals("chaos")) return r.CHAOS;
	return -1;

}