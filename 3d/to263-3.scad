body_width = 10.5;
body_width_chamfer = 0.5;

body_length = 9.3;
body_length_chamfer = 0.5;

body_height = 4.5;

tab_length = 1.525;
tab_chamfer_angle = 15;
tab_chamfer_offset = 0.75;
tab_height = 1.3;

pin_pitch = 2.54;
pin_length = 3.9;
pin_width = 1.27;
pin_seating = 1.98;
pin_gull_angle = 15;
leadframe_height = 2.5;
leadframe_thickness = 0.5;

overall_width = body_width + 2*pin_length;


color("#111") difference() {
    translate([0, 0, body_height/2]) cube([body_width, body_length, body_height], center = true);
    
    rotate([90, 0, 0]) linear_extrude(center = true, convexity = 2) {
        polygon([
            [body_width/2, tab_height],
            [body_width/2 - body_width_chamfer, body_height + 0.05],
            [body_width, body_height + 0.05],
            [body_width, tab_height],
        ]);
        polygon([
            [-body_width/2, tab_height],
            [-body_width/2 + body_width_chamfer, body_height + 0.05],
            [-body_width, body_height + 0.05],
            [-body_width, tab_height],
        ]);
    }
    
    rotate([90, 0, 90]) linear_extrude(center = true, convexity = 2) {
        polygon([
            [body_length/2, tab_height],
            [body_length/2 - body_length_chamfer, body_height + 0.05],
            [body_length, body_height + 0.05],
            [body_length, tab_height],
        ]);
        polygon([
            [-body_length/2 + body_length_chamfer, -0.05],
            [-body_length/2, leadframe_height - leadframe_thickness/2],
            [-body_length/2, leadframe_height + leadframe_thickness/2],
            [-body_length/2 + body_width_chamfer, body_height + 0.05],
            [-body_length, body_height + 0.05],
            [-body_length, -0.05],
        ]);    
    }
}

color("#aaa") {
    // tab
    difference() {
        translate([0, body_length/2 + tab_length/2, tab_height/2]) cube([body_width, tab_length, tab_height], center = true);
        translate([0, body_length/2 + tab_length*1.5 + tab_chamfer_offset, tab_height/2]) {
            rotate([0, 0, tab_chamfer_angle]) cube([body_width*1.5, tab_length, tab_height * 2], center = true);
            rotate([0, 0, -tab_chamfer_angle]) cube([body_width*1.5, tab_length, tab_height * 2], center = true);
        }
    }
    
    // pins
    translate([0, -body_length/2 - pin_length, 0]) for (p = [-1 : 1]) translate([pin_pitch * p, 0, 0]) {
        rotate([0, 0, 180]) pin();
    }
}

module pin() {
    rotate([90, 0, 90]) linear_extrude(height = pin_width, center = true) {
        gull_offset = leadframe_height - leadframe_thickness / 2;
        pin_length = (overall_width - body_width) / 2;
        sine = sin(pin_gull_angle);
        cosine = cos(pin_gull_angle);
        polygon([
            [0, 0],
            [-pin_seating, 0],
            [-pin_seating - sine * gull_offset, gull_offset],
            [-pin_length, gull_offset],
            [-pin_length, gull_offset + leadframe_thickness],
            [-pin_seating - sine * (gull_offset + leadframe_thickness) + cosine * leadframe_thickness, gull_offset + leadframe_thickness],
            [-pin_seating - sine * leadframe_thickness + cosine * leadframe_thickness, leadframe_thickness],
            [0, leadframe_thickness],
        ]);
    }
}
