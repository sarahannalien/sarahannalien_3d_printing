// set to line width you will print with
Line_Width = 0.53;

// General thickness of bracket
Thickness = 3.2;

Upper_Hole_Spacing = 56.26;

Upper_Hole_Diameter = 3.4;

Upper_Width = 70;

Upper_Length = 20;

// Compensate for asymmetry in top holes
Upper_Hole_WOffset = 0;

Upper_Hole_LOffset = 3;


Pi_Hole_VSpacing = 58;

Pi_Hole_HSpacing = 49;

Pi_Hole_VOffset = 10;

Pi_Hole_HOffset = 0;

Pi_Hole_Diameter = 2.9;

Pi_Width = 58;

Pi_Length = 90;

Pi_Vent_Width = 40;

Pi_Vent_Length = 70;

Pi_Hole_InsetDepth = 1.5;
Pi_Hole_InsetHeadDiameter = 5;

Pi_Spacer_Height = 3;

Pi_Spacer_Size = 8;

// Diameter for (optional) round adhesive foot
Adhesive_Feet_Diameter = 6.5; // 6mm + tolerance

// Depth of hole for adhesive foot
Adhesive_Feet_Height = 1;   

// Octoprint sticker width, mm, https://www.printedsolid.com/products/octoprint-sticker
Octoprint_Sticker_Width = 1.95 * 25.4;

// Octoprint sticker height, mm, https://www.printedsolid.com/products/octoprint-sticker
Octoprint_Sticker_Height = 1.6  * 25.4;

Sign_Width = max(Upper_Width, Octoprint_Sticker_Width);

Sign_Height = Octoprint_Sticker_Height * 1.1;

module MiniV2PiMountingBracket() {

    module upperPart() {
        module upperHole() {
            cylinder(d=Upper_Hole_Diameter, h=Thickness*1.1, center=true);
       }
        
        difference() {
            union() {
                cube([Upper_Width, Upper_Length, Thickness], center=true);
            }
            translate([-Upper_Hole_WOffset, Upper_Hole_LOffset, 0]) {
                uhs2 = Upper_Hole_Spacing / 2;
                translate([-uhs2, 0, 0]) upperHole();
                translate([ uhs2, 0, 0]) upperHole();
            }
        }
    }
    
    module lowerPart() {
        module piHole() {
            tx = Thickness * 1.1;
            id = Pi_Hole_InsetDepth;
            cylinder(d=Pi_Hole_Diameter, h=tx, center=true);
            translate([0,0,tx/2-id/2]) cylinder(d2 = Pi_Hole_InsetHeadDiameter,
                d1 = Pi_Hole_Diameter,
                h = id, center=true);
        }
        module piSpacer() {
            p = Pi_Spacer_Size;
            q = Pi_Spacer_Size - (4 * Line_Width);
            difference() {
                cube([p, p, Pi_Spacer_Height], center=true);
                translate([0,0,Pi_Spacer_Height/2-(Adhesive_Feet_Height/2)+0.1]) 
                    //cube([q, q, Pi_Spacer_Height/2], center=true);
                    cylinder(d=Adhesive_Feet_Diameter, h=Adhesive_Feet_Height, center=true);
            }
        }
        v2 = Pi_Hole_VSpacing/2;
        h2 = Pi_Hole_HSpacing/2;
        zz = Thickness*0.95;
        difference() {
            union() {
                cube([Pi_Width,Pi_Length,Thickness], center=true);
                translate([-h2, -v2, zz]) piSpacer();
                translate([-h2,  v2, zz]) piSpacer();
                translate([ h2, -v2, zz]) piSpacer();
                translate([ h2,  v2, zz]) piSpacer();
                translate([ 0,  (Pi_Length/2)-Pi_Spacer_Size/2, zz]) piSpacer();
            }
            translate([Pi_Hole_HOffset, Pi_Hole_VOffset, 0]) {
                translate([-h2,-v2,0]) piHole();
                translate([-h2, v2,0]) piHole();
                translate([ h2,-v2,0]) piHole();
                translate([ h2, v2,0]) piHole();
            }
            cube([Pi_Vent_Width, Pi_Vent_Length, Thickness*1.1], center=true);
        }   
    }
    
    module reinforcementPart() {
        cylinder(d=Pi_Spacer_Height * 2, h=Pi_Width, center=true);
    }
    
    module signPart() {
        translate([0,-Pi_Length/2-(Sign_Height/2.1)-(Thickness/2),0])
        cube([Sign_Width, Sign_Height, Thickness], center=true);
    }
    
    union() {
        translate([0,-Pi_Length/2,Upper_Length/2-(Thickness/2)])
            rotate([90,0,0]) 
                upperPart();
        lowerPart();
        translate([0,-Pi_Length/2+(Thickness/2),Thickness/2])
            rotate([90,0,90]) 
                reinforcementPart();
        
        // Still kind of experimental.
        //signPart();
    }
}

MiniV2PiMountingBracket($fn=45);
