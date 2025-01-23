pins = 100;
pin_pitch = 0.5;
pin_width = 0.22;
pin_seating = 0.6;
pin_gull_angle = 10;
leadframe_thickness = 0.14;

overall_width = 16;
overall_length = 16;
body_width = 14;
body_length = 14;
body_thickness = 1;
total_thickness = 1.3;

body_bevel = 0.3;
body_chamfer = 0.4;
body_chamfer_index = 0.6;


leadframe_height = total_thickness - body_thickness/2;

index_mark_offset = min(min(body_width, body_length) * 0.4, 1.5);
index_mark_radius = min(index_mark_offset / 3, 0.5);


difference() {
    body();
    color("#ddd") translate([
        -body_length / 2 + index_mark_offset,
        -body_width / 2 + index_mark_offset,
        total_thickness - 0.1,
    ]) cylinder(h = 10, r = index_mark_radius, $fn=32);
}


translate([pin_pitch * ((pins / 4) - 1) / -2, overall_width / 2, 0]) for(n = [0 : pins / 4 - 1]) {
    translate([pin_pitch * n, 0, 0]) pin();
}
rotate([0, 0, 90]) translate([pin_pitch * ((pins / 4) - 1) / -2, overall_width / 2, 0]) for(n = [0 : pins / 4 - 1]) {
    translate([pin_pitch * n, 0, 0]) pin();
}
rotate([0, 0, 180]) translate([pin_pitch * ((pins / 4) - 1) / -2, overall_width / 2, 0]) for(n = [0 : pins / 4 - 1]) {
    translate([pin_pitch * n, 0, 0]) pin();
}
rotate([0, 0, 270]) translate([pin_pitch * ((pins / 4) - 1) / -2, overall_width / 2, 0]) for(n = [0 : pins / 4 - 1]) {
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
            scale = [(body_length - body_bevel) / body_length, (body_width - body_bevel) / body_width]
        ) body_outline();
        
        scale([1, 1, -1]) linear_extrude(
            height = body_thickness / 2,
            scale = [(body_length - body_bevel) / body_length, (body_width - body_bevel) / body_width]
        ) body_outline();
    }
}
module body_outline() {
    polygon([
        [ -body_length/2 + body_chamfer_index, -body_width/2 ],
        [ -body_length/2               , -body_width/2 + body_chamfer_index ],
        [ -body_length/2               , +body_width/2 - body_chamfer ],
        [ -body_length/2 + body_chamfer, +body_width/2 ],
        [ +body_length/2 - body_chamfer, +body_width/2 ],
        [ +body_length/2               , +body_width/2 - body_chamfer ],
        [ +body_length/2               , -body_width/2 + body_chamfer ],
        [ +body_length/2 - body_chamfer, -body_width/2 ],
    ]);
}