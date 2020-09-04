// thickness of the parent shelf we will hang on
shelfThickness = 17;

// general thickness of the shelves
thickness = 2.4;

// how deep into our parent shelf 
depth = 50;

width = 90;



// ultimate: width 90, s1height=16, s2height=22, s3height=??
// but need holes/space in back for routing cables.

module hangingShelf(
    t=thickness, d=depth, w=width,
    
    // Usable height of each shelf
    s1height = 17, s2height = 24, s3height = 18,
    
    // offsets control how far out the shelf will stick
    // compared to the part that slides onto the parent
    // shelf. Use negative numbers to inset.
    s1Offset = 10, s2Offset = 25, s3Offset = 25) 
{
    x0 = 0;
    x1 = t;
    x2 = t + d;
    x3 = t + d + t;
    y0 = 0;
    y1 = t + shelfThickness + t;
    s1y = shelfThickness + t + t + s1height;
    s2y = s1y + t + s2height;
    s3y = s2y + t + s3height;
    
    poly = [
        [x0,y0],  // 0
        [x3,y0],  // 1
        [x3,y1], // 2
        [x1,y1], // 3
        [x1,s1y], // 4
        [x3+s1Offset,s1y],  // 5
        [x3+s1Offset,s1y+t], // 6
        [x1,s1y+t], // 7
        [x1,s2y], // 8
        [x3+s2Offset,s2y], // 9
        [x3+s2Offset,s2y+t], // 10
        [x1,s2y+t], // 11
        [x1,s3y], // 12
        [x3+s3Offset,s3y], // 13
        [x3+s3Offset,s3y+t], // 14
        [x0,s3y+t], // 15
        [x0,y0+t+shelfThickness], // 16
        [x2,y0+t+shelfThickness], // 17
        [x2, t], // 18
        [x0,t]];// 19    
    
    linear_extrude(height=w,convexity=10, center=true) 
        polygon(poly,[[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,0]]);
        
}


hangingShelf();
