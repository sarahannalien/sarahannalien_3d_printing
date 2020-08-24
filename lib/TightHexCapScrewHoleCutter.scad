

module screwHoleCutter(headDiameter=4.96, headHeight=2.6, innerDiameter=3, 
        numThings=8, thingThickness=0.5, 
        shaftLength=44, shaftDiameter=2.88) {
    step = 360 / numThings;
    thingyDiameter = ((headDiameter/2)-(innerDiameter/2)) * 1.2;
    thingyHeight = headHeight*1.1;
    translate([0,0,-headHeight/2])difference() {
        union() {
            cylinder(d=headDiameter, h=headHeight, center=true);
            translate([0,0,-(shaftLength/2)-(headHeight/2)+0.1])
                cylinder(d=shaftDiameter, h=shaftLength, center=true);
        }
        for (r=[0:step:360]) {
            rotate([0, 0, r]) 
                translate([0, innerDiameter / 2, -thingyHeight/2]) 
                    cube([thingThickness, thingyDiameter, thingyHeight]);
        }
    }
}

module screwHoleCutter2(headDiameter=5.1, headHeight=2.6, innerDiameter=3, 
        numThings=8, thingThickness=0.5, 
        shaftLength=44, shaftDiameter=3) {
    step = 360 / numThings;
    thingyDiameter = ((headDiameter/2)-(innerDiameter/2)) * 1.2;
    thingyHeight = headHeight*1.1;
    translate([0,0,-headHeight/2])difference() {
        union() {
            cylinder(d=headDiameter, h=headHeight, center=true);
            translate([0,0,-(shaftLength/2)-(headHeight/2)+0.1])
                cylinder(d=shaftDiameter, h=shaftLength, center=true);
        }
        for (r=[0:step:360]) {
            rotate([0, 0, r]) 
                translate([0, headDiameter / 2, -thingyHeight/2]) 
                    
                    cylinder(d=thingyDiameter, h=thingyHeight);
        }
    }
}

module screwHoleCutterTest() {
    t = 4;
    tz = (t/2)+(t/100);
    difference() {
        cube([50,7,t], center=true);
        translate([-20,0,tz])screwHoleCutter2(innerDiameter=3.5);
        translate([-10,0,tz])screwHoleCutter2(innerDiameter=4.0);
        translate([0,0,tz])screwHoleCutter2(innerDiameter=4.5);
        translate([10,0,tz])screwHoleCutter2(innerDiameter=4.0, numThings=4);
        translate([20,0,tz])screwHoleCutter2(innerDiameter=4.5, numThings=4);
    }
}

screwHoleCutterTest($fn=45);
