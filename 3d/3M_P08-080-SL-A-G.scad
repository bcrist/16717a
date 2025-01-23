body_width = 4.93;
body_length = 35.4;
body_height = 2.2;

overall_width = 5.88;

chamfer_length = 1.0;

pins = 80;
pin_pitch = 0.8;
pin_width = 0.35;
pin_thickness = 0.2;

color("#cca") difference() {
    translate([0, 0, pin_thickness]) linear_extrude(height = body_height - pin_thickness) {
        polygon([
            [-body_length/2, -body_width/2],
            [body_length/2, -body_width/2],
            [body_length/2, body_width/2 - sqrt(chamfer_length/2)],
            [body_length/2 - sqrt(chamfer_length/2), body_width/2],
            [-body_length/2 + sqrt(chamfer_length/2), body_width/2],
            [-body_length/2, body_width/2 - sqrt(chamfer_length/2)],
        ]);
    }
    
    translate([0, 0, body_height/2 + pin_thickness + 0.1]) cube([33, 1.5, body_height], center = true);
}

color("#fd1") translate([-pin_pitch * 19.5, 0, pin_thickness/2]) for (x = [0 : 39]) {
    translate([x * pin_pitch, 0, 0]) {
        cube([pin_width, overall_width, pin_thickness], center = true);
    
        translate([0, 0.9, body_height/2]) cube([pin_width, 0.75, body_height], center=true);
        translate([0, -0.9, body_height/2]) cube([pin_width, 0.75, body_height], center=true);
    }
}
