pin_pitch = 2.54;
pin_length = 3;
pin_offset_y = 7.87;
pin_width = 0.7;
pin_thickness = 0.3;

header_pin_diameter = 0.5;

overall_width = 98;
overall_height = 6;
shroud_height = 5.9;

shroud_center_z = overall_height - shroud_height + shroud_height/2;

upper_row_z = shroud_center_z + 1.27;
lower_row_z = shroud_center_z - 1.27;

front_pin_height = lower_row_z - header_pin_diameter/2;
back_pin_height = upper_row_z - header_pin_diameter/2;

$fn = 16;

for (x = [0 : 35]) {
    translate([x * -pin_pitch, 0, 0]) {
        translate([0, 0, -pin_length/2]) cube([pin_width, pin_thickness, pin_length], center = true);
        translate([0, 0, front_pin_height/2]) cube([pin_width, pin_thickness, front_pin_height], center = true);
        translate([0, pin_offset_y, -pin_length/2]) cube([pin_width, pin_thickness, pin_length], center = true);
        translate([0, pin_offset_y, back_pin_height/2]) cube([pin_width, pin_thickness, back_pin_height], center = true);
    }
}

// shroud
color("#531") difference() {
    translate([-17.5*pin_pitch, pin_offset_y/2, shroud_center_z]) cube([overall_width, pin_offset_y - pin_thickness*2, shroud_height], center = true);
    for (x = [0 : 35]) {
        translate([x * -pin_pitch, 0, 0]) {
            translate([0, pin_offset_y/2, upper_row_z]) cube([header_pin_diameter*2, pin_offset_y, header_pin_diameter*2], center = true);
            translate([0, pin_offset_y/2, lower_row_z]) cube([header_pin_diameter*2, pin_offset_y, header_pin_diameter*2], center = true);
        }
    }
    translate([-17.5*pin_pitch, 0, shroud_center_z]) {
        translate([overall_width / 2, 0, 0]) rotate([-90, 0, 0]) cylinder(h = pin_offset_y, r = 3.7/2);
        translate([-overall_width / 2, 0, 0]) rotate([-90, 0, 0]) cylinder(h = pin_offset_y, r = 3.7/2);
    }
}
