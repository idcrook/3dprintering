
include <../../../libraries/BOSL2/std.scad>

show_assembly = !true;

e = 1/128;

universal_customized_stl = "universal_10inch_rack-xikestor8310.stl";

width = 207;
depth = 136;
height = 35;

rackmount_height = 44.45; // 1U

mount_front_screws__from_front = 7.0;
mount_front_screws__from_bottom = 8.0;
mount_front_screws__spacing = 19.0;

mount_front_screws__hole1_height = (1/2) * (rackmount_height - height) + mount_front_screws__from_bottom;
mount_front_screws__hole2_height = mount_front_screws__hole1_height + mount_front_screws__spacing;

mount_back_screw__from_front = 21.5;
mount_back_screw__from_bottom = height / 2;
mount_back_screw__height = (1/2) * (rackmount_height - height) + mount_back_screw__from_bottom;

mount_height = height + (1/2)*(rackmount_height - height);
//mount_height = height;

mount_height__from_1U_bottom = (1/2)*(rackmount_height - mount_height);
mount_length = 30.0 + 5.0;

ear_face_thickness = 3.5;
ear_mount_thickness = 4.5;

/* [Hidden] */

rackmount_hole_diameter = 6;
rackmount_hole_spacing_across = 236.525;
rackmount_opening_spacing = 222.25;
rackmount_hole_1_height = 12.7 / 2;
rackmount_hole_2_height = rackmount_height - rackmount_hole_1_height;
rackmount_strip_width = 15.875;
rackmount__end_to_end = 254.0;

rail_hole_diameter = 6.0;
rail_hole_center_inset = (1/2) * (rackmount__end_to_end - rackmount_hole_spacing_across);

assert((rackmount_strip_width + rackmount_opening_spacing + rackmount_strip_width ) == rackmount__end_to_end, "components do not sum to Total .");



ear_overlap_opening = (1/2) * (rackmount_opening_spacing - width) ;
ear_face_length = rackmount_strip_width + ear_overlap_opening - ear_mount_thickness;



// STL offsets

module single_look() {
  %sks8310();
  //customized_universal();
}

module sks8310 () {
  translate([width, 0, 0]) rotate ([-90, 180, 0])
    difference() {
    //color("darkblue")
    cube ([width, depth, height]);

  }
}

module mount_screw_hole (diameter = 3, height = 10) {
  $fn = 20;
  r1 = diameter/2;
  r2 = r1 + 1.75;
  h2 = 0.66;
  r3 = (r1+r2)/2;
  h3 = h2/2;
  translate([0,-e,0]) rotate([-90, 0, 0]) {
    cylinder(h = height, r = r1, center = false);
    cylinder(h = h2, r = r2, center = false);
    translate([0,0, h2-e])
      cylinder(h = h3, r = r3, center = false);
  }

}


module rail_hole (diameter = rackmount_hole_diameter, height = 10) {
  $fn = 20;
  translate([0,-e,0]) rotate([-90, 0, 0])
  cylinder(h = height, r = diameter/2, center = false);

}

module left_ear_10inch() {

  face_height = rackmount_height;
  face_width = ear_face_length;
  face_thickness = ear_face_thickness;

  bracket_length = mount_length;
  bracket_height = mount_height;
  delta_y = (1/2)*(bracket_height - height);
  bracket_thickness = ear_mount_thickness;

  rail1_x = rail_hole_center_inset;
  rail1_y = rackmount_hole_1_height;

  rail2_x = rail_hole_center_inset;
  rail2_y = rackmount_hole_2_height;


  front1_x = mount_front_screws__from_front;
  front1_y = mount_front_screws__from_bottom + delta_y;

  front2_x = mount_front_screws__from_front;
  front2_y = front1_y + mount_front_screws__spacing;

  back_x = mount_back_screw__from_front;
  back_y = mount_back_screw__from_bottom + delta_y;



  // ear face
  difference() {
    union() {
      // main face
      cube([face_width, face_thickness, face_height], center = false);

      // taper
      translate([face_width + (1/2)*bracket_thickness - e,
                 face_thickness,
                 (1/2)*face_height])
        rotate([0,90,-90])
        linear_extrude(height=face_thickness)
        trapezoid(h=bracket_thickness, w1=face_height, w2=mount_height);
    }
    // punch holes
    translate([rail1_x, 0 , rail1_y])
      rail_hole();

    translate([rail2_x, 0 , rail2_y])
      rail_hole();


  }

  // ear along mount (bracket into switch)
  start_mount = face_width;
  translate([start_mount - e, 0, mount_height__from_1U_bottom]) rotate([0,0,90])
  mirror([0, 1, 0])
  difference() {

    cube([bracket_length, bracket_thickness, bracket_height], center = false);

    // punch holes
    translate([front1_x, 0 , front1_y])
      mount_screw_hole();

    translate([front2_x, 0 , front2_y])
      mount_screw_hole();

    translate([back_x, 0 , back_y])
      mount_screw_hole();

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
  difference() {
    import(universal_customized_stl);

    // poke a hole to insert barrel connector for DC power
    translate([25, height * (2/3), -5]) rotate([0, -30, 0])
      cylinder(h = 40, r = 10 * (1/2), center = false);

  }

}

module assembly_10inch() {

  ys_y_offset = (44.45 - height) / 2;
  ys_x_offset = (bar_10inch_width - width) / 2;

  translate([0, 0, 0]) color("grey") customized_universal();

  %translate([ys_x_offset, ys_y_offset, 0])
     color("darkblue", alpha=0.8)
     sks8310();

   //translate([-2, -6, 33-1.5])
  translate([0.0, 1.5, 0])
  rotate([-90,0,0])
    %color("red", alpha= 0.85) bar_10inch();

}



if (show_assembly) {
  //assembly_original();
  assembly_10inch();
} else {
  //single_look();
  //  sks8310();
  // rotate([90, 0, 0])
  left_ear_10inch();

  //mount_screw_hole();
}
