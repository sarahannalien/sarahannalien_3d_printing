//
//  A simple guide block to help with tapping the center
//  hole on a 20mm aluminum extrusion beam.
//
//  Supports asymmetric guide pins because I thought I was
//  going to need that. In the end, it turned out that my 3D printer
//  support rod kit had already been redesigned in such a way
//  that tapping was not required, so I ended up not actually
//  needing this little widget. Oh well.
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



module guideBlock2020(
    h = 5,
    guideHoleDiameter=5.6,
    guideCubeSize=6,
    longGuideLength=12,
    shortGuideLength=3,
    oneShortPin=false,
    extrusionSize=20
) {
    // a cube with one end tapered off a little bit
    module tapered_cube(size, length, taperLength=6, taperConeScale=2) {
        intersection() {
            cube([size, size, length], center=true);
            union() {
                translate([0,0,length/2]) 
                    cylinder(h=taperLength, d1=taperConeScale*size, d2=0, center=true, $fn=36);
                translate([0,0,-taperLength/2]) 
                    cylinder(h=length, d=2*size, center=true, $fn=36);
            
            }
        }
    }
    difference() {
        union() {
            // Main block
            rotate([180,0,0])
                // tiny taper on the outside face
                // (mostly just makes easier to unstick from the pront bed)
                tapered_cube(extrusionSize, h, taperLength=8, taperConeScale=2.3);
            
            // short pins for the extrusion channels
            shortPins = oneShortPin ? [1] : [-1,1];
            for (i = shortPins) {
                td = i*((extrusionSize/2)-(guideCubeSize/2));
                th = (h/2) + (shortGuideLength/2);
                translate([ 0, td, th]) 
                    tapered_cube(guideCubeSize,shortGuideLength);
            }
            
            // long pins for the extrusion channels
            for (i = [-1, 1]) {
                tw = i*((extrusionSize/2)-(guideCubeSize/2));
                th = (h/2) + (longGuideLength/2);
                translate([ tw, 0, th]) 
                    tapered_cube(guideCubeSize,longGuideLength);
            }
        }
        
        // hole for the tap
        cylinder(h=h+0.01, d=guideHoleDiameter,center=true, $fn=36);
    }
}

guideBlock2020(h=25, oneShortPin=true);
