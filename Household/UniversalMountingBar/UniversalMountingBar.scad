
// How thick is the shelf?
Shelf_Thickness = 16.5;

// Overhang above shelf?
Upper_Overhang = 60;

// Overhang below shelf
Lower_Overhang = 30;

// Slight tilt so we fit on firmly
Overhang_Angle = 15;

// Total width we will generate, >= to Nut_Spacing!
Width = 60;

// General thickness of OUR part
Thickness = 2;

// How far apart to space the nuts
Nut_Spacing = 20;

M5_Square_Nut_Size = 8.5;  // measured 8.0
M5_Square_Nut_Thickness = 4.5; // measured 3.8
M5_Clearance_Hole = 5.5;

M4_Square_Nut_Size = 7;
M4_Square_Nut_Thickness = 3.1;
M4_Clearance_Hole = 4.5;

M3_Square_Nut_Size = 5.5;
M3_Square_Nut_Thickness = 2.5;
M3_Clearance_Hole = 3.4;

//
//  Adjust based on your preferred nut size
//
Square_Nut_Size = M5_Square_Nut_Size;
Square_Nut_Thickness = M5_Square_Nut_Thickness;
Clearance_Hole = M5_Clearance_Hole;

Square_Nut_Extra_Depth = 0.5;
Front_Thickness = (2*Thickness) + Square_Nut_Thickness;


module Thingy() {
    
    // Compute start and end nut positions.
    // Evenly distribute extra space at each end.
    usableWidth = floor(Width/Nut_Spacing) * Nut_Spacing;
    echo("usableWidth", usableWidth);
    leftover = (Width - usableWidth) > 0 ? Width - usableWidth : Nut_Spacing;
    echo("Leftover", leftover);
    start = -((Width/2) + (leftover/2));
    echo("Start", start);
    end = (Width/2);
    echo("End", end);
    
    //
    //  The big square U shape that fits over the shelf.
    //
    module SolidPart() {
        // Front Part
        cube([Width,Front_Thickness,Shelf_Thickness], center=true);
        zq = (Shelf_Thickness/2)+(Thickness/2);
        yq_u = (Upper_Overhang/2) - (Front_Thickness/2);
        yq_l = (Lower_Overhang/2) - (Front_Thickness/2);
        
        // Top Part
        translate([0,yq_u,zq]) cube([Width,Upper_Overhang,Thickness], center=true);
        
        // Bottom Part
        translate([0,yq_l,-zq]) cube([Width,Lower_Overhang,Thickness], center=true);
    }
    
//    module CutoutSupports() {
//        adj = 0;
//        // TODO: Put a little top on these
//        // To make them easy to poke out.
//        SupportThickness = Square_Nut_Thickness + Thickness + adj;
//        nw = (Width/2)-(Nut_Spacing/2);
//        for (x = [start: Nut_Spacing: end]) {
//            rotate([90,0,0]) 
//                translate([x,0,Thickness/2]) 
//                    cylinder(
//                        d2=Clearance_Hole/2, 
//                        d1= Clearance_Hole,
//                        h = SupportThickness,center=true, $fn=45);
//        }
//    }
    
    module CutoutsForNuts() {
        nw = (Width/2)-(Nut_Spacing/2);
        // FIXME: Evenly space when width isn't properly divisible.
        // FIXME: Eliminate the double overhang thing
        
        h = Shelf_Thickness + (2*Thickness);
        nutHoleHeight = 
              (Square_Nut_Size/2)
            + (Shelf_Thickness/2)
            + Thickness
            + Square_Nut_Extra_Depth
            - 0.0;
        nutHoleTranslateZ = (nutHoleHeight/2)
            - (Square_Nut_Size/2)
            - Square_Nut_Extra_Depth
            + 0.01;
        for (x = [start: Nut_Spacing: end]) {
            translate([x,0,nutHoleTranslateZ])
                cube([Square_Nut_Size,Square_Nut_Thickness, nutHoleHeight], center=true);
        }
        //for (x = [start:Nut_Spacing:end]) {
        //    translate([x,Front_Thickness/2-(Thickness/2,0]) {
        //        %cube([Square_Nut_Size,2,Shelf_Thickness-0.01], center=true);
        //    }
        //}
    }
    
    module CutoutsForBolts() {
        nw = (Width/2)-(Nut_Spacing/2);
        for (x = [start: Nut_Spacing: end]) {
            rotate([90,0,0]) 
                translate([x,0,0]) 
                    cylinder(d=Clearance_Hole, h = 100,center=true, $fn=90);
        }
        for (x=[start:Nut_Spacing:end]) {
            translate([x,Front_Thickness/2-Thickness/2,0]) 
                cube([Square_Nut_Size,Thickness+0.1,Clearance_Hole],center=true);
        }
    }

//    module SquareCutoutsForBolts() {
//        nw = (Width/2)-(Nut_Spacing/2);
//        q = (Thickness/2) + (Square_Nut_Thickness/2) + 0.01;
//        for (x = [start: Nut_Spacing: end]) {
//            //rotate([90,0,0]) 
//                translate([x,q,0]) 
//                    // cylinder(d=Clearance_Hole, h = 100,center=true, $fn=45);
//            cube([Clearance_Hole, Thickness+0.03, Shelf_Thickness],center=true);
//        }
//    }
    
    module CutoutsForTop1() {
        // Might do this later.
        diam = 8;
        spacing = 10;
        yq_u = (Upper_Overhang/2) + (Front_Thickness/2);
        for (y=[-Upper_Overhang/2+spacing/2:spacing:Upper_Overhang/2-spacing/2-Front_Thickness]) {
            for (x=[-(Width/2)+spacing/2:spacing:Width/2-spacing/2]) {
                translate([x,y+yq_u,0])
                cylinder(d=diam,  h=100, center=true, $fn=6);
            }
        }
    }
    
    module HexCutouts(xsize, ysize, hexSize, hexSpacing, h) {
        hextot = hexSize + hexSpacing;
        xstart = -(xsize/2)+hextot/2;
        ystart = -(ysize/2)+hextot/2;
        xcount = floor((xsize-hextot/2)/hextot);
        ycount = floor((ysize-hextot/2)/hextot);
        
        //cylinder(d=1, h=200, center=true, $fn=90);
        for (x=[0:xcount-1]) {
            for (y=[0:ycount-1]) {
                translate(
                    [xstart + (x * hextot) + hextot/2 ,
                    ystart + (y * hextot) + (x%2==0?hextot/2:0),
                    0])
                    cylinder(d=hexSize, h=h, center=true, $fn=6);
            }
        }
    }
    
    module CutoutsForTop2() {
        xsize = Width;
        ysize = Upper_Overhang - Front_Thickness;
        hexSize = 8;
        hexSpacing = 2;
        
        // Automatically disable when testing w/small overhangs.
        if (Upper_Overhang > 2 * (hexSize + hexSpacing)) {
            translate([0,(Upper_Overhang/2) + (Front_Thickness/2),
                Shelf_Thickness/2 + Thickness/2])
                HexCutouts(xsize, ysize, hexSize, hexSpacing, h=Thickness+0.1);
        }
    }
    
    union() {
        difference() {
            SolidPart();
            CutoutsForNuts();
            CutoutsForBolts();
            //SquareCutoutsForBolts();
            CutoutsForTop2();
        }
        // CutoutSupports();
    }
    
}

// Rotate for cura. Un-rotate when working on the code!
rotate([90,0,0]) 
    Thingy();
