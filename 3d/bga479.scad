ball_pitch = 1.27;
ball_diameter = 0.76;


heat_spreader_thickness = 0.4;
heatsink_thickness= 13.2;

body_width = 40.5;
body_thickness = 1.6;

body_chamfer_index = 0.7;

$fn = 16;

// pins
color("#aaa") {
    for(x = [-14 : 14]) {
        for (y = [-14 : 14]) {
            if (x != -14 || y != -14) {
                if (x < -9 || x > 9 || y < -9 || y > 9) {
                    translate([x * ball_pitch, y * ball_pitch, ball_diameter / 2 -0.05]) sphere(d = ball_diameter);
                }
            }
        }
    }
}

color("#986") body(0, body_thickness);

color("#ca5") heat_spreader(0, heat_spreader_thickness);
color("#333") union() {
    heat_spreader(heat_spreader_thickness, 1);
    difference() {
        heatsink_offset = ball_diameter - 0.1 + body_thickness + heat_spreader_thickness + 3.3;
        body(body_thickness + heat_spreader_thickness + 1, heatsink_thickness - 1);
        for (x = [-5 : 4]) {
            translate([(x+0.5)*3.95, 0, heatsink_offset + heatsink_thickness/2]) cube([1.6, body_width * 2, heatsink_thickness], center = true);
        }
        for (y = [-5 : 4]) {
            translate([0, (y+0.5)*3.95, heatsink_offset + heatsink_thickness/2]) cube([body_width * 2, 2.6, heatsink_thickness], center = true);
        }
    }
}

side_capacitors();
rotate([0, 0, 90]) side_capacitors();
rotate([0, 0, 180]) side_capacitors();
rotate([0, 0, 270]) side_capacitors();


module body(offset, height) {
    translate([0, 0, ball_diameter - 0.1 + offset + height / 2]) {
        linear_extrude(height = height, center = true) {
            polygon([
                [body_width/2, -body_width/2],
                [body_width/2, body_width/2],
                [-body_width/2, body_width/2],
                [-body_width/2, -body_width/2 + 3.4],
                [-body_width/2 + 3.4, -body_width/2],
            ]);
        }
    }
}

module heat_spreader(offset, height) {
    translate([0, 0, ball_diameter - 0.1 + body_thickness + offset + height / 2]) linear_extrude(height = height, center = true) {
        polygon([
            [body_width/2, -body_width/2],
            
            [body_width/2, -body_width/2 + 10.6],
            [body_width/2 - 3, -body_width/2 + 10.6],
            [body_width/2 - 3, -body_width/2 + 10.6 + 7.5],
            [body_width/2, -body_width/2 + 10.6 + 7.5],
            
            [body_width/2, body_width/2 - 10.6 - 7.5],
            [body_width/2 - 3, body_width/2 - 10.6 - 7.5],
            [body_width/2 - 3, body_width/2 - 10.6],
            [body_width/2, body_width/2 - 10.6],
            
            [body_width/2, body_width/2],
            
            [body_width/2 - 10.6, body_width/2],
            [body_width/2 - 10.6, body_width/2 - 3],
            [body_width/2 - 10.6 - 7.5, body_width/2 - 3],
            [body_width/2 - 10.6 - 7.5, body_width/2],
            
            [-body_width/2 + 10.6 + 7.5, body_width/2],
            [-body_width/2 + 10.6 + 7.5, body_width/2 - 3],
            [-body_width/2 + 10.6, body_width/2 - 3],
            [-body_width/2 + 10.6, body_width/2],
            
            [-body_width/2, body_width/2],
            
            [-body_width/2, body_width/2 - 10.6],
            [-body_width/2 + 3, body_width/2 - 10.6],
            [-body_width/2 + 3, body_width/2 - 10.6 - 7.5],
            [-body_width/2, body_width/2 - 10.6 - 7.5],
            
            [-body_width/2, -body_width/2 + 10.6 + 7.5],
            [-body_width/2 + 3, -body_width/2 + 10.6 + 7.5],
            [-body_width/2 + 3, -body_width/2 + 10.6],
            [-body_width/2, -body_width/2 + 10.6],
            
            [-body_width/2, -body_width/2 + 3.4],
            [-body_width/2 + 3.4, -body_width/2],
            
            [-body_width/2 + 10.6, -body_width/2],
            [-body_width/2 + 10.6, -body_width/2 + 3],
            [-body_width/2 + 10.6 + 7.5, -body_width/2 + 3],
            [-body_width/2 + 10.6 + 7.5, -body_width/2],
            
            [body_width/2 - 10.6 - 7.5, -body_width/2],
            [body_width/2 - 10.6 - 7.5, -body_width/2 + 3],
            [body_width/2 - 10.6, -body_width/2 + 3],
            [body_width/2 - 10.6, -body_width/2],
            

        ]);
    }
}

module side_capacitors() {
    translate([body_width/2, 0, ball_diameter - 0.1 + body_thickness]) {
        translate([0, body_width/2 - 10.6 - 7.5/2, 0]) capacitor();
        translate([0, -body_width/2 + 10.6 + 7.5/2, 0]) capacitor();
    }
}

module capacitor() {
    height = 1;
    length = 3.5;
    width = 1.5;
    term_length = 0.5;
    translate([-width/2 - 0.5, 0, height / 2]) {
        color("#cba") cube([width, length, height], center = true);
        color("#aaa") {
            translate([0, length/2 - term_length/2]) cube([width + 0.05, term_length + 0.05, height + 0.05], center = true);
            translate([0, -length/2 + term_length/2]) cube([width + 0.05, term_length + 0.05, height + 0.05], center = true);
        }
    }
}
