

show_assembly = !true;

is_tappable = false;

e = 1/64;


center_to_center = 17;
// 3 + c2c + 7 is full span
length = 3 + center_to_center + 3;
width = 3 + 3 + 3;

default_thickness = 3.0;

// M2.5 has diameter of 2.5mm
m2p5_punch_radius_tappable = (2.5 - 0.15) / 2;
m2p5_punch_radius_slideable = (2.5 + 0.4) / 2;



module m2p5_screw_punch(radius = m2p5_punch_radius_slideable,  thickness = default_thickness) {

  linear_extrude(height = thickness + 2*e) {
    circle(r=radius, $fn=50);
  }
}

module main_block() {

  radius = is_tappable ? m2p5_punch_radius_tappable : m2p5_punch_radius_slideable;

  difference () {
    cube([length, width, default_thickness]);

    translate([3 , (width / 2) , -e])
      m2p5_screw_punch(radius = radius, thickness = 10);

    translate([3 + center_to_center, (width / 2), -e])
      m2p5_screw_punch(radius = radius, thickness = 10);


  }

}


module m2p5_post (height = 8) {

  linear_extrude(height = height) {
    difference () {
      circle(r = 2.5);
      circle(r = m2p5_punch_radius_slideable, $fn=50);
    }
  }
}


post_height = 8;

module assembly() {

  translate([0,0, post_height]) {
    main_block();
  }

  translate([3, (width / 2), 0]) {
    m2p5_post();
  }

  translate([3 + center_to_center, (width / 2), 0]) {
    m2p5_post();
  }
}

if (show_assembly) {
  assembly();
} else {
  //M2p5_screw_punch_tappable();
  main_block();
}
