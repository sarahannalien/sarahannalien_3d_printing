//
//  First version of magnet mount plate -- just a test
//
//  space two countersunk magnets 20mm apart on a little
//  plastic plate to mount on a 20mm extrusion.
//  VERY MUCH A WORK IN PROGRESS!
//

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


holeSize = 3.3;
width = 20;
length = 40;
thickness = 1.5;


difference() {
    cube([width,length,thickness], center=true);
    translate([0,(-length/2)+(width/2),0]) 
        cylinder(h = 1000, d=holeSize, center=true, $fn=36);
    translate([0,(length/2)-(width/2),0]) 
        cylinder(h = 1000, d=holeSize, center=true, $fn=36);
}