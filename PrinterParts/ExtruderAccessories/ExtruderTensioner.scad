//
//  Spring tensioner "thingy" for metal extruder for 3D Printer
//  Sarah Kelley, 5/13/2020
//
//  Provides the ability to use a screw to increase the
//  tension on the extruder by compressing the spring
//  a little bit more.
//
//  Some extruder brackets already come with a metal "thingy"
//  to serve this purpose, but mine did not... so why not print one?
//
//  Will it be strong enough? Time will tell. (probably "no").
//  Recommend printing in thin layers with 100% infill.
//  A slow-ish print speed is also probably a good idea.
//
//  Addendum: on the Creality metal extruder, the "thingy" is
//  something called a "rivet nut", and you can buy them!
//  They're made out of metal and SIGNIFICANTLY less likely to
//  break than this little thing. 
//
//  Oh, and just FYI, the Creality metal extruder has an M3 rivet nut
//  sitting on top of an M4 tension screw, which keeps it on top because it
//  won't gradually screw itself in. The generic metal extruders I have
//  use M3 screws, and I've yet to locate a corresponding M2 rivet nut
//  (though I found other sizes on Amazon).
//  Sooo.... more research is needed? 

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

// Slightly larger than the 8.24mm outer diameter of the spring
baseWidth = 10.0;

// Printing in layers this thick
layerSize = 0.04375;

// Number of layers for the base
numLayers = 20;

// Thicker: better support for spring. Thinner: adds less tension by default.
baseHeight = layerSize * numLayers;

// By eyeball, needs to fit in extruder mechanism and not "use up" the spring
totalHeight = 7.0;

// Inside of spring is about 5.8mm
insideWidth = 5.7;

// Must fit the M3 tensioning screw inside, bigger than 2.8, but shouldn't be too loose
hollowWidth = 3.2;

// How far screw will extend into the part before pushing it and the spring
hollowHeight = 5.0; 

// height for spacerThingy (optional, for other side of spring)
spacerHeight = 4.2;

// number of faces to give the cylinders
$fn=36;

module tensionerThingy() {
    difference() {
        union() {
            // base part that holds the spring
            translate([0,0,baseHeight/2]) 
                cylinder(h=baseHeight, d=baseWidth, center=true);
            
            // inside part, goes inside the spring
            translate([0,0,totalHeight/2]) 
                cylinder(h=totalHeight, d=insideWidth, center=true);
        }
        
        // carve out the hollow where the tensioning screw will rest.
        // part of the screw is "used up" to provide stability
        // the rest of the screw can be rotated to move this gadget back and
        // forth to adjust the tension a little bit.
        translate([0,0,(hollowHeight/2)-0.001]) 
            cylinder(h=hollowHeight, d=hollowWidth, center=true);
    }
}

// This is just a simple cylindrical spacer
// Optional, but can use on the screw opposite the
// tensionerThingy for a more symmetric look.

module spacerThingy() {
    difference() {
        // spacer outside
        translate([0,0,spacerHeight/2]) 
            cylinder(h=spacerHeight, d=insideWidth, center=true);
        
        // spacer inside
        translate([0,0,(spacerHeight/2)]) 
            cylinder(h=spacerHeight+0.001, d=hollowWidth, center=true);
    }
}


tensionerThingy();
//spacerThingy();

