
//
//  Generate what is HOPEFULLY a close to typical
//  2020 aluminum extrusion shape.
//
//  Copyright (c) 2020 Sarah Kelley, sarah@sakelley.org
//  First version 5/19/2020.
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


module Extrusion2020(
    h=10,                     // height of the extrusion to generate
    centerDiameter=4.37,      // diameter of the center hole
    roundCornerAmount=0,      // if more than zero, round the corners this much 
    tolerance = 1.0) {        // adjust some tolerances "a little bit"
    
    // Slight tolerance adjustment to make things look right in preview
    diffTolerance = 0.002;

    // Most of the dimensions for the inner channel are taken
    // from a mechanical drawing I found at 8020.net.
    // The only value I couldn't find I labeled mv for mysteryValue
    // and measured the extrusion on my 3D printer for what I hope
    // will be a reasonable value.
    // Hopefully this little diagram will make it easier to visualize.
    // (Use a monospace font!)
    //
    //        0,0 x1  x2    y1
    //      |     |          
    // ------     -----     y2
    // |              |         "mystery value"
    //  \            /      y3
    //   \----------/
    //             x3       y4
    //
    module inner_channel_outline(
        t = 1 // tolerance, to make a little bigger or smaller
    ) {
        mv = (1.72 * t);   // mystery value, not on drawing I have.
        mv2 = 0.45;
        x1 = (5.26 / 2) * t;   // from drawing
        x2 = (11.99 / 2) * t;  // from drawing
        x3 = x1 + mv2;         // eyeball/wild-ass guess. looks like they line up.
        y1 = 0;          // our starting point!
        y2 = (1.5 * t);        // from drawing
        y4 = (4.70 + y2) * t;  // from drawing
        y3 = (y2 + mv) * t;    // not on drawing.
        polygon([[x1,y1],[x1,y2],[x2,y2],[x2,y3],[x3,y4],
            [-x3,y4],[-x2,y3],[-x2,y2],[-x2,y2],[-x1,y2],
            [-x1,y1],[x1,y1]]);
    }

    intersection() {
        
        difference() {
            
            // The outline of the extrusion
            cube([20,20,h], center=true);
            
            // The hole down the center
            cylinder(h=h + diffTolerance, d=centerDiameter, center=true, $fn=36);
            
            // The inner channels on the four sides
            for (r=[0, 90, 180, 270]) 
                rotate([0,0,r]) 
                    translate([0,-10-diffTolerance,0]) 
                        linear_extrude(
                                height=h+diffTolerance, 
                                center=true, 
                                convexity=10)
                            inner_channel_outline(t=tolerance);
        }
        
        // Round the corners if requested
        maxRoundCornerDiameter = sqrt(20*20 + 20*20);
        if (roundCornerAmount > 0)  
            cylinder(h = h + diffTolerance, 
                d = maxRoundCornerDiameter-roundCornerAmount,
                $fn = 180);
    }
}
Extrusion2020(5, roundCornerAmount=1);

