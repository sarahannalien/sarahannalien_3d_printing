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

// basic width of the camera board
RPcam2_width = 25.27;

// basic height of the camera board
RPcam2_height = 23.9;

// basic thickness of the camera board
RPcam2_pcbBoardThickness = 1.1;

// diameter of mounting holes plus a little extra tolerance
RPcam2_mountingHoleDiameter = 2.4;

// edge of board to center of mounting hole
RPcam2_mountingHoleToEdge = 2.0; 

// offset for upper mounting holes
RPcam2_upperHolesPos = 2.25;

// offset for lower mounting holes
RPcam2_lowerHolesPos = 14.5;

// width of the camera module on the board
RPcam2_cameraWidth = 8.52; 

// height (y) of the camera module on the board
RPcam2_cameraHeight = 8.4;

// thickness of camera module plus mounting dealie
RPcam2_cameraCubeThickness = 4.5; 

// diameter of just the round part of the camera
RPcam2_cameraDiameter = 7.3;

// thickness of just the round part of the camera module
RPcam2_cameraCylinderThickness = 2.4;

// x offset to position the camera module on the board
RPcam2_cameraXOffset = 0;

// y offset to position the camera module on the board
RPcam2_cameraYOffset = (RPcam2_height/2)-14;

// make cutout slightly bigger than the object that goes in it
RPcam2_cutoutTolerance = 1;
