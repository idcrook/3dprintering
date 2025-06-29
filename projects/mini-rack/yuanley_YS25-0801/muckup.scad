
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
ear_z = 44.0;

middle_x = 73;
middle_y = 198;
middle_z = 14.5;

// STL offsets
x_ear_offset = ear_y;
y_ear_offset = ear_x;
z_offset = 2.4;

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

// module modified_import () {

//   difference () {
//     translate([0,0,0]) import(rack_stl);

//     // strip previous mounting crosses
//     translate([-79,-87, 9+e]) sg108_enclosure();
//   }


//   // position updated half crosses
//   x1 = -55.0;
//   x2 = x1 + distance_between_slots;

//   y = -35.5;
//   z = 9-e;
//   //z = 0;


// }


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
ear_difference_19inch_to_10inch = ((19 - 10) * 25.4)/2;


frame_width = 67.0;
fudge = 0.2;

tray_length = 85.0;
tray_lip_overhang = 10;

tray_x_inset = 4.5;
tray_z_inset = 3.0;

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

if (show_assembly) {
  assembly_original();
} else {
  //single_look();
  left_ear();
  middle();
  right_ear();
  //ys25_0801();
  //generate_ridge();
  //sg108_enclosure();

}
