
length = 1.5;
width = 0.75;
body_thickness = 0.25;
termination_thickness = 0.05;
termination_length = 0.25;


color("#fff") translate([0, 0, body_thickness/2 + termination_thickness]) cube([length, width, body_thickness], center = true);

color("#aaa") translate([-length/2 + termination_length/2 - termination_thickness, 0, body_thickness/2 + termination_thickness])
    cube([termination_length, width - termination_thickness, body_thickness + termination_thickness * 2], center = true);
    
color("#aaa") translate([length/2 - termination_length/2 + termination_thickness, 0, body_thickness/2 + termination_thickness])
    cube([termination_length, width - termination_thickness, body_thickness + termination_thickness * 2], center = true);
    
    
color("#eee") translate([0, width/4, body_thickness + termination_thickness * 1.5]) cube([length - termination_length * 2, width/2, termination_thickness], center = true);
color("#393") translate([0, -width/4, body_thickness + termination_thickness * 1.5]) cube([length - termination_length * 2, width/2, termination_thickness], center = true);