inner1 = 3.2;
inner2 = 3.5;
nozzle = 0.4;
outer1 = inner1 + (8*nozzle);
outer2 = inner2 + (8*nozzle);
length = 10;

module standoff(inner, outer, length) {
    difference() {
        cylinder(d=outer, h=length, center=true);
        cylinder(d=inner, h=length+1, center=true);
    }
}
/*
for (y=[-25:10:25]) {
    translate([-5,y,0]) standoff(inner1, outer1, length, $fn=90);
}
*/
for (y=[-25:10:25]) {
    translate([5,y,0]) standoff(inner2, outer2, length, $fn=90);
}
