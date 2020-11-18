//
//   Modular Drum Kit System: First Experiment
//
//   Copyright (C) 2020 Sarah Kelley, sarah@sakelley.org
//
//   Still a work in progress! 11/16/2020 SK

MountingBlockSize = 15;

MountingBlockHeight = 15;
MountingBlockWidth = 25;

MountingBlockCount = 12;

MountingBlockHoleDiameter = 4.2; // 4.2 mm hole for M4 bolts
MountingBlockHoleSpacing = 14;  // space between the center of the two holes

HeadMountX = 15;  // adjusts how far out the tab sticks from the rim.
HeadMountY = 20;  // adjusts z height of bracket. Make larger if overhang is too steep.
HeadMountZ = 15;  // adjusts the spacing of the two triangular parts!
HeadMountCount = 6;
HeadMountOffsetAngle = (360/12)/2;

module HeadMountingBracket(sizeX=HeadMountX, sizeY=HeadMountY, sizeZ=HeadMountZ, thickness=2) {
    color("orange") rotate([-90,0,0]) translate([0,thickness,-sizeZ/2]) {
        for (t=[0,sizeZ-thickness]) {
            translate([0,0,t])
                linear_extrude(height=thickness)
                    polygon([[0,0],[0,sizeY],[sizeX,0]]);
        }
        translate([0,-thickness,0]) cube([sizeX, thickness, sizeZ]);
    }
}

module HollowCylinder(d=20, h=10, thickness=2, center=true) {
    difference() {
        cylinder(d=d, h=h, center=true);
        cylinder(d=d-(2*thickness), h=h*1.1, center=true);
    }
}

module SphericalCylinder(d=20, h=10, thickness=2, center=true) {
    difference() {
        sphere(d=d);
        cylinder(d=d-(2*thickness), h=h*1.1, center=true);
    }
}

module DrumCylinder(d=100, h=40, thickness=4,
        mbSize = MountingBlockSize,
        mbHeight = MountingBlockHeight,
        mbWidth = MountingBlockWidth,
        mbCount = MountingBlockCount,
        mbHoleDiameter = MountingBlockHoleDiameter,
        mbHoleSpacing = MountingBlockHoleSpacing,
        hmCount = HeadMountCount,
        hmOffsetAngle = HeadMountOffsetAngle
) {
            
    module mountingHole(ang) {
        t = mbHoleSpacing/2;
        rotate([0,0,ang]) 
            translate([t,d/2,(-h/2)+mbSize/2]) 
                rotate([90,0,0]) 
                    cylinder(d=mbHoleDiameter, h=35.5*thickness, center=true, $fn=36);
        rotate([0,0,ang]) 
            translate([-t,d/2,(-h/2)+mbSize/2]) 
                rotate([90,0,0]) 
                    cylinder(d=mbHoleDiameter, h=35.5*thickness, center=true, $fn=36);
    }
    
    module headMount(ang) {
        translate([0,0,(h/2)+0.01]) 
            rotate([0,0,ang]) 
                translate([(d/2)-(thickness/3),0,0]) 
                    HeadMountingBracket();
    }
    
    module headHole(ang) {
        z = (h/2)+(thickness/2)-0.1;
        rotate([0,0,ang]) 
            translate([(d/2) - (thickness/3) + (HeadMountX/2),0,z]) 
                // rotate([90,0,0]) 
                    cylinder(d=mbHoleDiameter, h=3.5*thickness, center=true, $fn=36);
    }
    
    module stressReliefHole(ang) {
        rotate([0,0,ang]) 
            translate([0,d/2,(-h/2)+(2*thickness/2)-0.1]) 
                rotate([90,0,0]) 
                    cube([2*thickness,2*thickness,4*thickness], center=true);
    }
    
    module mountingBlock(ang) {
        rotate([0,0,ang]) 
            translate([0,d/2-(thickness/2),(-h/2)+mbSize/2]) 
                rotate([90,0,0]) 
                    cube([mbWidth, mbHeight, 2*thickness], center=true);
    }
    
    
    difference() {
        union() {
            HollowCylinder(d=d, h=h, thickness=thickness, center=true);
            for (ang=[0:360/mbCount:360-1]) mountingBlock(ang);
            for (ang=[0:360/hmCount:360-1]) headMount(ang+hmOffsetAngle);
            //translate([0,0,(h/2)+(thickness/2)-0.1])
            //    HollowCylinder(d=d+(2*mbSize)-(2*thickness), 
            //        h=thickness, thickness=mbSize, center=true);
        }
        for (ang=[0:360/mbCount:360-1]) mountingHole(ang);
        for (ang=[0:360/hmCount:360-1]) headHole(ang+hmOffsetAngle);
        //for (ang=[0:360/mbCount:360-1]) stressReliefHole(ang+hmOffsetAngle);
    }
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
DrumCylinder(d=110, $fn=180);


//HeadMountingBracket();
