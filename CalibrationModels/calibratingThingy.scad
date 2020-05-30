//
//   A calibration thingy.
//   Billions of better ones are on Thingiverse etc. FYI.
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


module calibratingThingy(width, depth, spacing,
    calibrationSize=10,
    calibrationThickness=1.0) 
{

    module hemisphere(d) 
    {
        intersection() 
        {
            sphere(d=d);
            translate([0,0,d/2])cube([d,d,d], center=true);
        }
    }

    module calibrationSquares() {
        for (   w=[-(width/2):spacing:width/2], 
                d=[-(depth/2):spacing:depth/2]) 
        {
            if (!(w==0&&d==0)) translate([w, d, 0]) 
            {
                union() {
                    cube([calibrationSize, 
                        calibrationSize, 
                        calibrationThickness], center=true);
                    hemisphere(d=calibrationSize*0.5, $fn=60);
                }
            }
        }
    }

    module label(text, height=2*calibrationThickness, size=5) {
        color("red") 
            linear_extrude(height=height, center=true) 
                text(text=text, size=size);
    }
    
    
    module centerSquare() {
        q = 3*calibrationSize;
        ct = calibrationThickness;
        union() {
            cube([q, q, ct], center=true);
            hemisphere(d=calibrationSize*0.5, $fn=60);
            translate([-q/2,0,ct/2]) label("-X");
            translate([q/5,0,ct/2]) label("+X");
            translate([0,-q/2,ct/2]) label("-Y");
            translate([0, q/3,ct/2])label("+Y");
        }
   }
    
    module connectingBars() 
    {
        union() {
            for(w=[-(width/2):spacing:width/2]) {
                translate([w,0,calibrationThickness/2]) 
                cube([calibrationThickness,
                    depth,
                    calibrationThickness*2], center=true);
            }
            for(d=[-(depth/2):spacing:depth/2]) {
                translate([0,d,calibrationThickness/2]) 
                cube([width,
                    calibrationThickness,
                    calibrationThickness*2], center=true);
            } 
        }
    }
    
    union() 
    {
        calibrationSquares();
        centerSquare();
        connectingBars();
    }
    
}




calibratingThingy(
    width=90,
    depth=90,
    spacing=45, 
    calibrationSize=10, 
    calibrationThickness=1.0);
