
use <mounting.scad>

show_assembly = !true;

e = 1/64;


rack_stl = "tl-sg108pe.stl";
//short_rack_stl = "tl-sg108pe-rackmount-no-logo.stl";


width = 158;
depth = 100.7;
height = 25.4;

slot_distance_from_front = 51.5;
distance_between_slots = 110.0;

module single_look() {

  intersection() {
    modified_import();
    *translate([-79,-87, 9]) %sg108_enclosure();
  }

  translate([-79,-87, 9]) %sg108_enclosure();
  translate([-26, 24, 5+e]) %power_brick();

}

module modified_import () {

  difference () {
    translate([0,0,0]) import(rack_stl);

    // strip previous mounting crosses
    translate([-79,-87, 9+e]) sg108_enclosure();
  }


  // position updated half crosses
  x1 = -55.0;
  x2 = x1 + distance_between_slots;

  y = -35.5;
  z = 9-e;
  //z = 0;

  translate([x1, y, z]) mount_post();
  translate([x2, y, z]) mount_post();

}


module sg108_enclosure () {

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

module power_brick() {

  cube([104, 57, 37]);
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

module assembly() {

}

if (show_assembly) {
  assembly();
} else {
  single_look();
  //generate_ridge();
  //sg108_enclosure();
    single_look();

}
