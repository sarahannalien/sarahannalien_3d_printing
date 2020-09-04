//
//  A wobbly circle polygon
//  Sarah Kelley, 8/26/2020
//

//radius = 8.2;  // [0:20]
//wobble = 6;  // [0:50]
//wobbleRadius = 0.4; // [1:20]
//step = 4;     // [1:90]

module wobblyCircleExtrude(
    radius=10, wobble=6, wobbleRadius=2, step=4, 
    height=10,
    convexity=10) 
{        
    function circleFn(r, wobble, wobbleRadius, deg) =
        let(bar=r-(sin(deg*wobble)*wobbleRadius))
            [bar*sin(deg),bar*cos(deg)];

    circlePoints = [for (deg=[0:step:360]) 
        circleFn(radius,wobble, wobbleRadius, deg)];
    circlePath = 
        concat([ for (i=[0:len(circlePoints)-1]) i ],0);
    
    linear_extrude(height=height, center=true, convexity=convexity)
        polygon(circlePoints, [circlePath]);
}

module tester() {
    thickness = 3;
    shoulderThickness = 1;
    bearingMountThickness = 7;
    shoulderDiameter = 11;
    bearingMountDiameter = 7.2;
    bearingMountWobble = 24;
    bearingMountWobbleRadius = 0.4;
    bearingMountStep = 2;
    cube([14,thickness,14],center=true);
    translate([0,(thickness/2)+(shoulderThickness/2),0])
        rotate([90,0,0]) 
            cylinder(d=shoulderDiameter,h=shoulderThickness,center=true, $fn=36);
    translate([0,(thickness/2)+(shoulderThickness/2)+(bearingMountThickness/2),0]) 
        rotate([90,0,0]) wobblyCircleExtrude(bearingMountDiameter/2, 
            bearingMountWobble, bearingMountWobbleRadius, bearingMountStep,
        height=bearingMountThickness);
}

module spindle(
    bearingWidth = 7,
    bearingDiameter = 23, // 22 was too small with 0.4mm nozzle,
    spindleDiameter = 28,
    spindleLength = 20
)
{
    difference() {
        cylinder(d=spindleDiameter, h=spindleLength, center=true, $fn=72);
        translate([0,0,(spindleLength/2)-(bearingWidth/2)+0.1])
            cylinder(d=bearingDiameter, h=bearingWidth, center=true, $fn=72);
        translate([0,0,-(spindleLength/2)+(bearingWidth/2)-0.1])
            cylinder(d=bearingDiameter, h=bearingWidth, center=true, $fn=72);

    }
}

tester();
//spindle();
/*
for (z = [0:.1:.5]) {
    translate([0,0,z*3]) rotate([0,0,z*60])
    wobblyCircleExtrude(radius, wobble, wobbleRadius, step,
        height=2);
}
*/