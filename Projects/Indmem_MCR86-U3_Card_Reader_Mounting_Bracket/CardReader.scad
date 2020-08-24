// Height of the Card Reader
Card_Reader_Height = 16;

// Width of the Card Reader
Card_Reader_Width = 86;

// Depth of the Card Reader
Card_Reader_Depth = 50.5;

// Thickness of the Table
Table_Thickness = 16.8;

// How thick should the bracket be
Bracket_Thickness = 2;

// How much wider than the card reader should the bracket be
Bracket_Extra_Width = 6;

// How much deeper than the card reader should the bracket be
Bracket_Extra_Depth = 4;

module CardReaderHolder(
    crHeight=Card_Reader_Height,
    crWidth=Card_Reader_Width,
    crDepth=Card_Reader_Depth,
    tableThickness = Table_Thickness,
    bracketThickness = Bracket_Thickness,
    bracketExtraWidth = Bracket_Extra_Width,
    bracketExtraDepth = Bracket_Extra_Depth) 
{
    module CardReader() {
        translate([0, crDepth/2, -crHeight/2]) cube([crWidth, crDepth, crHeight],center=true);
    }

    module Table() {
        tDepth = crDepth * 10;
        translate([0,tDepth/2,tableThickness/2]) cube([crWidth*10,tDepth,tableThickness], center=true);

    }

    module BaseCube() {
        bcDepth = crDepth+(2*bracketExtraDepth);
        translate([0, bcDepth/2 - bracketExtraDepth, 0]) cube([
            crWidth+(2*bracketExtraWidth),
            bcDepth,
            crHeight + tableThickness + (2 * bracketThickness)],
            center = true);
    }
    
    module LargeFlatPart() {
        cube([
        crWidth + 2*bracketExtraWidth,
        crDepth + 2*bracketExtraDepth,
        bracketThickness], center=true);
    }

    module AngleBeam(size=1, height=2, center=true) {
        s2 = size/2;
        linear_extrude(height=height, center=center, convexity=1)
            polygon(
                points=[[-s2,-s2],[s2,-s2],[s2,s2],[0,s2],[0,0],[-s2,0]],
                paths=[[0,1,2,3,4,5,6,0]],
                convexity=2);
    }
    
    module HorizontalHoles() {
        w = (crWidth/2) * 0.8;
        d = (crDepth/2) * 0.8;
        size = 7;
        for (x=[-w-size/2:10:w+size/2]) {
            for (y=[-d-size/2:10:d+size/2]) {
                translate([0,crDepth/2+size/2,0])
                translate([x,y,0]) cube([size, size,100],center=true);
            }
        }
    }
    
    /*
    extendedWidth = crWidth + (8*bracketThickness);
    extendedDepth = crDepth + (3*bracketThickness);
    translate([0,0,-(crHeight/2)-(bracketThickness/2)]) LargeFlatPart();
    translate([0,0,(crHeight/2)+(bracketThickness/2)+tableThickness]) LargeFlatPart();
    %color([0.6, 0.8, 1, 0.5]) CardReader();
    %color([0.5,0.5,0.5,0.3]) Table();
    translate([-crWidth/2-bracketExtraWidth,-crDepth/2-bracketExtraDepth,crHeight/2]) AngleBeam(size=3, height=crHeight+tableThickness + 2*bracketThickness);
    translate([crWidth/2+bracketExtraWidth,-crDepth/2-bracketExtraDepth,crHeight/2]) AngleBeam(size=3, height=crHeight+tableThickness + 2*bracketThickness);
    
    */
    
    
    difference() {
        BaseCube();
        translate([0,0,+0.1]) 
            scale([1.05, 1.05, 1.05]) CardReader();
        translate([0,-bracketExtraDepth-0.1,0]) 
            scale([1.05, 1.05, 1.05]) CardReader();
        translate([0,+bracketExtraDepth+0.1,2*bracketThickness]) 
            scale([1.05, 1.05, 1.05]) CardReader();
        translate([0,0,0]) 
            scale([1, 1, 1.01]) Table();
        HorizontalHoles();
    }
}   

CardReaderHolder();

