
e = 1/64;

slot_width = 4.0;
L_leg_length = 11; // possibly 12
extent_length = 14.0;

center_diameter = 9.0;


module ridge_outline () {

  both_inset = 0.5;
  inset = both_inset / 2;
  ridge_width = slot_width - 0.5;
  half_ridge_width = ridge_width / 2;

  L_vert_to_horiz_start = 6.5; // measured is 7.0

  ridge_center_radius = (center_diameter - 1.0) / 2;

  rotate([0, 0, 180])
  union () {
    square([ridge_width, L_vert_to_horiz_start + half_ridge_width]);
    translate([half_ridge_width, L_vert_to_horiz_start + half_ridge_width]) {
      circle(d = ridge_width, $fn = 48);
    }

    square([L_vert_to_horiz_start + half_ridge_width, ridge_width]);
    translate([L_vert_to_horiz_start + half_ridge_width, half_ridge_width]) {
      circle(d = ridge_width, $fn = 48);
    }

    translate([half_ridge_width,
               half_ridge_width]) {
      circle(r = ridge_center_radius, $fn = 48);
    }
  }
}

module generate_ridge (height = 2.0 + 1.0) {

  linear_extrude(h = height) {
    ridge_outline();
  }

}


if (!true) {
  //ridge_outline();
  generate_ridge(height = 2.0 + 1.5 + 0.5);
 } else {

  h = 3;
  translate ([-3/2 + 1, -3/2 + 1, 0]) cube([10 + 3, 10 + 3, h]);
  translate ([10, 10, h-e]) { generate_ridge(height = 2.0 + 1.0); }

 }
