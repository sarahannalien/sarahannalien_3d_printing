
/*
---------87.5-----------------+
  bracket...... 3mm thick     |
--------------------------+   21
           |        | 10  |   |
           |stepper |     |   |
            |        |     +---+
           +--42.3--+

thickness = 3mm
10mm gap before stepper motor


nema 17 stepper
  30.99 mm between holes
  42.3mm size of body
  hole for shaft is 22mm
  raised part of motor to fit in hole is 2mm
*/

module ExtruderMotorBracket(
    thickness = 3,
    width = 87.5,
    depth = 21,
    spaceLeftOfStepper = 10,
    stepperBodySize = 42.3,
    stepperHoleDistance = 30.99,
    stepperHoleDiameter = 3.5,
    stepperShaftHole = 22.5,
    stepperShoulderProtrusion = 2,
    stepperSpacing = 10,  // spacing between our two steppers
    e = 0.01) 
{

    module base() {
        difference() {
            cube([width, (2*stepperBodySize), depth+thickness], center = true);
            translate([thickness,0,-thickness])
                cube([width+e, (2*stepperBodySize)+e, depth+e], center = true);
        }
    }
    //base();
    module stepperHoles(h) {
        cylinder(d=stepperShaftHole, h=h, center=true);
        i = stepperHoleDistance/2;
        translate([-i,-i,0]) cylinder(d=stepperHoleDiameter, h=h, center=true);
        translate([-i, i,0]) cylinder(d=stepperHoleDiameter, h=h, center=true);
        translate([ i,-i,0]) cylinder(d=stepperHoleDiameter, h=h, center=true);
        translate([ i, i,0]) cylinder(d=stepperHoleDiameter, h=h, center=true);
    }
    difference() {
        cube([stepperBodySize*1.2, stepperBodySize*1.2,2], center=true);
        stepperHoles(h=4, $fn=90);
    }
}


ExtruderMotorBracket();
