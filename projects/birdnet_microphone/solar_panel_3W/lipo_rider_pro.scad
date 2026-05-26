/*

  Seeedstudio LiPo Rider Pro 1.1 model

  Modeled by David Crook - https://github.com/idcrook

  2026-May-26

  Thingiverse:

  Printables:

  GitHub: https://github.com/idcrook/3dprintering/tree/main/projects/birdnet_microphone/solar_panel_3W

  NOTES:

  - OpenSCAD generation relies on MCAD library (https://github.com/openscad/MCAD)
  - See README.md for other notes.
*/

// * All measurements in millimeters * //

// If true, model is instantiated by this file
DEVELOPING_lipo_rider_pro_model = false;

use <../libraries/MCAD/2Dshapes.scad>
use <../libraries/dotSCAD/src/rounded_square.scad>

// very small number
e = 1/128;

// Board Dimensions (LiPo Rider Pro)
board_w = 50;    // Width of board
board_l = 68;    // Length of board
board_h_total = 10;   // Height of board (highest)
board_pcb_h = 1.6;   // PCB thickness

mount_hole_D = 3.1; // M3 machine screws
mount_hole_inset = 2.5; //
mount_hole_spacing_x = board_w - 2 * (mount_hole_inset);
mount_hole_spacing_y = board_l - 2 * (mount_hole_inset); //FIXME

usb_mini_b_position__mid =  board_w /2; // FIXME
usb_mini_b__keepout_x = 14;
usb_mini_b__keepout_z = 10;
usb_mini_b__keepout_size = 20;

// Connector Base: The raw JST PH header sits roughly 4.8 mm deep and 6.0 mm tall off the board
// Mating Clearance: The female plug extends past the header. It needs at least 6.5 mm of horizontal width and 5.0 mm of depth.
// Wire Bend Radius: Wires exit the back of the plug straight up or straight out. Give yourself at least 6.0 mm of vertical room above the plug just for the wire bend.
// Finger Access: Add 2.0 mm to 3.0 mm of extra space on the sides if you need to squeeze the friction lock to pull the plug out.
// Wall Openings: If the plug passes through a printed wall, make the cutout 7.0 mm wide by 5.5 mm high so the shroud fits easily.

jst_2p0_panel_position__mid =  board_w - 11; // FIXME
jst_2p0_panel__keepout_x = 7.0;
jst_2p0_panel__keepout_z = 5.5;
jst_2p0_panel__keepout_size = 6 + 6;

jst_2p0_battery_position__mid = 0 + 11; // FIXME
jst_2p0_battery__keepout_x = 7.0;
jst_2p0_battery__keepout_z = 5.5;
jst_2p0_battery__keepout_size = 6 + 6;

usb_a_output_position__mid =  board_w - 16; // FIXME
usb_a_output__keepout_x = 14;
usb_a_output__keepout_z = 10;
usb_a_output__keepout_size = 20;

switch_position__mid =  20; // FIXME
switch__keepout_x = 14;
switch__keepout_z = 10;
switch__keepout_size = 20;

level_button_position_y__mid = 18; // FIXME
level_button__keepout_x = 14;
level_button__keepout_z = 10;
level_button__keepout_size = 20;



module usb_mini_b__keepout (width = usb_mini_b__keepout_x, height = usb_mini_b__keepout_z,
                            length = usb_mini_b__keepout_size) {

  %color("red", alpha = 0.5) cube ([width, length, height]);
}

module jst_2p0__keepout (width = jst_2p0_panel__keepout_x, height = jst_2p0_panel__keepout_z,
                         length = jst_2p0_panel__keepout_size) {

  %color("red", alpha = 0.5) cube ([width, length, height]);
}

module mount_hole_punch (diameter = mount_hole_D, punch_height = 12) {

  linear_extrude(height = punch_height, center = false, convexity = 10, twist = 0, slices = 20, scale = 1.0) {
    circle(r = diameter/2);
  }
}



module lipo_rider_pro (length = board_l, width = board_w, height = board_pcb_h, show_keepouts = false) {

  difference() {
    cube ([width, length, height]);

    translate([mount_hole_inset,
               mount_hole_inset, -e]) { mount_hole_punch(); }
    translate([mount_hole_inset + mount_hole_spacing_x,
               mount_hole_inset, -e]) { mount_hole_punch(); }
    translate([mount_hole_inset,
               mount_hole_inset + mount_hole_spacing_y, -e]) { mount_hole_punch(); }
    translate([mount_hole_inset + mount_hole_spacing_x,
               mount_hole_inset + mount_hole_spacing_y, -e]) { mount_hole_punch(); }
  }

  // TODO: model button and connector keepouts
  if (show_keepouts) {
    translate([usb_mini_b_position__mid - (1/2) * usb_mini_b__keepout_x, -usb_mini_b__keepout_size, 0])
      usb_mini_b__keepout();
    translate([jst_2p0_panel_position__mid - (1/2) * jst_2p0_panel__keepout_x, -jst_2p0_panel__keepout_size, 0])
      jst_2p0__keepout();
    translate([jst_2p0_battery_position__mid - (1/2) * jst_2p0_battery__keepout_x, -jst_2p0_panel__keepout_size, 0])
      jst_2p0__keepout();
  }
}

// $preview requires version 2019.05
$fn = $preview ? 50 : 100;

if (DEVELOPING_lipo_rider_pro_model)  {
  lipo_rider_pro(show_keepouts = true);
  echo ("height: ", board_pcb_h);
  echo ("width: ",  board_w);
  echo ("length: ", board_l);
  echo ("total height: ", board_h_total);

}
