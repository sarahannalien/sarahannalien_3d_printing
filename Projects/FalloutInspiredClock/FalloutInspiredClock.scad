
Bracket_W = 220;
Bracket_H = 90;
Screen_W = 96.16;
Screen_H = 63.75;

Speaker_Tot_W = 44.5; // speaker plus mtg brackets
Speaker_W = 28.3 + 2;
Speaker_H = 31   + 2;
Speaker_Mtghole_Diam = 2.5 + 0.5;
Speaker_Mtghole_Hoffs = (Speaker_W/2) + 4.35;
Speaker_Mtghole_Voffs = 0;  // they're centered

Speaker_Pos_Hadj = 5;

M4_Hole_Diameter = 4.5;

Bracket_Mounting_Hole_Woffset = 10;
Bracket_Mounting_Hole_Hoffset = 10;

// Border inset behind screen
Screen_B = 0.4 * 8;

Screen_HPos = -(Bracket_H/2)+((Screen_H-Screen_B)/2) + 5;
Screen_WPos = 0;
Speaker_HPos = -12;
Speaker_WPos = 5;


Rpi_Woffs = 18;
Rpi_Hoffs = 0;

echo("Bracket_H", Bracket_H);

module SpeakerMountingHoles(height) {
    union() {
        cube([Speaker_W, Speaker_H, height], center=true);
        translate([Speaker_Mtghole_Hoffs,Speaker_Mtghole_Voffs,0]) {
            cylinder(d=Speaker_Mtghole_Diam, h=height, center=true);
        }
        translate([-Speaker_Mtghole_Hoffs,Speaker_Mtghole_Voffs,0]) {
            cylinder(d=Speaker_Mtghole_Diam, h=height, center=true);
        }
    }
}
module BracketMountingHoles(height) {
    w2 = (Bracket_W/2) - Bracket_Mounting_Hole_Woffset;
    h2 = (Bracket_H/2) - Bracket_Mounting_Hole_Hoffset;
    union() {
        translate([-w2,-h2]) cylinder(d=M4_Hole_Diameter, h=height, center=true); 
        translate([-w2, h2]) cylinder(d=M4_Hole_Diameter, h=height, center=true); 
        translate([ w2,-h2]) cylinder(d=M4_Hole_Diameter, h=height, center=true); 
        translate([ w2, h2]) cylinder(d=M4_Hole_Diameter, h=height, center=true); 
    }
    
}

module BracketCenterMarks(height) {
    d = 1.6;
    w2 = (Bracket_W/2);
    h2 = (Bracket_H/2);
    translate([0,h2,0]) cylinder(d=d, h=height, center=true);
    translate([0,-h2,0]) cylinder(d=d, h=height, center=true);
    translate([w2,0,0]) cylinder(d=d, h=height, center=true);
    translate([-w2,0,0]) cylinder(d=d, h=height, center=true);
}

module FrontBracketSpeedHoles() {
    /*
    w2 = (Bracket_W/2);
    h2 = (Bracket_H/2);
    a = 20;
    b = 16;
    for (h = [-h2:a:h2]) {
        for (w = [-w2:a:w2]) {
            translate([w,h,0]) cube([b,b,4],center=true);
        }
    }
    */
    module hole(w, h, size=20) { 
        translate([w,h,0]) cube(size=size, center=true); 
    }
    hole(-90, 17);
    hole(-65, 17);
    hole( 90, 17);
    hole( 65, 17);
    
    hole(0,   32, size=16);
    hole(-20, 32, size=16);
    hole(-40, 32, size=16);
    hole( 20, 32, size=16);
    hole( 40, 32, size=16);
    
    hole(-90, 36, size=10);
    hole(-75, 36, size=10);
    hole(-60, 36, size=10);

    hole( 90, 36, size=10);
    hole( 75, 36, size=10);
    hole( 60, 36, size=10);

    hole(-90, -36, size=10);
    hole(-75, -36, size=10);
    hole(-60, -36, size=10);
 
    hole( 90, -36, size=10);
    hole( 75, -36, size=10);
    hole( 60, -36, size=10);
    
    hole(55,-3, size=10);
    hole(55,-22, size=10);

    hole(-55,-3, size=10);
    hole(-55,-22, size=10);
 
}

module bracketPlate(bracketThickness = 3) {
    cube([Bracket_W,
            Bracket_H,
            bracketThickness],center=true);
}

module FrontBracket(bracketThickness = 3) {
    
    difference() {
        bracketPlate();
        
        // hole for screen
        translate([Screen_WPos,Screen_HPos,0]) {
            cube([Screen_W - Screen_B,
                Screen_H - Screen_B,
                bracketThickness * 1.01], center=true);
        }
        // Holes for speakers
        Speaker_NominalWPos = (Bracket_W/2) - (Speaker_Tot_W/2); 
        translate([Speaker_NominalWPos - Speaker_WPos,Speaker_HPos,0]) 
            SpeakerMountingHoles(height=bracketThickness * 1.01);
        translate([-Speaker_NominalWPos + Speaker_WPos,Speaker_HPos,0]) 
            SpeakerMountingHoles(height=bracketThickness * 1.01);
        
        // holes for attaching other brackets
        BracketMountingHoles(height=3.02);
        
        // teeny tiny cutouts to mark center line. debug thingy.
        BracketCenterMarks(height = 3.02);
        
        FrontBracketSpeedHoles();
    }
}

module PiBracket(bracketThickness = 3) {
    difference() {
        bracketPlate();
        
        // hole for screen
        //translate([Screen_WPos,Screen_HPos,0]) {
        //    cube([Screen_W - Screen_B,
        //        Screen_H - Screen_B,
        //        bracketThickness * 1.01], center=true);
        //}
        
        // holes for attaching other brackets
        BracketMountingHoles(height=3.02);
        
        // teeny tiny cutouts to mark center line. debug thingy.
        BracketCenterMarks(height = 3.02);
    }
}


translate([0,0,-10]) FrontBracket($fn=60);
PiBracket();