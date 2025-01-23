pin_pitch_x = 2.54;
pin_pitch_y = 1.905;
pin_width = 0.5;
through_hole_depth = 2.54;

mating_length = 5;
mating_offset_y = 4.285;

mating_connector_height = 6;
mating_connector_width = 40;
overall_width = 50.75;

shroud_thickness = 1;
shroud_length = 5.4;
base_thickness = 5;

mating_connector_vertical_center = mating_connector_height / 2 + shroud_thickness;
top_row_height = mating_connector_vertical_center + 1.27;
bottom_row_height = mating_connector_vertical_center - 1.27;

$fn = 32;


color("#444") 
    difference() 
    {
    union() {
        // shroud
        translate([0, -mating_offset_y, mating_connector_vertical_center]){
            // left
            translate([-(mating_connector_width + shroud_thickness)/2, -shroud_length/2, 0])
                cube([shroud_thickness, shroud_length, mating_connector_height + shroud_thickness*2], center = true);
            // right
            translate([+(mating_connector_width + shroud_thickness)/2, -shroud_length/2, 0])
                cube([shroud_thickness, shroud_length, mating_connector_height + shroud_thickness*2], center = true);
                
            // bottom
            translate([0, -shroud_length/2, -shroud_thickness/2 - mating_connector_height/2])
                cube([mating_connector_width + shroud_thickness*2, shroud_length, shroud_thickness], center = true);
                
            // top
            translate([0, -shroud_length/2, shroud_thickness/2 + mating_connector_height/2]) {
                translate([-mating_connector_width/4 - 1.1 - shroud_thickness/2, 0, 0])
                    cube([mating_connector_width/2 - 2.2 + shroud_thickness, shroud_length, shroud_thickness], center = true);
                translate([mating_connector_width/4 + 1.1 + shroud_thickness/2, 0, 0])
                    cube([mating_connector_width/2 - 2.2 + shroud_thickness, shroud_length, shroud_thickness], center = true);
            }
                
            // bottom
            translate([0, base_thickness/2, 0])
                cube([mating_connector_width + shroud_thickness*2, base_thickness, mating_connector_height + shroud_thickness*2], center = true);
        }

        // pin insulators
        translate([-pin_pitch_x * 7.5, pin_pitch_y * 1.5, top_row_height/2]) {
            for (x = [1 : 29]) translate([x * pin_pitch_x/2, 0, 0]) {
                cube([pin_width, pin_pitch_y * 3 + pin_width, top_row_height], center = true);
            }
            translate([-pin_width, 0, 0]) cube([pin_width*3, pin_pitch_y * 3 + pin_width, top_row_height], center = true);
            translate([pin_width + pin_pitch_x*15, 0, 0]) cube([pin_width*3, pin_pitch_y * 3 + pin_width, top_row_height], center = true);
        }

        // wings
        translate([mating_connector_width/2, -mating_offset_y - shroud_length + 1.2, 0]) {
            cube([(overall_width - mating_connector_width)/2, 6, mating_connector_height + shroud_thickness*2]);
            cube([(overall_width - mating_connector_width)/2, 11.2, top_row_height/2]);
        }
        scale([-1, 1, 1]) translate([mating_connector_width/2, -mating_offset_y - shroud_length + 1.2, 0]) {
            cube([(overall_width - mating_connector_width)/2, 6, mating_connector_height + shroud_thickness*2]);
            cube([(overall_width - mating_connector_width)/2, 11.2, top_row_height/2]);
        }
    }
    
    union() {
        // mounting holes
        translate([22, -mating_offset_y - shroud_length + 1.2 + 6.3 + 1, -0.1]) {
            cylinder(h = mating_connector_height + shroud_thickness*3, r = 1);
            translate([-1, 0, 0]) cube([2, 10, mating_connector_height + shroud_thickness * 3]);
            translate([0, 0, 2]) cylinder(h = mating_connector_height + shroud_thickness*3, r = 2);
            translate([-2, 0, 2]) cube([4, 10, mating_connector_height + shroud_thickness * 3]);
        }
        translate([-22, -mating_offset_y - shroud_length + 1.2 + 6.3 + 1, -0.1]) {
            cylinder(h = mating_connector_height + shroud_thickness*3, r = 1);
            translate([-1, 0, 0]) cube([2, 10, mating_connector_height + shroud_thickness * 3]);
            translate([0, 0, 2]) cylinder(h = mating_connector_height + shroud_thickness*3, r = 2);
            translate([-2, 0, 2]) cube([4, 10, mating_connector_height + shroud_thickness * 3]);
        }
    }
}

// pins
translate([-pin_pitch_x * 7.25, pin_pitch_y * 3, 0]) for (x = [0 : 14]) {
    translate([x * pin_pitch_x, 0, 0]) {
        upper_length = mating_length + mating_offset_y + pin_pitch_y * 3 + pin_width / 2;
        translate([0, -upper_length/2, top_row_height - pin_width/2]) cube([pin_width, upper_length, pin_width], center = true);
        translate([0, 0, top_row_height /2]) cube([pin_width, pin_width, top_row_height], center = true);
        translate([0, 0, -through_hole_depth/2]) cube([pin_width, pin_width, through_hole_depth], center = true);
        
        translate([0, -pin_pitch_y * 2, 0]) {
            lower_length = mating_length + mating_offset_y + pin_pitch_y + pin_width / 2;
            translate([0, -lower_length/2, bottom_row_height - pin_width/2]) cube([pin_width, lower_length, pin_width], center = true);
            translate([0, 0, bottom_row_height /2]) cube([pin_width, pin_width, bottom_row_height], center = true);
            translate([0, 0, -through_hole_depth/2]) cube([pin_width, pin_width, through_hole_depth], center = true);
        }
    }   
}
translate([-pin_pitch_x * 6.75, pin_pitch_y * 2, 0]) for (x = [0 : 14]) {
    translate([x * pin_pitch_x, 0, 0]) {
        upper_length = mating_length + mating_offset_y + pin_pitch_y * 2 + pin_width / 2;
        translate([0, -upper_length/2, top_row_height - pin_width/2]) cube([pin_width, upper_length, pin_width], center = true);
        translate([0, 0, top_row_height /2]) cube([pin_width, pin_width, top_row_height], center = true);
        translate([0, 0, -through_hole_depth/2]) cube([pin_width, pin_width, through_hole_depth], center = true);
        
        translate([0, -pin_pitch_y * 2, 0]) {
            lower_length = mating_length + mating_offset_y + pin_width / 2;
            translate([0, -lower_length/2, bottom_row_height - pin_width/2]) cube([pin_width, lower_length, pin_width], center = true);
            translate([0, 0, bottom_row_height /2]) cube([pin_width, pin_width, bottom_row_height], center = true);
            translate([0, 0, -through_hole_depth/2]) cube([pin_width, pin_width, through_hole_depth], center = true);
        }
    }
}


