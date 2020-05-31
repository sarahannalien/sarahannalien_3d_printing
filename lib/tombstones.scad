//
//  Some "tombstone-like" shapes.
//  (basically a half-circle on top of a rectangle)
//  (sorry I couldn't think of what else to call them!)
//

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


// squared off edges
module tombstone(height = 70, width = 40, thickness = 6) {
    h = height - (width/2);
    rotate([90,0,0])
    translate([0,h,0])
    union() {
        difference() {
            cylinder(d=width, h = thickness, center=true);
            translate([0, -(width/2), 0]) 
                cube([width,width,thickness*1.03], center=true);
        }
        
        translate([0,-(h/2),0])cube([width, h, thickness],center=true);
    }

}


// rounded edges. 
// Center can be inset between 0 and thickness;
// inset=0 is a flat surface and inset=thickness will be hollow inside.
module roundedTombstone(height=70, width=40, thickness=6, inset=2) {
    w = width/2;
    r = thickness/2;
    foo = w - r;
    echo("w = ", w);
    echo("r = ", r);
    echo("foo = ",foo);
    rotate([90,0,0])
    translate([0,height-w,0])
    union() {
        rotate_extrude(angle=180, convexity = 10)
            translate([foo, 0, 0])
                circle(r);
        
        rotate_extrude(angle=180, convexity = 10)
            translate([(foo)/2,0,0])
                square([foo,thickness-inset], center=true);
        
        rotate([90,0,0]) translate([foo,0,0])cylinder(r=r, h=height-w);
        rotate([90,0,0]) translate([-foo,0,0])cylinder(r=r, h=height-w);
        translate([0,-(height-w)/2,0]) cube([2*(foo),height-w,thickness-inset], center=true);
        
    }
}

// example
translate([-25,0,0]) roundedTombstone($fn=72);
translate([25,0,0]) tombstone($fn=72);