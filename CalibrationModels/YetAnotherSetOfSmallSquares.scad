//
//   Thin calibration squares
//   Copyright (C) 2020 Sarah Kelley, sarah@sakelley.org
//

/* [Bed] */

// X size of your bed in mm
bedXSize = 310;

// Y size of your bed in mm
bedYSize = 310;

// Cosmetic: when showing bed, how thick to draw it?
bedThickness = 4;

// Cosmetic: helps visualize final result. TURN OFF BEFORE FINAL RENDER.
showBed = true;

/* [Squares] */

// Size of little squares, in mm
squareSize = 25; // [10:5:50]

// Thickness of little squares, in mm
squareThickness = 0.4;  // [0.2:0.1:2.0]

// How far apart to space the squares
squareSpacing = 1.6; // [1.0:0.1:2.0]

// Margin from edges of print surface
margin = 20; // [0:60]



module testSquares(showBed=true, bedXSize, bedYSize, bedThickness,
        squareSize, squareThickness, margin) {

    module squareThing(size=10, thickness=0.4) {
        difference() {
            sInner = size - (2 * thickness);
            tInner = thickness + 0.2;
            translate([0,0,thickness/2]) 
                cube([size, size, thickness],center=true);
            translate([0,0,(tInner/2)-(tInner-thickness)/2]) 
                cube([sInner, sInner, tInner], center=true);
        }
    }

    module bed(bedXSize, bedYSize, bedThickness) {
        color("black") 
            translate([0,0,-bedThickness-0.2])
                cube([bedXSize, bedYSize, bedThickness]);
        color("red")
                cube([2, 2, bedThickness*3]);
    }
    
    if (showBed) bed(bedXSize, bedYSize, bedThickness);
    
    for (y = [margin+(squareSize/2):squareSize*squareSpacing:bedYSize - margin-(squareSize/2)]) {
        for (x = [margin+(squareSize/2):squareSize*squareSpacing:bedXSize - margin-(squareSize/2)]) {
            translate([x,y,0]) 
                squareThing(size=squareSize, thickness=squareThickness);
        }
    }
}


testSquares(
    showBed=showBed,
    bedXSize=bedXSize, 
    bedYSize=bedYSize,
    bedThickness=bedThickness,
    squareSize=squareSize, 
    squareThickness=squareThickness,
    squareSpacing=squareSpacing,
    margin=margin);
