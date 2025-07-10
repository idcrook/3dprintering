
use <mounting.scad>

show_assembly = !true;

e = 1/64;

//rack_model = "./u1-10-inch-rack-mount-for-raspberry-pi-4-and-tl-sg105-model_files/1u-rack-raspberry-pi-4-model-b-and-tl-sg105-v6.stl";
rack_model = "./repaired-1u-rack-raspberry-pi-4-model-b-and-tl-sg105-v6.obj";

width = 100;
depth = 98.0;
height = 25;

slot_distance_from_front = 49.5;
distance_between_slots = 52.0;

rack_switch_elevation = 10;
fudge = 0.2;

module single_look() {

  intersection() {
    modified_import();
    //translate([0.5, 0, rack_switch_elevation + fudge]) %sg105_enclosure();
  }

  translate([0.5, 0, rack_switch_elevation]) %sg105_enclosure();

}

module modified_import () {

  honeycomb_thickness = 4.0;
  depth_cut_start = 18.0 - (true ? 3.0 : 0.0);
  depth_cut_extend = depth ;
  height_cut_extend = height + 10;

  sidewall_thickness = 4.0;
  mesh_area_length = 25.0 + 3.5;
  sidewall_cut_start = depth - mesh_area_length;

  difference () {
    translate([9.0 +0.5,0,0])
      rotate([-90,0,0])
      import(rack_model);

    // cut away above switch
    translate([0 + e, depth_cut_start, rack_switch_elevation+e])
      cube([0.5 + width + 0.5 -2*e, depth_cut_extend, height_cut_extend]);

    // cut rear sidwalls around cooling mesh in enclosure
    translate([0, sidewall_cut_start, rack_switch_elevation+e]) {

      translate([-honeycomb_thickness - e, 0, 0])
        cube([sidewall_thickness + 3*e, mesh_area_length + 6+e, height_cut_extend]);

      translate([0.5 + width + 0.5 - 2*e, 0, 0])
        cube([sidewall_thickness + 3*e, mesh_area_length + 6+e, height_cut_extend]);

    }


  }


  // position updated half crosses
  //x1 = 24.0;
  x1 = (width - distance_between_slots)/2;
  x2 = x1 + distance_between_slots;

  y = slot_distance_from_front;
  z = rack_switch_elevation-e;

  translate([x1 + 0.5, y, z]) mount_post();
  translate([x2 + 0.5, y, z]) mount_post();

}


module sg105_enclosure () {

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

  support_height=4;
  support_leg = 16;
  union() {

    translate([2, -2, -(support_height/2)+e])
      rotate([0,0,0])
      cube([support_leg, support_leg, support_height], center = true);
    generate_ridge() {}
  }
}

module assembly() {
  import ("10-inch-rack-mount-for-raspberry-pi-4-and-tl-sg105e.stl");
  translate([0.5, 0, rack_switch_elevation]) color("darkblue") %sg105_enclosure();


}

if (show_assembly) {
  assembly();
} else {
  single_look();
  //generate_ridge();
  //sg108_enclosure();


}
