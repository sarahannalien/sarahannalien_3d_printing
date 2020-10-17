
// How thick is the shelf?
Shelf_Thickness = 16.5;

// Overhang above shelf?
Upper_Overhang = 10; // 50;

// Overhang below shelf
Lower_Overhang = 10; // 30;

// Slight tilt so we fit on firmly
Overhang_Angle = 15;

// Total width we will generate
Width = 60;

// General thickness of OUR part
Thickness = 2;

// How far apart to space the nuts
Nut_Spacing = 20;

M5_Square_Nut_Size = 8;
M5_Square_Nut_Thickness = 3.9; // measured 3.8
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
    
    module CutoutSupports() {
        adj = 0;
        // TODO: Put a little top on these
        // To make them easy to poke out.
        SupportThickness = Square_Nut_Thickness + Thickness + adj;
        nw = (Width/2)-(Nut_Spacing/2);
        for (x = [-nw: Nut_Spacing: nw]) {
            rotate([90,0,0]) 
                translate([x,0,Thickness/2]) 
                    cylinder(
                        d2=Clearance_Hole/2, 
                        d1= Clearance_Hole,
                        h = SupportThickness,center=true, $fn=45);
        }
    }
    
    module CutoutsForNuts() {
        nw = (Width/2)-(Nut_Spacing/2);
        h = Shelf_Thickness + (2*Thickness);
        nutHoleHeight = 
              (Square_Nut_Size/2)
            + (Shelf_Thickness/2)
            + Thickness
            + Square_Nut_Extra_Depth;
        nutHoleTranslateZ = (nutHoleHeight/2)
            - (Square_Nut_Size/2)
            - Square_Nut_Extra_Depth
            + 0.01;
        for (x = [-nw: Nut_Spacing: nw]) {
            translate([x,0,nutHoleTranslateZ])
                cube([Square_Nut_Size,Square_Nut_Thickness, nutHoleHeight], center=true);
        }
    }
    
    module CutoutsForBolts() {
        nw = (Width/2)-(Nut_Spacing/2);
        for (x = [-nw: Nut_Spacing: nw]) {
            rotate([90,0,0]) 
                translate([x,0,0]) 
                    cylinder(d=Clearance_Hole, h = 100,center=true, $fn=90);
        }
    }

    module SquareCutoutsForBolts() {
        nw = (Width/2)-(Nut_Spacing/2);
        q = (Thickness/2) + (Square_Nut_Thickness/2) + 0.01;
        for (x = [-nw: Nut_Spacing: nw]) {
            //rotate([90,0,0]) 
                translate([x,q,0]) 
                    // cylinder(d=Clearance_Hole, h = 100,center=true, $fn=45);
            cube([Clearance_Hole, Thickness+0.03, Shelf_Thickness],center=true);
        }
    }
    
    module CutoutsForTop() {
        // Might do this later.
    }
    
    union() {
        difference() {
            SolidPart();
            CutoutsForNuts();
            CutoutsForBolts();
            SquareCutoutsForBolts();
            //CutoutsForTop();
        }
        // CutoutSupports();
    }
    
}

rotate([90,0,0]) 
    Thingy();
