

show_assembly = true;

e = 1/128;

rack_model_pi5_stl = "Pi 5 Rack.3mf";
rack_model_pi4_stl = "RackPi4B_no_OLED_Switch_LED.stl";
rack_model_pi4_switch_stl = "RackPi4B_no_OLED.stl";
rack_model_pi_stl = "RackPi_no_OLED_Switch_LED.stl";

hole_distance = 74.0;
interior_gap = 62.0;
total_span = 88.0;

/* [Hidden] */

rack_h = 88.2;
rack_w = 22.050 * 2;
rack_hole_inset = 6.0;
rack_hole_radius = 2.300;

rack_face_thickness = 2.0;

fudge = 0.2;

// rpi 3b
rpi_width = 56.5;
rpi_depth = 85.6;
rpi_height = 27.0; // allow for some height on dupont connectors in GPIO header

module single_look() {
  intersection() {
    //modified_import_pi5();
    //modified_import_pi4();
    modified_import_pi();
  }
}


module modified_import_pi5 () {

  patch_hole_diameter = 2 * (rack_hole_radius + 0.5);

  old_hole1_y = (1/2)*(rack_w - patch_hole_diameter);
  old_hole1_x = rack_hole_inset - (1/2)*patch_hole_diameter;

  old_hole2_y = old_hole1_y;
  old_hole2_x = rack_h - rack_hole_inset - (1/2)*patch_hole_diameter;

  patch_size = [patch_hole_diameter, patch_hole_diameter,
                rack_face_thickness + 2*e];

  hole1_y =  (1/2)*(rack_w);
  hole1_x =  (1/2)*(rack_h - hole_distance);

  hole2_y =  (1/2)*(rack_w);
  hole2_x =  rack_h - (1/2)*(rack_h - hole_distance);


  difference () {
    union() {
      translate(v = [-84, -106, -1])
        rotate([0,0,0])
        import(rack_model_pi5_stl);

      // fill in exisiting holes
      translate([old_hole1_x, old_hole1_y, -e])
        cube(patch_size);

      // fill in exisiting holes
      translate([old_hole2_x, old_hole2_y, -e])
        cube(patch_size);
    }

    $fn = 32;
    translate([hole1_x, hole1_y, -2*e])
    cylinder(h = rack_face_thickness + 4*e, r = rack_hole_radius, center = false);

    translate([hole2_x, hole2_y, -2*e])
    cylinder(h = rack_face_thickness + 4*e, r = rack_hole_radius, center = false);

  }
}

module modified_import_pi4 (use_pi4_switch_model = false) {

  rack_model_stl = (use_pi4_switch_model) ? rack_model_pi4_switch_stl : rack_model_pi4_stl;

  patch_hole_diameter = 2 * (rack_hole_radius + 0.5);

  old_hole1_y = (1/2)*(rack_w - patch_hole_diameter);
  old_hole1_x = rack_hole_inset - (1/2)*patch_hole_diameter;

  old_hole2_y = old_hole1_y;
  old_hole2_x = rack_h - rack_hole_inset - (1/2)*patch_hole_diameter;

  patch_size = [patch_hole_diameter, patch_hole_diameter,
                rack_face_thickness + 2*e];

  hole1_y =  (1/2)*(rack_w);
  hole1_x =  (1/2)*(rack_h - hole_distance);

  hole2_y =  (1/2)*(rack_w);
  hole2_x =  rack_h - (1/2)*(rack_h - hole_distance);


  difference () {
    union() {
      translate(v = [1, 44, 0])
        rotate([0,0,0])
        import(rack_model_stl);

      // fill in exisiting holes
      translate([old_hole1_x, old_hole1_y, -e])
        cube(patch_size);

      // fill in exisiting holes
      translate([old_hole2_x, old_hole2_y, -e])
        cube(patch_size);
    }

    $fn = 32;
    translate([hole1_x, hole1_y, -2*e])
    cylinder(h = rack_face_thickness + 4*e, r = rack_hole_radius, center = false);

    translate([hole2_x, hole2_y, -2*e])
    cylinder(h = rack_face_thickness + 4*e, r = rack_hole_radius, center = false);

  }
}

module modified_import_pi () {

  patch_hole_diameter = 2 * (rack_hole_radius + 0.5);

  old_hole1_y = (1/2)*(rack_w - patch_hole_diameter);
  old_hole1_x = rack_hole_inset - (1/2)*patch_hole_diameter;

  old_hole2_y = old_hole1_y;
  old_hole2_x = rack_h - rack_hole_inset - (1/2)*patch_hole_diameter;

  patch_size = [patch_hole_diameter, patch_hole_diameter,
                rack_face_thickness + 2*e];

  hole1_y =  (1/2)*(rack_w);
  hole1_x =  (1/2)*(rack_h - hole_distance);

  hole2_y =  (1/2)*(rack_w);
  hole2_x =  rack_h - (1/2)*(rack_h - hole_distance);


  difference () {
    union() {
      translate(v = [87.2, 44.1, 0])
        rotate([0,0,0])
        import(rack_model_pi_stl);

      // fill in exisiting holes
      translate([old_hole1_x, old_hole1_y, -e])
        cube(patch_size);

      // fill in exisiting holes
      translate([old_hole2_x, old_hole2_y, -e])
        cube(patch_size);
    }

    $fn = 32;
    translate([hole1_x, hole1_y, -2*e])
    cylinder(h = rack_face_thickness + 4*e, r = rack_hole_radius, center = false);

    translate([hole2_x, hole2_y, -2*e])
    cylinder(h = rack_face_thickness + 4*e, r = rack_hole_radius, center = false);

  }
}




module rpi () {
  difference() {
    color("green")
    cube ([rpi_width, rpi_depth, rpi_height]);
  }
}



module assembly() {

  translate([0,0])
    modified_import_pi5();

  translate([0,50])
    modified_import_pi();

  translate([90, 0])
    modified_import_pi4(use_pi4_switch_model = false);

  translate([90,50])
    modified_import_pi4(use_pi4_switch_model = true);


}

if (show_assembly) {
  assembly();
} else {
  single_look();
}
