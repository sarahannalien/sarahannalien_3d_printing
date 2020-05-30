//
//  An extension arm for a generic metal extruder.
//  Makes it easier to get a little extra leverage.
//
//  I designed this because I injured my thumb pre-COVID-19, and
//  now my thumb doesn't quite work right and threading the filament
//  is a little harder than it should be.
//
//  This has been printed successfully, but not tested in use yet.
//
//  Copyright (c) 2020 Sarah Kelley, sarah@sakelley.org
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//  
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//


// height of arm.
// needs a little extra tolerance to keep the part from splitting
metalArmHeight=8.17 + 0.6;
metalArmWidth=10.42;

// length not including curvey bit at the end
metalArmLength=10;  // FIXME actual size here.

// Curvey bit if extended into a circle would have this diameter
curveyBitCircleRadius = 5.42;  // estimated, then tweaked

// We shave off this much from an edge to make our curvey bit
curveyBitCirclePortion = 4;

// Part of extension that fits over arm will be this thick
extensionThickness = 2;

extensionLength = 65;

$fn = 72;
//#cylinder(r=4, h=8.14, center=true);
//translate([5,0,0]) cube([10, 2*4, 8.14], center=true);

module roundedBitOld(curveDiameter=8, circlePortion=4, h=8.14) {
    translate([0,-(curveDiameter-circlePortion),0]) intersection() {
        cylinder(r=curveRadius, h=h, center=true);
        translate([0,curveRadius+(curveRadius-circlePortion),0]) 
            cube(size=2*curveRadius, center=true);
    }
}



module roundedBit(r, p, h) {
    translate([0,-r+p,0])
    intersection() {
        cylinder(r=r, h=h, center=true);
        translate([0,(2*r)-p,0])cube([2*r, 2*r, h], center=true);
    }
}

module partOfMetalArmWeWillFitOver() {
    translate([0,metalArmLength-0.001,0])
    union() {  
        roundedBit(r=curveyBitCircleRadius, p=curveyBitCirclePortion, h=metalArmHeight);
        translate([0,-(metalArmLength/2),0])
            cube([metalArmWidth, metalArmLength, metalArmHeight], center=true);
    }
}

module armFlap(height, size, stretch) {
    //scale([1,stretch,1])
    //linear_extrude(height=height, center=true)
    //polygon(points=[[0,0],[-size,size],[size,size],[0,0]]);
    scale([1,stretch,1])cylinder(h=height, d=size, center=true);
}

module armText(textHeight, textSize) {
    translate([0,0,(metalArmHeight/2)+extensionThickness])
    rotate([0,0,90])
    linear_extrude(textHeight)
    text("Filament release", valign="center", font="Arial",
        size=textSize);
}

module armExtension() {  // starts at y=0
    union() {
        translate([0,extensionLength/2,0])
            cube([  metalArmWidth + (2*extensionThickness),
                    extensionLength,
                    metalArmHeight + (2*extensionThickness)], center=true);
        translate([0, extensionLength*1.1])
            armFlap(height=metalArmHeight + (2*extensionThickness), 
                size=30, stretch=2);
        translate([0,25,0])
            armText(textHeight=0.5, textSize=7);
    }
}


module armExtensionPart() {

    difference() {
        armExtension();
        partOfMetalArmWeWillFitOver();
    }
}

armExtensionPart();
//armText();
