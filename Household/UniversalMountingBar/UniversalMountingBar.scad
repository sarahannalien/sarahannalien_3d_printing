/*

Univeral Mounting Bar For Desk Shelf
Copyright (C) 2020 Sarah Kelley

Permission to use, copy, modify, and/or distribute this 
software for any purpose with or without fee 
is hereby granted.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL
WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE
AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL
DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR
PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER
TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
PERFORMANCE OF




This is a bracket that slips over the front of a shelf.
It has square nuts embedded in it, allowing other items
to be secured to the front of the shelf.

The bracket itself currently has no special provisions for
mechanical attachment; I'm hoping friction will do the
job, plus, in my case, the weight of my monitor(s).
You can use the holes in the front to attach it
if it seems necessary.
It's also probably feasible to drill mounting holes,
or use some of the hex openings.

This is intended for attaching lightweight items to my
dual monitor stand, which is about 4 inches/10cm from
my desktop. Things I'm hoping to attach to it include
a phone holder, pencil/pen holder, microphone attachment,
webcam attachment, etc.

There's code to use M3/M4 bolts/screws, but I've only tested
the M5 variant so far, so the sizing for the smaller
nut sizes may be off a bit.

All sizes are in mm.

FAQ:

Q: Can I use hex nuts?
A: You can try, but this is designed for square nuts only.

Q: I attached an anvil to my bar and it keeps falling off...?
A: This is only intended for lightweight items.

Q: Best filament type?
A: I used PETG, but other types should be ok too.

Q: Slicer settings?
A: Bridging support needed, but they're easy bridges.
   Other than that not much should be critical.
   
Q: I printed a great big long bar but nothing fits?!
A: Print a little one first to check sizes for your
   shelf, square nuts, etc. Set Width to Nut_Spacing value.
   Set Upper_Overhang and Lower_Overhang to about 15mm.
   
Q: Best Nut_Spacing to use?
A: During development I went with 20mm because it seemed about right
   for my uses. Some Americans may prefer 25.4mm. Sigh.
   15.875 matches many 19-inch racks (I think), but then
   you might also want to add nut sizes for #12-24 or #10-32.
   Multiples of 5.08 with M3 screws *might* roughly match Eurorack.
   But this particular bracket is for mounting random desk
   widgets, NOT equipment.
   Most of the projects I hope to attach to this will probably
   only use one screw, so it's not critical for me.

Q: My nuts keep falling out?
A: Mount with the nut insertion holes facing up!
   Slightly reduce the nut thickness for your particular nuts.
   Keep in mind there still needs to be a bit of tolerance,
   and if they're really tight the plastic may split.
   Can also secure the nuts with a *tiny* bit of glue.
   
Q: Do I need to stop the print job to add the nuts?
A: No, the nuts go in after printing.

*/


// How thick is the shelf?
Shelf_Thickness = 16.7;

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
Nut_Spacing = 15.875;

// Nut Type
Nut_Type = "M5";  // [M3, M4, M5]

M5_Square_Nut_Size = 8.5;  // measured 8.0
M5_Square_Nut_Thickness = 4.5; // measured 3.8
M5_Clearance_Hole = 5.5;
M5_Square_Nut_Extra_Depth = 0.5;

M4_Square_Nut_Size = 7;
M4_Square_Nut_Thickness = 3.1;
M4_Clearance_Hole = 4.5;
M4_Square_Nut_Extra_Depth = 0.5;  // FIXME needs calibration

M3_Square_Nut_Size = 5.5;
M3_Square_Nut_Thickness = 2.5;
M3_Clearance_Hole = 3.4;
M3_Square_Nut_Extra_Depth = 0.5;  // FIXME needs calibration



module UniversalMountingBar() {
    
    function choose(t, m3, m4, m5) = (
        t=="M3"?m3:(t=="M4"?m4:(t=="M5"?m5:0)));
    
    Square_Nut_Size = choose(Nut_Type,
        M3_Square_Nut_Size,M4_Square_Nut_Size,M5_Square_Nut_Size);
    
    Square_Nut_Thickness = choose(Nut_Type,
        M3_Square_Nut_Thickness, M4_Square_Nut_Thickness, M5_Square_Nut_Thickness);
    
    Clearance_Hole = choose(Nut_Type,
        M3_Clearance_Hole, M4_Clearance_Hole, M5_Clearance_Hole);
    
    Square_Nut_Extra_Depth = choose(Nut_Type,
        M3_Square_Nut_Extra_Depth, M4_Square_Nut_Extra_Depth, M5_Square_Nut_Extra_Depth);
        
    echo("Square_Nut_Size", Square_Nut_Size);
    echo("Square_Nut_Thickness", Square_Nut_Thickness);
    echo("Clearance_Hole", Clearance_Hole);
    echo("Square_Nut_Extra_Depth", Square_Nut_Extra_Depth);
    
    Front_Thickness = (2*Thickness) + Square_Nut_Thickness;

    
    // Compute start and end nut positions.
    // Evenly distribute extra space at each end.
    numberOfHoles = floor(Width/Nut_Spacing);
    echo("numberOfHoles", numberOfHoles);
    usableWidth = (numberOfHoles - 1) * Nut_Spacing;
    echo("usableWidth", usableWidth);
    leftover = (Width - usableWidth) > 0 ? Width - usableWidth : Nut_Spacing;
    echo("Leftover", leftover);
    start = -((Width/2) - (leftover/2));
    echo("Start", start);
    end = (Width/2) - (leftover/2);
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
    
    
    //
    //  Channels where the square nuts slide in
    //
    module CutoutsForNuts() {
        
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
    }



    // Holes for the bolts: round in front, square in back
    // (This simplifies the support situation for printing)
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


    
    //
    //  Generic hex cutout thing
    //
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
    
    
    //
    //  Hex cutouts for the top, to save weight/material
    //
    module CutoutsForTop() {
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
    
    
    //
    //  Main for UniversalMountingBarModule
    //
    difference() {
        SolidPart();
        CutoutsForNuts();
        CutoutsForBolts();
        CutoutsForTop();
    }
}


// Rotate for cura. Un-rotate when working on the code!
rotate([90,0,0]) 
    UniversalMountingBar();
