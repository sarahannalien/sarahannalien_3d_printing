/*
 *  Angled Mounting Plate for Arduino Mega 2560
 *  for Jameco Valuepro 3220-Point Solderless Breadboard 7.3"L x 7.5"W
 *  Jameco Part no. 20812
 *  https://www.jameco.com/shop/ProductDisplay?productId=20812
 *
 *  
 *  Using a big breadboard with an Arduino Mega 2650 can be inconvenient because
 *  there's no way to plug the board into the breadboard, and if there was, it
 *  would take up a lot of valuable real estate. Larger or longer-term projects
 *  are tricky to keep attached without unplugging things by accident.
 *  (And even worse if you have a cat!)
 *
 *  This bracket repurposes the holes for the binding posts on the aluminum
 *  baseplate and uses them to mount an angled baseplate for mounting the
 *  Mega 2560. This makes the board easy to get to and easy to permanently
 *  attach to the breadboard. 
 *
 *  The holes are in the pattern for the Mega 2560, but this will also fit a
 *  variety of Arduino boards, clones, compatibles, etc.
 *
 *  There was space left over so some "utility holes" were added on the
 *  left side of the mounting plate. They can be used for
 *  potentiometers, switches, connectors, etc.
 *  
 *
 *  MIT License
 *  
 *  Copyright (c) 2020 Sarah Kelley, sarah@sakelley.org
 *  
 *  Permission is hereby granted, free of charge, to any person obtaining a copy
 *  of this software and associated documentation files (the "Software"), to deal
 *  in the Software without restriction, including without limitation the rights
 *  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 *  copies of the Software, and to permit persons to whom the Software is
 *  furnished to do so, subject to the following conditions:
 *  
 *  The above copyright notice and this permission notice shall be included in all
 *  copies or substantial portions of the Software.
 *  
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 *  SOFTWARE.
 *  
 */
 

//  Basic size of the breadboard baseplate
Breadboard_Width = 209.5;
Breadboard_Length = 239.5;

//  Free area at the "top" of the baseplate.
//  This is where our bracket will go.
Breadboard_Top_Length = 43.5;

//  Positions of the binding posts.
//  We'll actually use two of these holes for bolts to
//  attach our bracket to the aluminum baseplate.
//  X offsets are measured from the RIGHT.
//  (My calipers aren't big enough to measure from the left!)
Breadbord_Binding_Post_Hole_Diameter = 9.45;
Breadboard_GND_Hole_X_Offset = 23.5;
Breadboard_Vc_Hole_X_Offset = 49.0;
Breadboard_Vb_Hole_X_Offset = 74;
Breadboard_Va_Hole_X_Offset = 99;
Breadboard_Hole_Y_Offset = 15.5;

// How tall the solderless breadboards are above the
// aluminum baseplate.
Breadboard_Block_Height = 10;

// General thickness of the part (plates, braces, etc)
Thickness = 3;

// Adjusts where the riser starts
// (We leave a little space for the Arduino board, which has
// nonzero thickness!)
Riser_Y_Position = 30;

// If you're looking directly at the mounting plate, this
// controls it's Y size. (X size is always full width of the breadboard).
Mounting_Plate_Size = 70;

// Angle of mounting plate from vertical, in degrees.
// (If you change this, Braces_Angle_Value will require adjustment.)
Mounting_Plate_Angle = -30;

// Position the arduino mounting holes on the mounting plate.
// (Just done by eye, no measurement!)
Mounting_Plate_Arduino_X = 90;
Mounting_Plate_Arduino_Y = 5;

// Adjusts the angle of the braces to match the mounting plate.
// (Done by eye, quicker than doing the math.)
Braces_Angle_Value = 61;

// Adjusts position of center brace.
// 0.5 = dead center.
// (Sometimes need to scoot a little to avoid holes/etc.
Braces_Center_Ratio = 0.44;

//
//  Utility holes for non-arduino part of the
//  mounting plate. Use for whatever.
//
Utility_Hole_Diameter = 8;

Utility_Hole_X_Count = 4;
Utility_Hole_Y_Count = 3;
Utility_Hole_X_Spacing = 23;
Utility_Hole_Y_Spacing = 20;
Utility_Hole_X_Offset = 15;
Utility_Hole_Y_Offset = 15;

// Square holes are easier to print on a filament 3D printer.
Utility_Holes_Are_Square = true;



////////////////////////////////////////////////////////////////
//
//  Holes in mega 2560, A-F counterclockwise from lower left
//  (Note: some holes are same as Uno Etc, so should be able to
//  mount most of the similar form factor boards using these holes.)
//

Arduino_Hole_Diameter = 3.5;  // slightly bigger than on board.

Arduino_Hole_A_X = 13.97;
Arduino_Hole_A_Y = 2.54;

Arduino_Hole_B_X = 66.04;
Arduino_Hole_B_Y = 7.62;

Arduino_Hole_C_X = 96.52;
Arduino_Hole_C_Y = 2.54;

Arduino_Hole_D_X = 90.17;
Arduino_Hole_D_Y = 50.8;

Arduino_Hole_E_X = 66.04;
Arduino_Hole_E_Y = 35.56;

Arduino_Hole_F_X = 15.24;
Arduino_Hole_F_Y = 50.8;

// Square holes are easier to print on a filament 3D printer
Arduino_Holes_Are_Square = true;

module ArduinoHoles(h) {
    module hole(x, y) {
        translate([x, y, 0]) 
            if (Arduino_Holes_Are_Square) {
                cube([Arduino_Hole_Diameter, Arduino_Hole_Diameter, h], center=true);
            } else {
                cylinder(d = Arduino_Hole_Diameter, h=h, center=true);
            }
    }
    hole(Arduino_Hole_A_X, Arduino_Hole_A_Y);
    hole(Arduino_Hole_B_X, Arduino_Hole_B_Y);
    hole(Arduino_Hole_C_X, Arduino_Hole_C_Y);
    hole(Arduino_Hole_D_X, Arduino_Hole_D_Y);
    hole(Arduino_Hole_E_X, Arduino_Hole_E_Y);
    hole(Arduino_Hole_F_X, Arduino_Hole_F_Y);
}

// Tool to make sure the holes actually line up!
module ArduinoHolesTest() {
    difference() {
        union() {
            cube([103,57,2]);
            cube([2,2,3]); // so we can find the origin!
            
            
        }
        ArduinoHoles(h=10, $fn=90);
    }
}

//
//  End of Arduino Holes Stuff...
//
////////////////////////////////////////////////////////////////




module BreadboardHeadBracket() {
    
    // flat part that sits against the aluminum plate
    module baseplate() {
        w = Breadboard_Width;
        x1 = w - Breadboard_GND_Hole_X_Offset;
        x2 = w - Breadboard_Vc_Hole_X_Offset;
        x3 = w - Breadboard_Vb_Hole_X_Offset;
        x4 = w - Breadboard_Va_Hole_X_Offset;
        y = Breadboard_Top_Length - Breadboard_Hole_Y_Offset;
        d = Breadbord_Binding_Post_Hole_Diameter;
        t2 = Thickness / 2;
        difference() {
            cube([Breadboard_Width,Breadboard_Top_Length, Thickness]);
            // these aren't actually round holes but that's not critical here!
            translate([x1, y, -t2]) cylinder(d = d, h = 2 * Thickness);
            translate([x2, y, -t2]) cylinder(d = d, h = 2 * Thickness);
            translate([x3, y, -t2]) cylinder(d = d, h = 2 * Thickness);
            translate([x4, y, -t2]) cylinder(d = d, h = 2 * Thickness);
        }
    }
    
    // small straight vertical part before the mounting plate
    module riser() {
        translate([0, Breadboard_Top_Length - Riser_Y_Position, 0])
        cube([Breadboard_Width, Thickness, Breadboard_Block_Height]);
    }
    
    // the big angled mounting plate
    module mountingPlate() {
        translate([0, Breadboard_Top_Length - Riser_Y_Position, 
            Breadboard_Block_Height])
        rotate([Mounting_Plate_Angle,0,0])
        difference() {
            cube([Breadboard_Width, Thickness, Mounting_Plate_Size]);
            rotate([90,0,0]) mountingPlateHoles();
        }
    }
    
    // holes to be cut into the mounting plate.
    module mountingPlateHoles() {
        module utilityHoles(h) {
            for (y=[0:Utility_Hole_Y_Count-1]) {
                for (x=[0:Utility_Hole_X_Count-1]) {
                    translate([x*Utility_Hole_X_Spacing,y*Utility_Hole_Y_Spacing,0])
                        if (Utility_Holes_Are_Square) {
                            cube([Utility_Hole_Diameter, Utility_Hole_Diameter, h], center=true);
                         } else {
                            cylinder(d=Utility_Hole_Diameter, h=h, center=true);
                        }
                }
            }
        }
        translate([Mounting_Plate_Arduino_X, Mounting_Plate_Arduino_Y, 0])
            ArduinoHoles(h=3*Thickness);
        translate([Utility_Hole_X_Offset, Utility_Hole_Y_Offset])
            utilityHoles(h=3*Thickness);
    }
    
    // vertical braces to make the angled mounting plate stronger
    // (n sets the high point of the brace; was quicker to adjust
    // manually than do the math to get the angle right.)
    module braces(n) {
        x = Riser_Y_Position;
        p = [
            [0.01,0],
            [x,0],
            [x, n],
            [0.01, Breadboard_Block_Height]
        ];
        module brace() {
            rotate([0,0,90]) 
                rotate([90,0,0])
                    linear_extrude(height=Thickness)
                        polygon(p);
        }
        y = Breadboard_Top_Length - Riser_Y_Position;
        x1 = 0;
        x2 = Breadboard_Width * Braces_Center_Ratio; 
        x3 = Breadboard_Width - Thickness; 
        
        translate([x1, y, 0]) brace();
        translate([x2, y, 0]) brace();
        translate([x3, y, 0]) brace();
    }
    
    //
    //  main
    //
    baseplate();
    riser();
    mountingPlate();
    color("red")  braces(Braces_Angle_Value);
}

// Use to test the arduino holes line up in a flat plate
//ArduinoHolesTest();

// The bracket.
// Use $fn to specify number of facets for holes.
BreadboardHeadBracket($fn=90);


