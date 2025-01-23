ferrite_length = 10;
ferrite_diameter = 6;
pin_diameter = 0.6;
pin_length = 3.5;
pin1_origin = [1.3, -ferrite_diameter/2, 6.3];
pin2_origin = [-1.3, -ferrite_diameter/2, -6.3];

hole_diameter = pin_diameter * 1.5;

$fn = 16;

h0 = [1.3, -1.4, 0];
h1 = [1.3, 1.4, 0];
h2 = [0, -1.9, 0];
h3 = [0, 1.9, 0];
h4 = [-1.3, -1.4, 0];
h5 = [-1.3, 1.4, 0];

back_side = [0, 0, -ferrite_length/2 + 0.5];
front_side = [0, 0, ferrite_length/2 - 0.5];

color("#666") difference() {
    cylinder(h = ferrite_length, d = ferrite_diameter, center = true, $fn = 32);
    translate(h0) cylinder(h = ferrite_length+1, d = hole_diameter, center = true);
    translate(h1) cylinder(h = ferrite_length+1, d = hole_diameter, center = true);
    translate(h2) cylinder(h = ferrite_length+1, d = hole_diameter, center = true);
    translate(h3) cylinder(h = ferrite_length+1, d = hole_diameter, center = true);
    translate(h4) cylinder(h = ferrite_length+1, d = hole_diameter, center = true);
    translate(h5) cylinder(h = ferrite_length+1, d = hole_diameter, center = true);
}


color("#aaa") {
    translate(h0) cylinder(h = ferrite_length - 1, d = pin_diameter, center = true);
    //translate(h1) cylinder(h = ferrite_length - 1, d = pin_diameter, center = true);
    translate(h2) cylinder(h = ferrite_length - 1, d = pin_diameter, center = true);
    translate(h3) cylinder(h = ferrite_length - 1, d = pin_diameter, center = true);
    translate(h4) cylinder(h = ferrite_length - 1, d = pin_diameter, center = true);
    translate(h5) cylinder(h = ferrite_length - 1, d = pin_diameter, center = true);
    
    loop1_center = (h0 + h3) / 2;
    loop1_radius = norm(h0 - h3)/2;
    loop1_angle = atan2((h0 - h3).y, (h0 - h3).x);
    translate(loop1_center + back_side) rotate([270, 0, loop1_angle]) rotate_extrude(angle = 180) translate([loop1_radius, 0]) circle(d = pin_diameter);
    
    loop2_center = (h2 + h3) / 2;
    loop2_radius = norm(h2 - h3)/2;
    loop2_angle = atan2((h2 - h3).y, (h2 - h3).x);
    translate(loop2_center + front_side) rotate([90, 0, loop2_angle]) rotate_extrude(angle = 180) translate([loop2_radius, 0]) circle(d = pin_diameter);
    
    loop3_center = (h2 + h5) / 2;
    loop3_radius = norm(h2 - h5)/2;
    loop3_angle = atan2((h2 - h5).y, (h2 - h5).x);
    translate(loop3_center + back_side) rotate([270, 0, loop3_angle]) rotate_extrude(angle = 180) translate([loop3_radius, 0]) circle(d = pin_diameter);
    
    loop4_center = (h4 + h5) / 2;
    loop4_radius = norm(h4 - h5)/2;
    loop4_angle = atan2((h4 - h5).y, (h4 - h5).x);
    translate(loop4_center + front_side) rotate([90, 0, loop4_angle]) rotate_extrude(angle = 180) translate([loop4_radius, 0]) circle(d = pin_diameter);
    
    translate(pin1_origin + [0, -pin_length/2, 0]) rotate([90, 0, 0]) cylinder(h = pin_length, d = pin_diameter, center = true);
    pin1_arc_end = h0 + front_side;
    pin1_arc_radius = abs(pin1_origin.y - pin1_arc_end.y);
    pin1_arc_center = pin1_origin + [0, 0, -pin1_arc_radius];
    translate(pin1_arc_center) rotate([90, 0, 90]) rotate_extrude(angle = 90) translate([pin1_arc_radius, 0]) circle(d = pin_diameter);
    translate(h0 + front_side) cylinder(h = 2 * abs(pin1_arc_end.z - pin1_arc_center.z), d = pin_diameter, center = true);
    
    translate(pin2_origin + [0, -pin_length/2, 0]) rotate([90, 0, 0]) cylinder(h = pin_length, d = pin_diameter, center = true);
    pin2_arc_end = h4 + back_side;
    pin2_arc_radius = abs(pin2_origin.y - pin2_arc_end.y);
    pin2_arc_center = pin2_origin + [0, 0, pin2_arc_radius];
    translate(pin2_arc_center) rotate([270, 0, 90]) rotate_extrude(angle = 90) translate([pin2_arc_radius, 0]) circle(d = pin_diameter);
    translate(h4 + back_side) cylinder(h = 2 * abs(pin2_arc_end.z - pin2_arc_center.z), d = pin_diameter, center = true);
    
}