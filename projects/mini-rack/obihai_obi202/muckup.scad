
show_assembly = !true;

e = 1/64;

universal_customized_stl = "universal_10inch_rack-obi202.stl";

width = 114;
depth = 105;
height = 30;

/* [Hidden] */

// STL offsets

module single_look() {
  //%obi202();
  customized_universal();
}

module obi202 () {
  translate([width, 0, 0]) rotate ([-90, 180, 0])
    difference() {
    //color("darkblue")
    cube ([width, depth, height]);

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
  }

}

module assembly_10inch() {

  ys_y_offset = (44.45 - height) / 2;
  ys_x_offset = (bar_10inch_width - width) / 2;

  translate([0, 0, 0]) color("grey") customized_universal();

  %translate([ys_x_offset, ys_y_offset, 0])
     color("darkblue", alpha=0.8)
     obi202();

   //translate([-2, -6, 33-1.5])
  translate([0.0, 1.5, 0])
  rotate([-90,0,0])
    %color("red", alpha= 0.85) bar_10inch();

}

if (show_assembly) {
  assembly_10inch();
} else {
  single_look();
  //  obi202();

}
