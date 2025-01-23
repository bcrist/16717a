thickness = 0.6;
radius = 1;
main_length = 15.4;
main_height = 6.1 - thickness/2;

$fn = 16;

color("#aaa") {

difference() {
    width = 15;
    cutout_length = 7.8;
    cutout_depth = main_height - 3.5;
    inner_length = 12;
    inner_width = 6.3;
    
    union() linear_extrude(height = main_length, center = true, convexity = 3) {
        translate([-width/2, (main_height-radius)/2, 0]) square([thickness, main_height - radius], center = true);
        translate([width/2, (main_height-radius)/2, 0]) square([thickness, main_height - radius], center = true);
        translate([0, main_height, 0]) square([width - 2*radius, thickness], center = true);
        
        translate([-width/2 + radius, main_height-radius, 0]) difference() {
            circle(radius + thickness/2);
            circle(radius - thickness/2);
            translate([radius, 0, 0]) square([radius*2, radius*3], center = true);
            translate([0, -radius, 0]) square([radius*3, radius*2], center = true);
        }
        
        translate([width/2 - radius, main_height-radius, 0]) difference() {
            circle(radius + thickness/2);
            circle(radius - thickness/2);
            translate([-radius, 0, 0]) square([radius*2, radius*3], center = true);
            translate([0, -radius, 0]) square([radius*3, radius*2], center = true);
        }
    }
    
    translate([-width/2, main_height, 0]) cube([radius * 2, cutout_depth*2, cutout_length], center = true);
    translate([width/2, main_height, 0]) cube([radius * 2, cutout_depth*2, cutout_length], center = true);
    translate([0, main_height, main_length/2]) cube([inner_width, thickness+1, main_length - inner_length], center = true);
    translate([0, main_height, -main_length/2]) cube([inner_width, thickness+1, main_length - inner_length], center = true);
}


// inner sides
union() {
    height = 9 - main_height;
    length = 7.7;
    translate([-7 + thickness/2, main_height + height/2 - thickness/4, 0]) cube([thickness, height + thickness/2, length], center = true);
    translate([7 - thickness/2, main_height + height/2 - thickness/4, 0]) cube([thickness, height + thickness/2, length], center = true);
}

// inner top/bottom
union() {
    width = 5.7;
    height = 7.6 - main_height;
    translate([0, main_height + height/2 - thickness/4, 6 + thickness/2]) cube([width, height + thickness/2, thickness], center = true);
    translate([0, main_height + height/2 - thickness/4, -6 - thickness/2]) cube([width, height + thickness/2, thickness], center = true);
}

// outer top/bottom
rotate([0, 90, 0])
difference() {
    length = 19;
    width = 11.2;
    height = 9;
    
    cutout_width = 6.3;
    cutout_height = (height - 1.6) - main_height;

    union() linear_extrude(height = width, center = true, convexity = 3) {
    
        translate([-length/2, height - (height-main_height-radius)/2, 0]) square([thickness, height - main_height - radius], center = true);
        translate([length/2, height - (height-main_height-radius)/2, 0]) square([thickness, height - main_height - radius], center = true);
        translate([0, main_height, 0]) square([length - 2*radius, thickness], center = true);
        
        translate([-length/2 + radius, main_height+radius, 0]) difference() {
            circle(radius + thickness/2);
            circle(radius - thickness/2);
            translate([radius, 0, 0]) square([radius*2, radius*3], center = true);
            translate([0, radius, 0]) square([radius*3, radius*2], center = true);
        }
        
        translate([length/2 - radius, main_height+radius, 0]) difference() {
            circle(radius + thickness/2);
            circle(radius - thickness/2);
            translate([-radius, 0, 0]) square([radius*2, radius*3], center = true);
            translate([0, radius, 0]) square([radius*3, radius*2], center = true);
        }
    
    }
    
    translate([-length/2, main_height, 0]) cube([length-12, cutout_height*2, cutout_width], center = true);
    translate([length/2, main_height, 0]) cube([length-12, cutout_height*2, cutout_width], center = true);
}
}