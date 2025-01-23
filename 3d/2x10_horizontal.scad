pin_pitch_x = 1.27;
pin_pitch_y = 2.54;
pin_width = 0.4;
pin_height = 8.1-2.5;
pin_depth = 2.5;

shroud_width = 7.2;
shroud_length = 19;
shroud_height = 10;

pin_separator_length = 4;

inset_length = 16;
inset_height = 4.3;
inset_height2 = 4;

internal_width = 5.2;
internal_length = 14;
internal_height = 7.2;

clip_length = 16.6;
clip_width = 3;

index_offset = 6.5 - internal_width;
index_offset3 = 8.5 - shroud_width;
index_width1 = 3;
index_width2 = 5.6;
index_height2 = 4.8;
index_height3 = 1.5;

color("#222") union() translate([-pin_pitch_x * 6, 0, 0]) for (x = [0 : 12]) {
    translate([x * pin_pitch_x, 0, 0]) {
        translate([0, pin_separator_length/2, pin_height/2]) cube([pin_width*1.6, pin_separator_length+2.54, pin_height], center = true);
    }
}

color("#fd1") union() translate([-pin_pitch_x * 4.5, 1.05, 0]) for (x = [0 : 9]) {
    translate([x * pin_pitch_x, 0, 0]) {
        translate([0, pin_separator_length, (pin_height - 0.53 - pin_depth) / 2]) cube([pin_width, pin_width, pin_height + pin_depth - 0.53], center = true);
        translate([0, pin_separator_length-pin_pitch_y, (pin_height - 3.1 - pin_depth) / 2]) cube([pin_width, pin_width, pin_height + pin_depth - 3.1], center = true);
    }
}

color("#fd1") translate([0, 0, shroud_width/2]) rotate([90, 0, 0]) {
    translate([-pin_pitch_x * 4.5, 0, 0]) for (x = [0 : 9]) {
        translate([x * pin_pitch_x, 0, 0]) {
            translate([0, pin_pitch_y/2, (pin_height - pin_depth - 2.54) / 2]) cube([pin_width, pin_width, pin_height + pin_depth + 2.54], center = true);
            translate([0, -pin_pitch_y/2, (pin_height - pin_depth - 0.2) / 2]) cube([pin_width, pin_width, pin_height + pin_depth + 0.2], center = true);
        }
    }
}

color("#222") translate([0, 0, shroud_width/2]) rotate([90, 0, 0]) {
    difference() {
        union() {
            translate([0, 0, shroud_height/2]) cube([shroud_length, shroud_width, shroud_height], center = true);
            translate([0, shroud_width/2 + index_offset3/2, shroud_height - index_height3/2]) cube([index_width2 + 2, index_offset3, index_height3], center = true);
        }
        
        union() {
        translate([0, 0, shroud_height - internal_height/2 + 0.05]) cube([internal_length, internal_width, internal_height], center = true);
        translate([0, 0, shroud_height - internal_height/2 + 0.05]) cube([clip_length, clip_width, internal_height], center = true);
        
        inset_w = (shroud_length - inset_length)/2;
        inset_x = shroud_length/2 - inset_w/2;
        inset_y = shroud_height - inset_height/2;
        translate([-inset_x - 0.05, 0, inset_y + 0.05]) cube([inset_w, shroud_width + 1, inset_height], center = true);
        translate([inset_x + 0.05, 0, inset_y + 0.05]) cube([inset_w, shroud_width + 1, inset_height], center = true);
        
        inset_y2 = inset_height2/2;
        translate([-inset_x - 0.05, 0, inset_y2 - 0.05]) cube([inset_w, shroud_width + 1, inset_height2], center = true);
        translate([inset_x + 0.05, 0, inset_y2 - 0.05]) cube([inset_w, shroud_width + 1, inset_height2], center = true);
        
        translate([0, internal_width/2 + index_offset/2 - 0.05, shroud_height - internal_height/2 + 0.05]) cube([index_width1, index_offset, internal_height], center = true);
        translate([0, internal_width/2 + index_offset/2 - 0.05, shroud_height - index_height2/2 + 0.05]) cube([index_width2, index_offset, index_height2], center = true);
        }
    }
}
