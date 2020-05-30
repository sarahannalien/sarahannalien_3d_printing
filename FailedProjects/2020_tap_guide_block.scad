include <Sarah_2020_Extrusion.scad>

//
//  DOES NOT WORK WELL.
//  TOLERANCE ISSUES.
//  WILL NOT FIT IN EXTRUSION AS-IS.
//

module m5TapGuideBlockFor2020Extrusion(
    h = 30,
    tapDiameter = 5.15
) {
    module label(msg, size=3, height=0.5) {
        translate([0,0,h/2])
        linear_extrude(height=0.8)
            text(text=msg, size=size, halign="Center", valign="center");
    }
    
    union() {
        intersection() {
            difference() {
                // basic shape of the guide block
                cube([20,20,h], center=true);
                
                // subtract out extrusion from bottom half
                // (so bottom half will fit inside the extrusion channels
                translate([0,0,-h/2])
                    scale([1, 1, 1])
                        extrusion2020(h=h, tolerance=0.92);
                //t = 1.2;  // tolerance
                //translate([0,0,-h/2])
                //    scale([t, t, 1])
                //        extrusion2020(h=h);
                
                // Guide hole
                // cut a hole big enough for the M5 tap to fit through
                cylinder(h=h*1.01, d=tapDiameter, center=true, $fn=180);

                labelDepth = 0.8;
                translate([-6,7.5,-labelDepth+0.01]) 
                    label("M5 Tap");
                translate([-6,4.5,-labelDepth+0.01]) 
                    label("Guide");
                translate([-9,-7,-labelDepth+0.01]) 
                    label("5-19-2020");
                
            }
            // Curve the bottom parts a bit to make it easier to fit inside
            translate([0,0,-40]) cylinder(h=3*h, d1=0, d2=60, center=false, $fn=180);
        }
    }
}

m5TapGuideBlockFor2020Extrusion();
//translate([0,0,-10]) extrusion2020(h=20);
//translate([0,0,-30]) cylinder(h=30, d1=0, d2=20, center=false);