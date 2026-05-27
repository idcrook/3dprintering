/*

  Enclosure for panel, charger, battery, xiao, and mic

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
DEVELOPING_enclosure_model = true;

use <../libraries/MCAD/2Dshapes.scad>
use <../libraries/dotSCAD/src/rounded_square.scad>

include <lipo_rider_pro.scad>
include <solar_panel_3W.scad>
include <liion_battery.scad>

// very small number
e = 1/128;

// charger board
charger_w = board_w;
charger_l = board_l;
charger_h = board_h_total;

// battery
battery_w = battery_width; // Width of the battery
battery_l = battery_length; // Length of the battery
battery_h = battery_thickness; // Height of the battery


/* [Panel Dimensions] */
panel_w = panel_width; // Width of the panel
panel_l = panel_length; // Length of the panel
panel_t = panel_thickness; // Thickness of the panel

/* [Frame Profile] */
frame_w = 10;   // Frame border width
frame_h = 8;    // Total height of the frame
inset_h = 4;    // Height of the inner slot (holds panel)
wall_t = 3;     // Outer wall thickness

/* [Mounting Tabs] */
tab_w = 15;     // Width of the mounting tabs
tab_h = 3;      // Thickness of the mounting tabs
hole_d = 4.2;   // Screw hole diameter (e.g., M4 screw)

module solar_frame() {
    difference() {
        // Outer frame
        cube([panel_w + (wall_t * 2), panel_l + (wall_t * 2), frame_h], center = true);

        // Inner cutout for the solar panel
        translate([0, 0, (frame_h - inset_h) / 2])
            cube([panel_w, panel_l, inset_h + 0.1], center = true);

        // Cutout for the solar cells / face
        translate([0, 0, -0.1])
            cube([panel_w - (frame_w * 2), panel_l - (frame_w * 2), frame_h], center = true);
    }

    // Mounting tabs (Centered along the Length axis)
    for (y = [1, -1]) {
        translate([0, y * (panel_l / 2 + wall_t + (tab_w / 2)), (frame_h - tab_h) / 2]) {
            difference() {
                // Tab body
                cube([panel_w + (wall_t * 2), tab_w, tab_h], center = true);

                // Mounting hole
                translate([0, 0, -1])
                    cylinder(h = tab_h + 2 + e, d = hole_d, center = true, $fn = 32);
            }
        }
    }
  translate ([-panel_w/2, -panel_l/2, (inset_h-panel_t)]) %solar_panel_3W ();

}

module solar_frame_standard() {
  translate ([(1/2) * (panel_w) + wall_t, (1/2) * (panel_l) + tab_w + wall_t, 0]) solar_frame();

}

module solar_battery_case () {

  open = false;

  z_add = open ? 3*12 : 2*12;

  %import ("solar_battery_case_1.3mf");
  %translate ([0, 2*88, z_add]) rotate([180, 0, 0]) import ("solar_battery_case_2.3mf");

  translate ([charger_w + 45, 14.5, 13 + 1]) rotate ([0,180,0]) lipo_rider_pro(show_keepouts = true);
  //translate ([board_w + 45, board_l + 14.5, 13]) rotate ([0,0,180])lipo_rider_pro(show_keepouts = true);

}


module solar_battery_case () {

  open = false;

  z_add = open ? 3*12 : 2*12;

  %import ("solar_battery_case_1.3mf");
  %translate ([0, 2*88, z_add]) rotate([180, 0, 0]) import ("solar_battery_case_2.3mf");

  translate ([charger_w + 45, 14.5, 13 + 1]) rotate ([0,180,0]) lipo_rider_pro(show_keepouts = true);
  //translate ([board_w + 45, board_l + 14.5, 13]) rotate ([0,0,180])lipo_rider_pro(show_keepouts = true);

}

module bee_lipo() {

  size_y = 143;
  translate ([0, size_y,0]) {
    %rotate([90, 0, 0]) import ("BEE-LIPO-H30.STL");
    %translate ([0, 0, 30]) rotate([90, 0, 0]) import ("BEE-LIPO-TOP.STL");

  }
  translate ([(size_y / 2) + 24.5, 46, 9]) rotate ([0,0,90]) lipo_rider_pro(show_keepouts = true);
  translate ([battery_l + 35, 10, 2]) rotate([0,0,90]) battery_3mAh();
}


// $preview requires version 2019.05
$fn = $preview ? 50 : 100;

if (DEVELOPING_enclosure_model)  {
  //translate ([0,0,0]) %lipo_rider_pro(show_keepouts = true);

  // Render the frame
  %translate([5, 12, 40]) solar_frame_standard();

  rotate([0,0,0]) solar_battery_case();
  *bee_lipo();
}
