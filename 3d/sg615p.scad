pins = 4;
pin_pitch = 5.08;
pin_width = 0.51;
pin_seating = 1.6;
leadframe_thickness = 0.35;

overall_width = 9.75;
body_width = 8.75;
body_length = 14;
body_thickness_lower = 1.4;
body_thickness_upper = 2.9;

total_thickness = 4.7;

body_length_bevel = 1.0;
body_width_bevel = 1.0;
body_chamfer = 0.5;


leadframe_height = total_thickness - body_thickness_upper;

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