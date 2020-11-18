//
//   Modular Drum Kit System: First Experiment
//
//   Copyright (C) 2020 Sarah Kelley, sarah@sakelley.org
//
//   Still a work in progress! 11/16/2020 SK


//
// Joint Mount Parts
//
// These allow multiple drums to be bolted to each other.
// The dimensions are the same for ALL drum diameters
// so that larger and smaller drums can be attached
// together to form a kit.
//

JointMountHeight = 15;

JointMountWidth = 25;

JointMountCount = 12;  // evenly spaced around the drum's diameter.

JointMountHoleDiameter = 4.2; // 4.2 mm hole for M4 bolts

JointMountHoleSpacing = 14;  // space between the center of the two holes




//
//  Head Mount Parts
//
//  These allow the head to be attached to the drum.
//

//  Part I: Head Mount Standards
//  These items comprise the interface between the body
//  and the drum head, and make it easier to design things that
//  will attach to the drum. (It's much easier than, for instance,
//  positioning the holes relative to the mounting brackets.)
HeadMountHoleRimOffset = 8;   // center of hole is tangent to outside diameter plus this offset
HeadMountHoleDiameter = 4.2;  // 4.2 mm hole for M4 bolt
HeadMountCount = 6;           // number of head mount points, evenly spaced

//  Part II: Head Mount Options
//  These items control the size (and thus strength!) of the mounting tabs.
HeadMountX = 18;  // adjusts how far out the tab sticks from the rim.
HeadMountY = 20;  // adjusts z height of bracket. Make larger if overhang is too steep.
HeadMountZ = 18;  // adjusts the spacing of the two triangular parts!
HeadMountThickness = 3;

//  It may be helpful to NOT have the head mounts and the joint mounts line up.
//  (So, for instance, you might be able to get a nut driver in there.)
HeadMountOffsetAngle = (360/JointMountCount)/2;



module HollowCylinder(d=20, h=10, thickness=2, center=true) {
    difference() {
        cylinder(d=d, h=h, center=true);
        cylinder(d=d-(2*thickness), h=h*1.1, center=true);
    }
}


module DrumBody(
        // Basic Parameters for the drum
        d=100,         // outer diameter
        h=40,          // height
        thickness=4,   // wall thickness
        
        // Options for the drum
        stressReliefNotches = false,  // helps control warping when printing (maybe?)

        // Joint Standards
        jmHeight = JointMountHeight,
        jmWidth = JointMountWidth,
        jmCount = JointMountCount,
        jmHoleDiameter = JointMountHoleDiameter,
        jmHoleSpacing = JointMountHoleSpacing,

        // Head Mount Standards
        hmHoleRimOffset = HeadMountHoleRimOffset,
        hmHoleDiameter = HeadMountHoleDiameter,
        hmCount = HeadMountCount,

        // Head Mount Options
        hmX = HeadMountX,
        hmY = HeadMountY,
        hmZ = HeadMountZ,
        hmThickness = HeadMountThickness,
        hmOffsetAngle = HeadMountOffsetAngle
) {

    module headMountingBracketShape(sizeX=hmX, sizeY=hmY, sizeZ=hmZ, t=hmThickness) {
        module triangleShape() {
            linear_extrude(height=t)
                polygon([[0,0],[0,sizeY],[sizeX,0]]);
        }
        module topShape() {
            cube([sizeX, t, sizeZ]);
        }
        module bracketShape() {
            for (tz=[0,sizeZ-t]) {
                translate([0,0,tz]) triangleShape();
            }
            translate([0,-t,0]) topShape();
        }
        rotate([-90,0,0]) 
            translate([0,t,-sizeZ/2])
                bracketShape();
    }
   
    module jointMountingHoles(ang) {
        t = jmHoleSpacing/2;
        rotate([0,0,ang]) 
            translate([t,d/2,(-h/2)+jmHeight/2]) 
                rotate([90,0,0]) 
                    cylinder(d=jmHoleDiameter, h=35.5*thickness, center=true, $fn=36);
        rotate([0,0,ang]) 
            translate([-t,d/2,(-h/2)+jmHeight/2]) 
                rotate([90,0,0]) 
                    cylinder(d=jmHoleDiameter, h=35.5*thickness, center=true, $fn=36);
    }
    
    module headMount(ang) {
        translate([0,0,(h/2)+0.01]) 
            rotate([0,0,ang]) 
                translate([(d/2)-(thickness/3),0,0]) 
                    headMountingBracketShape();
    }
    
    module headMountingHole(ang) {
        z = (h/2)+(thickness/2)-0.1;
        r = (d/2) + hmHoleRimOffset;
        rotate([0,0,ang]) 
            translate([r,0,z]) 
                cylinder(d=hmHoleDiameter, h=3.5*thickness, center=true, $fn=36);
    }
    
    module stressReliefNotch(ang) {
        rotate([0,0,ang]) 
            translate([0,d/2,(-h/2)+(2*thickness/2)-0.1]) 
                rotate([90,0,0]) 
                    cube([2*thickness,2*thickness,4*thickness], center=true);
    }
    
    module jointMountingBlock(ang) {
        rotate([0,0,ang]) 
            translate([0,d/2-(thickness/2),(-h/2)+jmHeight/2]) 
                rotate([90,0,0]) 
                    cube([jmWidth, jmHeight, 2*thickness], center=true);
    }
    
    module main() {
        difference() {
            union() {
                color("lightgreen") 
                    HollowCylinder(d=d, h=h, thickness=thickness, center=true);
                color("pink") 
                    for (ang=[0:360/jmCount:360-1]) 
                        jointMountingBlock(ang);
                color("lightblue") 
                    for (ang=[0:360/hmCount:360-1]) 
                        headMount(ang+hmOffsetAngle);
            }
            for (ang=[0:360/jmCount:360-1]) 
                jointMountingHoles(ang);
            for (ang=[0:360/hmCount:360-1]) 
                headMountingHole(ang+hmOffsetAngle);
            
            // Not sure if this will be needed or not.
            // It works badly at smaller diameters as the notches
            // intersect with the joint blocks.
            if (stressReliefNotches) {
                for (ang=[0:360/jmCount:360-1]) 
                    stressReliefNotch(ang+hmOffsetAngle);
            }
        }
    }
    translate([0,0,h/2]) main();
}


// FIXME: It's a mess.
module SampleDrumKit() {
    translate([-120,0,0]) DrumBody(d=205, $fn=180);
    translate([ 120,0,0]) DrumBody(d=205, $fn=180);
    
    rotate([0,0,36]) translate([0,180,0]) translate([-120,0,0]) DrumBody(d=150, $fn=180);
    rotate([0,0,72]) translate([0,180,0]) translate([-120,0,0]) DrumBody(d=150, $fn=180);    
    
    translate([0,360,0]) translate([-120,0,0]) DrumBody(d=150, $fn=180);
}

// Diameters from 100mm and up will work with these
// block sizes. Can't really go smaller without changing
// the mounting block system.
// I can't go bigger than about 300mm because that's how big
// my printer is...
//
// Thickness should be at least 1.7. Say 2 for safety.
// (Has to do with the head brackets being tangent to a circle;
// we're not doing the right calculations for this, just adding
// a little slop to make it work out!)
//
DrumBody(d=150, $fn=180);
//HeadMountingBracket();
//SampleDrumKit();
