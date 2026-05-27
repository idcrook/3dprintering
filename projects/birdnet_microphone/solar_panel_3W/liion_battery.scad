/*

  Li-ion 3000 mAh battery model

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
DEVELOPING_liion_battery_model = false;

// very small number
e = 1/128;

battery_length = 56;
battery_width= 34;
battery_thickness = 16;

// TODO: model electrical wire attachments
battery_attach_positive_x = 0;
battery_attach_positive_y = 0;
battery_attach_negative_x = 0;
battery_attach_negative_y = 0;



module battery_3mAh (length = battery_length, width = battery_width, height = battery_thickness, show_keepouts = false) {

  cube ([width, length, height]);

}

// $preview requires version 2019.05
$fn = $preview ? 50 : 100;

if (DEVELOPING_liion_battery_model)  {
  battery_3mAh(show_keepouts = true);
  echo ("battery height: ", battery_thickness);
  echo ("battery width: ", battery_width);
  echo ("battery length: ", battery_length);

}
