

show_assembly = true;

e = 1/128;

rack_model_stl = "rpi-2_3_4_5b-10i-rm-v1_2.stl";

keystone_stl = "keystone-v2.stl";
keystone_tool_stl = "keystone-v2-keystone-hole-tool.stl";


// yolink hub YS1603
yo_width = 87.0;
yo_depth = 87.0;
yo_height = 27.0;

// rpi 3b
rpi_width = 56.5;
rpi_depth = 85.6;
rpi_height = 27.0; // allow for some height on dupont connectors in GPIO header

/* [Hidden] */

fudge = 0.2;
column_width = 18.0;

module single_look() {
  intersection() {
    modified_import();
  }
}

module audio_cable_punchout () {
  $fn = 48;
  diameter = 10.5;

  cylinder(h = 3 + 2 + 2*e, r = diameter/2);
}

module keystone_punchout () {
  x = 81.5;
  y = 129.7;
  z = 1;
  translate([x, y, z])
    import(keystone_tool_stl);
}

module keystone_insert () {
  x = 82.5;
  y = 131;
  z = 1;
  translate([x, y, z])
    import(keystone_stl);
}

module modified_import () {

  ks1_Q = false;
  ks2_Q = false;
  audio_hole_Q = true;

  h_1u = 44.5; // 44.45 is spec
  w_10in = 254.0;

  mid_y = h_1u / 2;
  mid_x = w_10in / 2;

  ks_x = mid_x - 16.5;
  ks_y = mid_y - 14;
  ks_z = 0;

  ks2_x = w_10in - 47;
  ks2_y = mid_y - 14;
  ks2_z = 0;

  au_x = 28.5 + 0.5;
  au_y = mid_y ;
  au_z = 0;

  if (ks1_Q) {
    translate([ks_x, ks_y, ks_z])
      keystone_insert();
  }
  if (ks2_Q) {
    translate([ks2_x, ks2_y, ks2_z])
      keystone_insert();
  }

  difference () {
    union() {
      translate([mid_x, mid_y, 0])
        rotate([0,0,0])
        import(rack_model_stl);
      translate([0,0, 3])
        rotate([0,0,0])
        %cube([column_width, h_1u, column_width]);
      translate([w_10in - column_width, 0, 3])
        rotate([0,0,0])
        %cube([column_width, h_1u, column_width]);
    }

    // punch a hole for keystone inserts
    if (ks1_Q) {
      translate([ks_x, ks_y, ks_z - e])
        keystone_punchout();
    }

    if (ks2_Q) {
      translate([ks2_x, ks2_y, ks2_z-e])
        keystone_punchout();
    }

    // punch a hole for keystone inserts
    if (audio_hole_Q) {
      translate([au_x, au_y, au_z - e])
        audio_cable_punchout();
    }
  }
}



module yolink_hub () {
  difference() {
    color("white")
    union() {
      cube ([yo_width, yo_depth, yo_height]);
    }
  }
}

module rpi () {
  difference() {
    color("green")
    cube ([rpi_width, rpi_depth, rpi_height]);
  }
}



module assembly() {

  yolink_on_left = true;

  yo_left_x = (1/2)*254 + 20;
  yo_left_y = yo_height + 14;
  yo_left_z = 3+e + 1.0;

  yo_right_x = +45;
  yo_right_y = yo_left_y;
  yo_right_z = yo_left_z;

  rpi_right_x = +48;
  rpi_right_y = yo_left_y;
  rpi_right_z = 0;


  // intersection() {
    modified_import();

    if (yolink_on_left) {
      translate([yo_left_x, yo_left_y, yo_left_z])
        rotate([90,0, 0])
        %yolink_hub();
    } else {
      translate([yo_right_x, yo_right_y, yo_right_z])
        rotate([90,0, 0])
        %yolink_hub();
    }

    translate([rpi_right_x, rpi_right_y, rpi_right_z])
      rotate([90,0, 0])
      %rpi();

    // }

}

if (show_assembly) {
  assembly();
} else {
  //single_look();
  //keystone_punchout();
  //keystone_insert();
  audio_cable_punchout();


}
