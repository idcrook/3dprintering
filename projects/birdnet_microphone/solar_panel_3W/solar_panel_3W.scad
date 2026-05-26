/*

  Solar Panel (3W) model

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
DEVELOPING_solar_panel_3W_model = false;

// very small number
e = 1/128;

panel_length = 160;
panel_width= 138;
panel_thickness = 2.5;

// TODO: model electrical wire attachments
panel_attach_positive_x = 0;
panel_attach_positive_y = 0;
panel_attach_negative_x = 0;
panel_attach_negative_y = 0;

// echo ("corner_radius: ", iphone_15_pro_max__face_corner_radius);
// echo ("turret scale height:", rear_cam_turret__scale_height_inner_to_outer);
// echo ("turret scale width:", rear_cam_turret__scale_width_inner_to_outer);


module solar_panel_3W (length = panel_length, width = panel_width, height = panel_thickness, show_keepouts = false) {

  cube ([width, length, height]);
  // TODO: model electrical wire attachments

}

// $preview requires version 2019.05
$fn = $preview ? 50 : 100;

if (DEVELOPING_solar_panel_3W_model)  {
  solar_panel_3W(show_keepouts = true);
  echo ("panel height: ", panel_thickness);
  echo ("panel width: ", panel_width);
  echo ("panel length: ", panel_length);

}
