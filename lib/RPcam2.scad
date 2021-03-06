//
//  A Raspberry Pi V2.1 Camera Module
//
//  Note this is for general visualization of physical fit
//  and is a simplified model.
//
//  Key variables are exposed for use in other projects.
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

include <./RPcam2_vars.scad>;

module Raspberry_Pi_Camera_v21(
    width = RPcam2_width,
    height = RPcam2_height,
    pcbBoardThickness = RPcam2_pcbBoardThickness,
    pcbMaskThickness = 0.1,        // purely cosmetic in this model!
    mountingHoleDiameter = RPcam2_mountingHoleDiameter,
    mountingHoleMaskDiameter = 5,  // also cosmetic
    mountingHoleToEdge = RPcam2_mountingHoleToEdge,
    upperHolesPos = RPcam2_upperHolesPos,
    lowerHolesPos = RPcam2_lowerHolesPos,
    cameraWidth = RPcam2_cameraWidth, 
    cameraHeight = RPcam2_cameraHeight,
    cameraCubeThickness = RPcam2_cameraCubeThickness,
    cameraDiameter = RPcam2_cameraDiameter,
    cameraCylinderThickness = RPcam2_cameraCylinderThickness,
    cameraXOffset = RPcam2_cameraXOffset,
    cameraYOffset = RPcam2_cameraYOffset,
    cutout = false,
    cutoutTolerance = RPcam2_cutoutTolerance,  // make cutout slightly bigger for tolerance.
    j2Width1 = 7,
    j2Width2 = 9,
    j2Length1 = 3.5,
    j2Length2 = 4.5,
    j2Thickness = 1.5,
    depthToCutOut = 20,    // arbitrary depth when cutting hole for camera pcb
    mountingHoleDepth = 4  // whem mounting holes are cut out
    
) {
    pcbThickness = pcbBoardThickness - pcbMaskThickness;
    
    module mountingHole(side, holesPos) {
        // make holes smaller in cutout so we can thread screws into them
        mhDiam = cutout ? mountingHoleDiameter * 0.8 : mountingHoleDiameter;
        mhd = cutout ? mountingHoleDepth : pcbBoardThickness;
        mhmd = cutout ? mhDiam : mountingHoleMaskDiameter;
        translate([
                ((width/2)-mountingHoleToEdge)*side,
                (height/2)-holesPos,
                mhd/2])
            cylinder(d=mhDiam, h=mhd, center=true);
        translate([((width/2)-mountingHoleToEdge)*side,(height/2)-holesPos,
                (pcbBoardThickness/2)+(pcbMaskThickness/2)])
            cylinder(d=mhmd, h=pcbMaskThickness*2, center=true);
    }
    
    module mountingHoles() {
        leftSide = -1;
        rightSide = 1;
        mountingHole(leftSide,  upperHolesPos);
        mountingHole(rightSide, upperHolesPos);
        mountingHole(leftSide,  lowerHolesPos);
        mountingHole(rightSide, lowerHolesPos);
    }
    
    module pcb() {
        difference() {
            union() {
                // TODO: make these rounded rectangles
                color("DarkKhaki") 
                    cube([width, height, pcbBoardThickness], center=true);
                translate([0,0, (pcbBoardThickness/2) + (pcbMaskThickness/2)])
                color("LimeGreen") 
                    cube([width, height, pcbMaskThickness], center=true);
            }
            mountingHoles();
        }
    }
    
    module pcbCutout() {
        translate([0,0, (pcbBoardThickness/2)])
        translate([0,0,-(depthToCutOut/2)])
            cube([width + cutoutTolerance, 
                height + cutoutTolerance, depthToCutOut], center=true);
    }
    
    // little thingy that connects camera module to the PCB
    module j2Connector() {
        ctol = cutout ? cutoutTolerance : 0;
        j2t = cutout ? j2Thickness + pcbThickness + ctol : j2Thickness;
        color("Gray")
        translate([
                cameraXOffset,
                cameraYOffset + (cameraHeight/2) + (j2Length1/2) + ctol/2,
                //(pcbThickness/2)+(cameraCubeThickness/2) ])
                (cameraCubeThickness/2) - (j2t/2)])
            cube([j2Width1+ctol, j2Length1+ctol, j2t], center=true);
        
        color("Gray")
        translate([
                cameraXOffset - ((j2Width2+ctol)-(j2Width1+ctol))/2,
                cameraYOffset + (cameraHeight/2) + (j2Length1/2) + (j2Length2/2) 
                    + (ctol/2) + (ctol/2),
                //(pcbThickness/2)+(cameraCubeThickness/2) ])
                (cameraCubeThickness/2) - (j2t/2)])
            cube([j2Width2+ctol, j2Length2+ctol, j2t*1],center=true);
        
    }
    
    module camera(camCylThickness) {
        ctol = cutout ? cutoutTolerance : 0;
        translate([cameraXOffset,cameraYOffset,
            (pcbThickness/2)+(cameraCubeThickness/2) ])
        union() {
            color("DarkSlateGray")
                cube([cameraWidth + cutoutTolerance, 
                    cameraHeight + cutoutTolerance, 
                    cameraCubeThickness],center=true);
            translate([0,0,(cameraCubeThickness/2)+(camCylThickness/2)]) 
                color("Gray")
                    cylinder(d=cameraDiameter + ctol, h=camCylThickness + ctol, 
                        center=true);
        }
    }
        
    if (cutout) {
        union() {
            camera(camCylThickness=20);
            pcbCutout();
            j2Connector();
            mountingHoles();
        }
    } else {
        union() {
            pcb();
            camera(camCylThickness=cameraCylinderThickness);
            j2Connector();
        }
    }

}

// instantiate an example
//Raspberry_Pi_Camera_v21($fn=36);

rotate([180,0,0]) difference() {
    translate([0,0,3.5]) cube([30,30,7],center=true);
    translate([0,0,1])Raspberry_Pi_Camera_v21(cutout=true, $fn=36);
}

