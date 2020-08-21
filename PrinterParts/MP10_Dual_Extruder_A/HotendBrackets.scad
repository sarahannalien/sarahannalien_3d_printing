Mounting_Plate_Width = 62.17;
Mounting_Plate_Height = 40;
Mounting_Plate_Hole_Diameter = 3.4;


Mounting_Plate_H1_Width = 29.5 + (Mounting_Plate_Hole_Diameter/2);
Mounting_Plate_H1_Height = 16 + (Mounting_Plate_Hole_Diameter/2);

Mounting_Plate_H2_Width = 49.5 + (Mounting_Plate_Hole_Diameter/2);
Mounting_Plate_H2_Height = 13.88 + (Mounting_Plate_Hole_Diameter/2);

Mounting_Plate_Thickness = 2.4;

Mounting_Shelf_Thickness = Mounting_Plate_Thickness;

Mounting_Shelf_Depth = 10;

Mounting_Plate_Guidepost_Diameter = Mounting_Shelf_Depth;
Mounting_Plate_Guidepost_Length = 10;

Hotend_Unit1_Position = 10;
Hotend_Unit2_Position = Mounting_Plate_Width-10;

Hotend_Unit_To_Guidepost_Distance = 10;

module MountingPlate() {
    holeCutoutThickness = Mounting_Plate_Thickness * 3;
    difference() {
        cube([Mounting_Plate_Width,Mounting_Plate_Height, Mounting_Plate_Thickness]);
        translate([Mounting_Plate_H1_Width, Mounting_Plate_H1_Height, 0])
            cylinder(d=Mounting_Plate_Hole_Diameter, h=holeCutoutThickness, center=true);
        translate([Mounting_Plate_H2_Width, Mounting_Plate_H2_Height, 0])
            cylinder(d=Mounting_Plate_Hole_Diameter, h=holeCutoutThickness, center=true);
    }
}

module MountingShelf() {
    holeCutoutThickness = Mounting_Shelf_Thickness * 3;
    holeZ = Mounting_Shelf_Thickness + (Mounting_Shelf_Depth/2);
    
    module hole(holeDepth, holeDiameter=Mounting_Plate_Hole_Diameter) {
        cylinder(d=holeDiameter, h=holeDepth, center=true);
    }
    module post() {
        cylinder(d=Mounting_Plate_Guidepost_Diameter, 
                            h=Mounting_Plate_Guidepost_Length, center=true);
        translate([0,0,-Mounting_Plate_Guidepost_Length/2])sphere(d=Mounting_Plate_Guidepost_Diameter);
    }
    module squarePost() {
        cube([Mounting_Plate_Guidepost_Diameter, 
            Mounting_Plate_Guidepost_Diameter,
            Mounting_Plate_Guidepost_Length], center=true);
    }
    module holeThingy(w, holeDepth=holeCutoutThickness, q=0, 
            holeDiameter=Mounting_Plate_Hole_Diameter) {
        translate([0,q, holeZ])
        rotate([90,0,0]) 
            translate([w, 0, 0]) hole(holeDepth, holeDiameter);
    }
    module postThingy(w) {
        translate([0,0, holeZ])
        rotate([90,0,0]) 
            translate([w, 0, -Mounting_Plate_Guidepost_Length/2]) post();
    }
    module squarePostThingy(w) {
        translate([0,0, holeZ])
        rotate([90,0,0]) 
            translate([w, 0, 
                -(Mounting_Plate_Guidepost_Length/2)-Mounting_Shelf_Thickness]) squarePost();
    }
    difference() {
        union() {
            //squarePostThingy(Hotend_Unit1_Position - Hotend_Unit_To_Guidepost_Distance);
            squarePostThingy(Hotend_Unit1_Position + Hotend_Unit_To_Guidepost_Distance);
            squarePostThingy(Hotend_Unit2_Position - Hotend_Unit_To_Guidepost_Distance);
            //squarePostThingy(Hotend_Unit2_Position + Hotend_Unit_To_Guidepost_Distance);
            translate([0,0,Mounting_Shelf_Thickness - 0.01])
                cube([Mounting_Plate_Width, Mounting_Shelf_Thickness,
                Mounting_Shelf_Depth]);
        }
        
        adjHole = Mounting_Plate_Hole_Diameter*1.2;
        
        holeThingy(Hotend_Unit1_Position, holeDiameter=adjHole);
        holeThingy(Hotend_Unit2_Position, holeDiameter=adjHole);
        
        // FIXME: This part needs cleanup!
        g1 = (Mounting_Plate_Guidepost_Length+Mounting_Shelf_Thickness)*10.1;
        qq = (g1/2)-Mounting_Shelf_Thickness;
        holeThingy(Hotend_Unit1_Position+ Hotend_Unit_To_Guidepost_Distance,
            holeDepth = g1,
            q = qq, holeDiameter=adjHole);
        holeThingy(Hotend_Unit2_Position- Hotend_Unit_To_Guidepost_Distance,
            holeDepth = g1,
            q = qq, holeDiameter=adjHole);
        // FIXME: Need to make space for a hex head here.
    }
}

module MountingShelfReinforcement() {
    translate([Mounting_Plate_Width/2, Mounting_Shelf_Thickness, Mounting_Plate_Thickness])
    rotate([0,90,0])
    cylinder(d=min(Mounting_Plate_Thickness, Mounting_Shelf_Thickness)*2,
            h = Mounting_Plate_Width, center=true);
}

union() {
    MountingPlate($fn=90);
    MountingShelf($fn=90);
    //MountingShelfReinforcement($fn=90);
}