pins = 8;
pin_pitch = 1.27;
pin_width = 0.43;
pin_seating = 0.8;
pin_gull_angle = 5;
leadframe_thickness = 0.25;

overall_width = 6.2;
body_width = 3.9;
body_length = 4.9;
body_thickness = 1.5;

total_thickness = 1.7;

body_length_bevel = 0.25;
body_width_bevel = 0.5;
body_chamfer = 0.2;


leadframe_height = total_thickness - body_thickness/2;

index_mark_offset = min(min(body_width, body_length) * 0.3, 1.5);
index_mark_radius = min(index_mark_offset / 3, 0.5);


difference() {
    body();
    color("#ddd") translate([
        -body_length / 2 + index_mark_offset,
        -body_width / 2 + index_mark_offset,
        total_thickness - 0.1,
    ]) cylinder(h = 10, r = index_mark_radius, $fn=32);
}


translate([pin_pitch * ((pins / 2) - 1) / -2, overall_width / 2, 0]) for(n = [0 : pins / 2 - 1]) {
    translate([pin_pitch * n, 0, 0]) pin();
}
rotate([0, 0, 180]) translate([pin_pitch * ((pins / 2) - 1) / -2, overall_width / 2, 0]) for(n = [0 : pins / 2 - 1]) {
    translate([pin_pitch * n, 0, 0]) pin();
}


module pin() {
    color("#999") rotate([90, 0, 90]) linear_extrude(height = pin_width, center = true) {
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


module body() {
    color("#555") translate([0, 0, leadframe_height]) {
        linear_extrude(height = leadframe_thickness, center = true) body_outline();
        linear_extrude(
            height = body_thickness / 2,
            scale = [(body_length - body_length_bevel) / body_length, (body_width - body_width_bevel) / body_width]
        ) body_outline();
        
        rotate([180, 0, 0]) linear_extrude(
            height = body_thickness / 2,
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