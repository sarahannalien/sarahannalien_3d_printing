w = 80;
l = 80;
d = 60;
thickness = 2;
holeSizeFactor = 1.3;
postSpacing = 15;
postSize = 4;
t2 = thickness * 2;
$fn=36;

module basicBox() {
    difference() {
        cube([w,l,d], center=true);
        translate([0,0,thickness]) cube([w-t2, l-t2, d-thickness], center=true);
    }
}

module boxWithHorizontalHoles() {
    difference() {
        basicBox();
        ws = w*holeSizeFactor;
        ls = l*holeSizeFactor;
        for (z=[thickness:3*thickness:d]) {
            rotate([0,0,30]) translate([0,0,-(d/2)+z]) cube([ws,ls,thickness], center=true);
        }
    }
}

module postsForBox() {
    union() {
      
        for (y=[-(l/2)+(thickness/2), (l/2)-(thickness/2)]) {
            offset = y < 0 ? postSpacing/2 : 0;
            for (x=[-(w/2)+(postSpacing/3):postSpacing:(w/2)-(postSpacing/3)]) {
                translate([x+offset, y, 0])
                    cylinder(d=postSize, h=d, center=true);
            }
        }
    
        for (x=[-(w/2)+(thickness/2), (w/2)-(thickness/2)]) {
            offset = x < 0 ? postSpacing/2 : 0;
            for (y=[-(l/2)+(postSpacing):postSpacing:(l/2)-(postSpacing)]) {
                translate([x, y+offset, 0])
                    cylinder(d=postSize, h=d, center=true);
            }
        }
    }
}


union() {
    boxWithHorizontalHoles();
    postsForBox();
}