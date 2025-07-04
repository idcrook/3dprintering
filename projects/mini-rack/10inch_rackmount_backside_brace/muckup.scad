
show_assembly = true;

e = 1/64;

left_ear_stl = "left-ear.stl";
shelf_stl = "../tp-link_SG108PE/10-inch-rack-sg108pe-with-power-brick.stl";

width = 73.0;
depth = 55.5;
height = 44.45;

face_plate_thickness = 3.5;
platform_thickness = 4.0;
/* [Hidden] */

shelf_face_thickness = 5.0;
shelf_width = 254;
shelf_depth = 175;
depth_of_switch = 100.7;

shelf_height = 44.45;
deskmate_t1_front_to_rear_rack_distance = 200.0;

// STL offsets

module single_look() {

  //left_ear_10inch();
  right_ear_10inch();
}

bar_10inch_width = 10 * 25.4;
center_to_center_10inch = 9.3125 * 25.4;

fudge = 0.2;

module left_ear_10inch () {
  translate([0, 0, 0])
  difference() {
    left_ear();
  }
}

module right_ear_10inch () {
  translate([width, 0, 0])
  mirror([1,0,0]) {
    left_ear();
  }
}

module bar_10inch() {
  y_depth = 5;
  z_height = 10;

  difference() {
    cube([bar_10inch_width, y_depth, z_height]);
    translate([(bar_10inch_width - center_to_center_10inch)/2, -e, z_height/2]) {
      rotate([-90,0,0]) cylinder(r = 6/2, h = y_depth + 20);
      translate([center_to_center_10inch,0,0])
      rotate([-90,0,0]) cylinder(r = 6/2, h = y_depth + 2*e);
    }
  }
}

module left_ear () {
  translate([width/2, face_plate_thickness, height/2]) rotate([0, 0, 0])
  intersection () {
    import(left_ear_stl);
  }
}

module target_shelf () {

  y_extra = shelf_face_thickness + 0.5;
  distance_away = deskmate_t1_front_to_rear_rack_distance - shelf_depth + shelf_face_thickness;

  translate([0, distance_away, 0])
  translate([shelf_width/2 , shelf_depth/2-y_extra, 0])
    rotate([0, 0, 180])
  union () {
    import(shelf_stl);
  }
}


module assembly_10inch() {

  slide_up_against_distance = 1.5;

  translate([-slide_up_against_distance, -face_plate_thickness, 0])  left_ear_10inch();
  translate([bar_10inch_width - width + slide_up_against_distance, -face_plate_thickness, 0])  right_ear_10inch();

  %translate([0, 0, 0])  target_shelf();

  %translate([0, -6-face_plate_thickness, 33])  color("red", alpha= 0.60) bar_10inch();


}

if (show_assembly) {
  //assembly_original();
  assembly_10inch();
} else {
  single_look();
  // rotate([90, 0, 0])
  //   left_ear_10inch();
  //target_shelf();
}
