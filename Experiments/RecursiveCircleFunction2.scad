//
//  A wobbly circle polygon
//  Sarah Kelley, 8/26/2020
//

radius = 10;  // [0:20]
wobble = $t*20;  // [0:50]
wobbleRadius = 2; // [1:20]
step = 4;     // [1:90]

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
wobblyCircleExtrude(radius, wobble, wobbleRadius, step,
        height=2);


/*
for (z = [0:.1:.5]) {
    translate([0,0,z*3]) rotate([0,0,z*60])
    wobblyCircleExtrude(radius, wobble, wobbleRadius, step,
        height=2);
}
*/