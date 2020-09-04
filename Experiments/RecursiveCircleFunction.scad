//
//  A wobbly circle made out of cubes
//  Sarah Kelley, 8/26/2020
//

radius = 10;  // [0:20]
wobble = 12;  // [0:50]
step = 4;     // [1:90]
cubeSize = 1.0; // [0.1:10]

function circleFnRecurse(r, wobble, deg, step, prev) =
    ((deg < 0) || (deg >= 360))
    ?  prev
    : let (bar=r-sin(deg*wobble))
        circleFnRecurse(r, wobble, deg+step, step, 
            concat(prev,[[bar*sin(deg),bar*cos(deg)]]));

function circleFn(r, wobble, step) =
    circleFnRecurse(r, wobble, 0, step, []);


circlePoints = circleFn(radius, wobble, step);

for (p = circlePoints) {
    translate([p[0],p[1],0]) {
        cube([cubeSize, cubeSize, 1], center=true);
    }
}
