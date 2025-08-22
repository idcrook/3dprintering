
use <mounting.scad>

show_assembly = true;

e = 1/64;

universal_customized_stl = "YS25_0402_10inch_rack.stl";

width = 132.0;
depth = 66.0 ;
height = 32.0;

slot_distance_from_front = 37.5;
// 8.5 cm
distance_between_slots = 85.0;

side_screw_from_base = 4.0;
side_screw_A_from_front = 15.5;
side_screw_B_from_front = 56.0;
side_screw_B_from_rear = 10.0;

/* [Hidden] */
assert((side_screw_B_from_front + side_screw_B_from_rear) == depth, "Spacing from front and rear should add up to total.");

// STL offsets

module single_look() {
  %ys25_0402();
  //customized_universal();
}

module ys25_0402 () {
  translate([width, 0, 0]) rotate ([-90, 180, 0])
    difference() {
    //color("darkblue")
    cube ([width, depth, height]);

    slot1_x = (width - distance_between_slots)/2;
    slot2_x = slot1_x + distance_between_slots;

    if (true) {
      //%translate([0,0,-3]) {
      translate([0, 0, -e]) {
        translate([slot1_x, slot_distance_from_front, 0]) {
          generate_ridge();
        }
        translate([slot2_x, slot_distance_from_front, 0]) {
          generate_ridge();
        }
      }
    }
  }
}

module mount_post () {

  support_height=5;
  support_leg = 16;
  union() {

    translate([2, -2, -(support_height/2)+e])
      rotate([0,0,0])
      cube([support_leg, support_leg, support_height], center = true);
    generate_ridge() {}
  }
}

bar_19inch_width = 19 * 25.4;
center_to_center_19inch = 18.3125 * 25.4;
interior_rack_spacing_19inch = 17.75 * 25.4;

bar_10inch_width = 10 * 25.4;
center_to_center_10inch = 9.3125 * 25.4;
interior_rack_spacing_10inch = 8.75 * 25.4;

// amount to shorten each ear (half on either side)
half_difference_19inch_to_10inch = ((19 - 10) * 25.4)/2;
half_ear_diff = half_difference_19inch_to_10inch / 2;


fudge = 0.2;

module bar_19inch() {
  y_depth = 5;
  z_height = 10;

  difference() {
    cube([bar_19inch_width, y_depth, z_height]);
    translate([(bar_19inch_width - center_to_center_19inch)/2, -e, z_height/2]) {
      rotate([-90,0,0]) cylinder(r = 6/2, h = y_depth + 20);
      translate([center_to_center_19inch,0,0])
      rotate([-90,0,0]) cylinder(r = 6/2, h = y_depth + 2*e);
    }
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


module customized_universal () {
  translate([0, 0, 0]) rotate([0, 0, 0])
  intersection () {
    // bounding box for left ear
    //translate([-e, -5-e, -e]) cube([10 + 45, 5 + 90 + 16, 5 + 16 + 5 + e]);
    import(universal_customized_stl);
  }

}

module assembly_10inch() {

  ys_y_offset = (44.45 - height) / 2;
  ys_x_offset = (bar_10inch_width - width) / 2;

  translate([0, 0, 0]) color("grey") customized_universal();
  %translate([ys_x_offset, ys_y_offset, 0])
     color("darkblue", alpha=0.8)
     ys25_0402();

   //translate([-2, -6, 33-1.5])
  translate([0.0, 1.5, 0])
  rotate([-90,0,0])
    %color("red", alpha= 0.85) bar_10inch();

}

if (show_assembly) {
  //assembly_original();
  assembly_10inch();
} else {
  single_look();
  //ys25_0402();
  // rotate([90, 0, 0])
  //   left_ear_10inch();

}
