
use <mounting.scad>

show_assembly = true;

e = 1/64;

other_10inch = "../tp-link_SG108PE/tl-sg108pe.stl";
middle_stl = "yuanley-8-port-25g-switch-rack-mount-model_files/middlecover.stl";
left_ear_stl = "yuanley-8-port-25g-switch-rack-mount-model_files/leftmount.stl";
right_ear_stl = "yuanley-8-port-25g-switch-rack-mount-model_files/rightmount.stl";

width = 197.1;
depth = 72.9;
height = 29.0;

slot_distance_from_front = 43.5;
// 13.0 cm
distance_between_slots = 130.0;

/* [Hidden] */

ear_x = 73.0;
ear_y = 140.0;
ear_z = 44.45;

ear_y_10inch = 140.0 - ((19-10)/2 * 25.4);


middle_x = 73;
middle_y = 198;
middle_z = 14.5;

// STL offsets
x_ear_offset = ear_y;
y_ear_offset = ear_x;
z_offset = 2.45;

x_middle_offset = 231 + 5;
y_middle_offset = middle_y - 5;
z_middle_offset = ear_z;
middle_height = middle_z;

module single_look() {

  // intersection() {
  //   modified_import();
  //   *translate([-79,-87, 9]) %sg108_enclosure();
  // }

  %ys25_0801();
}

module ys25_0801 () {

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

// for 10 inch mods, need to subtract out total of 4.5" (1/2 of (19 - 10))

module left_ear_10inch () {
  // take half out of a left side and half out of right side and abut them

  // part 1
  difference() {
    left_ear();
    translate([(1/2)*(ear_y) - half_ear_diff,-e, -e])
      cube([ear_y, ear_x + 2*e, ear_z + 2*e]);
  }

  // part 2
  // abut the two parts
  translate([-2*(half_ear_diff+e), 0, 0])
  difference() {
    left_ear();
    translate([0, -e, -e])
      // chop from origin
      cube([(1/2) * (ear_y) + half_ear_diff, ear_x + 2*e, ear_z + 2*e]);
  }
}


module right_ear_10inch () {
  // take half out of a left side and half out of right side and abut them

  // part 1
  difference() {
    right_ear();
    translate([(1/2)*(ear_y) - half_ear_diff, -e, -e])
      cube([ear_y, ear_x + 2*e, ear_z + 2*e]);
  }

  // part 2
  // abut the two parts
  translate([-2*(half_ear_diff+e), 0, 0])
  difference() {
    right_ear();
    translate([0, -e, -e])
      // chop from origin
      cube([(1/2) * (ear_y) + half_ear_diff, ear_x + 3*e, ear_z + 2*e]);
  }
}


// possition at the origin
module middle () {

  translate([x_middle_offset,
             y_middle_offset,
             z_offset - z_middle_offset + middle_height])
    rotate([0, 0, -90])
  union () {
    import(middle_stl);
  }

}
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


module left_ear () {
  translate([231 + x_ear_offset, y_ear_offset, z_offset]) rotate([0, 0, -90])
  intersection () {
    // bounding box for left ear
    //translate([-e, -5-e, -e]) cube([10 + 45, 5 + 90 + 16, 5 + 16 + 5 + e]);
    import(left_ear_stl);
  }

}

module right_ear () {

  translate([33, y_ear_offset, z_offset]) rotate([0, 0, -90])
  difference () {
    import(right_ear_stl);
    // bounding box for left ear
    //translate([-e, -5-e, -e]) cube([10 + 45, 5 + 90 + 16, 5 + 16 + 5 + e]);
  }

}


module assembly_original() {

  translate([0, 0, 0]) color("grey") left_ear();
  translate([ear_y + 1*fudge, 0, ear_z - middle_height])
    color("grey") middle();
  translate([ear_y + 1*fudge, 0, 0])
    color("darkblue") ys25_0801();
  translate([ear_y + middle_y + 2*fudge, 0, 0])
    color("grey") right_ear();

  translate([-2, -6, 33-1.5]) % color("red", alpha= 0.60) bar_19inch();

}


module assembly_10inch() {

  translate([0, 0, 0]) color("grey") left_ear_10inch();
  translate([ear_y_10inch + 1*fudge, 0, ear_z - middle_height])
    color("grey") middle();
  %translate([ear_y_10inch + 1*fudge, -e, 0])
    color("darkblue", alpha=0.3) ys25_0801();
  translate([ear_y_10inch + middle_y + 2*fudge, 0, 0])
    color("grey") right_ear_10inch();

  translate([-2, -6, 33-1.5])  %color("red", alpha= 0.60) bar_10inch();

}

if (show_assembly) {
  //assembly_original();
  assembly_10inch();
} else {
  //single_look();
  //left_ear();
  //middle();
  //right_ear();
  //ys25_0801();
  // rotate([90, 0, 0])
  //   left_ear_10inch();
  rotate([90, 0, 0])
    right_ear_10inch();
  // rotate([0, 0, 0])
  //   middle();

}
