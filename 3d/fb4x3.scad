pins = 2;
pin_pitch = 5.08;
pin_width = 1.25;
pin_seating = 1.4;
leadframe_thickness = 0.13;

overall_width = 4.5;
body_width = 4;
body_length = 3;
body_thickness_lower = 1.2;
body_thickness_upper = 1.3;

total_thickness = 2.65;

body_length_bevel = 0;
body_width_bevel = 0;
body_chamfer = 0;


leadframe_height = total_thickness - body_thickness_upper;


body();


translate([pin_pitch * ((pins / 2) - 1) / -2, overall_width / 2, 0]) for(n = [0 : pins / 2 - 1]) {
    translate([pin_pitch * n, 0, 0]) pin();
}
rotate([0, 0, 180]) translate([pin_pitch * ((pins / 2) - 1) / -2, overall_width / 2, 0]) for(n = [0 : pins / 2 - 1]) {
    translate([pin_pitch * n, 0, 0]) pin();
}


module pin() {
    color("#999") rotate([90, 0, 90]) linear_extrude(height = pin_width, center = true) {
        pin_length = (overall_width - body_width) / 2;
        polygon([
            [-pin_seating, 0],
            [0, 0],
            [0,           leadframe_height + leadframe_thickness/2],
            [-pin_length, leadframe_height + leadframe_thickness/2],
            [-pin_length, leadframe_height - leadframe_thickness/2],
            [-leadframe_thickness, leadframe_height - leadframe_thickness/2],
            [-leadframe_thickness, leadframe_thickness],
            [-pin_seating, leadframe_thickness],
        ]);
    }
}


module body() {
    color("#555") translate([0, 0, leadframe_height]) {
        linear_extrude(height = leadframe_thickness, center = true) body_outline();
        linear_extrude(
            height = body_thickness_upper,
            scale = [(body_length - body_length_bevel) / body_length, (body_width - body_width_bevel) / body_width]
        ) body_outline();
        
        rotate([180, 0, 0]) linear_extrude(
            height = body_thickness_lower,
            scale = [(body_length - body_length_bevel) / body_length, (body_width - body_width_bevel) / body_width]
        ) body_outline();
    }
}
module body_outline() {
    polygon([
        [ -body_length/2 + body_chamfer, -body_width/2 ],
        [ -body_length/2               , -body_width/2 + body_chamfer ],
        [ -body_length/2               , +body_width/2 - body_chamfer ],
        [ -body_length/2 + body_chamfer, +body_width/2 ],
        [ +body_length/2 - body_chamfer, +body_width/2 ],
        [ +body_length/2               , +body_width/2 - body_chamfer ],
        [ +body_length/2               , -body_width/2 + body_chamfer ],
        [ +body_length/2 - body_chamfer, -body_width/2 ],
    ]);
}