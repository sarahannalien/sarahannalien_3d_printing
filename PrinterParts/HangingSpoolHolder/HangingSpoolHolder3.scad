
// generally, how thick will the bracket be?
thickness = 4;



hanging_height = 135;
hanging_width = 90;

mounting_bracket_width = 90;
mounting_bracket_length = 20;
mounting_bracket_hole_diameter = 5.5;
mounting_bracket_hole_pos_1 = 25;
mounting_bracket_hole_pos_2 = 75;

container_width = 100;

spindle_diameter = 20;
spindle_clearance = 5;  // fudge factor to adjust clearance of spindle with sides

// TOTAL spindle length, straight and angled parts
spindle_length = container_width - thickness - spindle_clearance;

spindle_angled_part_height = 7;  // angled bits of the spindle

sdheight = spindle_diameter/3;


spindle_mount_diameter = 15;
spindle_mount_height = 12; // more like 15!
spindle_mount_step = 45;


// shoulder for spindle mounts
shoulderThickness = 1;

module wobblyCircleExtrude(
    radius=10, wobble=6, wobbleRadius=2, step=4, 
    height=10,
    convexity=10) 
{        
    function circleFn(r, wobble, wobbleRadius, deg) =
        let(bar=r-(sin(deg*wobble)*wobbleRadius))
            [bar*sin(deg),bar*cos(deg)];

    circlePoints = [for (deg=[0:step:360]) 
        circleFn(radius,wobble, wobbleRadius, deg)];
    circlePath = 
        concat([ for (i=[0:len(circlePoints)-1]) i ],0);
    
    linear_extrude(height=height, center=true, convexity=convexity)
        polygon(circlePoints, [circlePath]);
}


module spindleBearingMount() {
    //thickness = 4;
    bearingMountThickness = 7;
    shoulderDiameter = 11;
    bearingMountDiameter = 7.2;
    bearingMountWobble = 24;
    bearingMountWobbleRadius = 0.4;
    bearingMountStep = 2;
    cube([14,thickness,14],center=true);
    translate([0,(thickness/2)+(shoulderThickness/2),0])
        rotate([90,0,0]) 
            cylinder(d=shoulderDiameter,h=shoulderThickness,center=true, $fn=36);
    translate([0,(thickness/2)+(shoulderThickness/2)+(bearingMountThickness/2),0]) 
        rotate([90,0,0]) wobblyCircleExtrude(bearingMountDiameter/2, 
            bearingMountWobble, bearingMountWobbleRadius, bearingMountStep,
        height=bearingMountThickness);
}

/*
 *  A spool holder to use in a dry box made from
 *
 *  "ME.FAN EXTRA LARGE Cereal Storage Containers 
 *  [Set of 2] Airtight Food Storage Containers 
 *  6.3L(213oz) - Large Kitchen Storage Keeper 
 *  with 24 Chalkboard Labels & Pen - Easy 
 *  Pouring Lid (Blue)" 
 *
 *  https://www.amazon.com/gp/product/B085ZBCLLN
 *  (As of 8/29/2020)
 *
 *  Dimensions are roughly 
 *  11 inches x 11.2 inches x 3.94 inches
 *
 *  Dry box parts will all mount into the lid to make
 *  it more convenient to interchange spools.
 *
 */
module hangingSpoolHolder() {
    module spindleMount() {
        translate([0,0,spindle_mount_height/2])
        cylinder(d=spindle_mount_diameter,
            h=spindle_mount_height,
            center=true);
    }
    
    // The part that hangs down into the container
    module hangingPart() {
        cube([hanging_height,mounting_bracket_length,thickness], center=true);
        mbl2 = mounting_bracket_length/2;
        hh = sdheight*0.7;
        // reinforcement bars
        //for (y = [-mbl2+(thickness/2),0,mbl2-(thickness/2)]) {
        //    translate([0,y,hh-thickness]) 
        //        cube([hanging_height,thickness,hh],center=true);
        //}
        // spindle mount points
        for (x=[0:spindle_mount_step:(hanging_height/2)-(spindle_mount_step/2)]) {
            translate([x,0,0]) rotate([90,0,0]) spindleBearingMount();
        }
    }
    
    // Holes in the part that hangs down into the container
    // (saves material, and a little print time) 
    module hangingPartHoles() {
        //translate([-8,0,0])
        //cube([hanging_height*0.7, mounting_bracket_length*0.7,1000], center=true);
        
        //n = 16;
        //for (x=[-(hanging_height/2)+(2*n):n:(hanging_height/2)-(2*n)]) {
        //    translate([x,mounting_bracket_length/4.5,0]) 
        //        cylinder(d=n/2, h=1000, center=true);
        //    translate([x,-mounting_bracket_length/4.5,0]) 
        //        cylinder(d=n/2, h=1000, center=true);
        //}
    }
    
    // The round part for the filament spool to sit on
    module spindle(hAngledPart=10) {
        sdbase = spindle_diameter * 1.5;
        /*
        //sdheight = spindle_diameter/3;
        //translate([
        //        (hanging_height/2)-(sdbase/2),
        //        0,
        //        (spindle_length/2)+(thickness/2)-0.1])
        translate([(hanging_height/2)-(sdbase/2),0,(spindle_length/2)+(thickness/2)])
            cylinder(d=spindle_diameter, h=spindle_length+(thickness/2), center=true);
        //translate([
        //        (hanging_height/2)-(sdbase/2),
        //        0,
        //        (sdheight/2)+(thickness/2)-0.1])
            //cylinder(d1=sdbase, d2=spindle_diameter, h=sdheight, center=true);
        */
         saph = spindle_angled_part_height;
         ssph = spindle_length - ( 2 * saph);
         fudge_factor = 0.5;
         translate([(hanging_height/2)-(sdbase/2),0,(ssph/2)+(2*saph)-(thickness/2)-fudge_factor])
         union() {
            cylinder(d=spindle_diameter, 
                h=ssph, 
                center=true);
            zz = (ssph/2)+(saph/2);
            translate([0,0,zz]) 
                cylinder(d1=spindle_diameter, d2=spindle_diameter*1.3, h=saph ,center=true);
            translate([0,0,-zz]) 
                cylinder(d2=spindle_diameter, d1=spindle_diameter*1.3, h=saph ,center=true);
        }
    }
    
    // The part that will screw into the lid of the container
    module mountingBracket() {
        t1 = thickness * 2;
        translate([
                -(hanging_height/2)+(t1/2),
                0,
                (mounting_bracket_width/2)+(thickness/2)-0.1])
            cube([t1,mounting_bracket_length, mounting_bracket_width], center=true);
        
        //rs = thickness*1.2;
        // reinforcement for the corner
        //translate([
        //        -(hanging_height/2)+(rs/2),
        //        0,
        //        (rs/2)+(thickness/2)-0.1])
        //    cube([rs,mounting_bracket_length, rs], center=true);
        
        //foo = 8;
        //fez = 3*foo;
        //bar = (mounting_bracket_length/2) - (thickness/2);
        //for (y=[-bar, bar]) {
        //    translate([-(hanging_height/2)+thickness+foo/2,y,(hanging_width/2)+(thickness/2)])
        //        cube([foo,thickness,hanging_width],center=true);
        //    translate([-(hanging_height/2)+thickness+fez/2,y,(fez/2)+(thickness/2)])
        //        cube([fez,thickness,fez],center=true);
        //}
    }
    
    // Holes for the screws for attaching the mounting bracket to the lid
    // FIXME: Center the holes on next generation.
    // (Can't fix for this one, container is already drilled!)
    module mountingBracketHoles() {
        for (y=[-2:1:2]) {  // really VERY sub-optimal.
            rotate([0,90,0]) {
                union() {
                    translate([-mounting_bracket_hole_pos_1,y,0])
                        cylinder(d=mounting_bracket_hole_diameter,h=1000, center=true);
                    translate([-mounting_bracket_hole_pos_2,y,0])
                        cylinder(d=mounting_bracket_hole_diameter,h=1000, center=true);
                }
            }
        }
    }
    
    // Put all the pieces together!
    union() {
        translate([0,0,0]) hangingPart();
        translate([0,0,mounting_bracket_width+thickness-0.4]) 
            // FIXME: Not sure why we need to translate here.
            // but without it two sides aren't connected!
            rotate([0,180,180]) hangingPart();
        //difference() {
        //    hangingPart();
        //    hangingPartHoles();
        //}
        //rotate([0,-2,0])spindle();
        difference() {
            mountingBracket();
            mountingBracketHoles();
        }
    }
    
}





module spindle(
    bearingWidth = 7,
    bearingDiameter = 23, // 22 was too small with 0.4mm nozzle,
    spindleDiameter = 28,
    spindleLength = mounting_bracket_width - (2*shoulderThickness),
    spindleInnerDiameter = 18
)
{
    difference() {
        cylinder(d=spindleDiameter, h=spindleLength, center=true, $fn=180);
        cylinder(d=spindleInnerDiameter, h=spindleLength*1.1, center=true, $fn=180);
        translate([0,0,(spindleLength/2)-(bearingWidth/2)+0.1])
            cylinder(d=bearingDiameter, h=bearingWidth, center=true, $fn=72);
        translate([0,0,-(spindleLength/2)+(bearingWidth/2)-0.1])
            cylinder(d=bearingDiameter, h=bearingWidth, center=true, $fn=72);

    }
}

//spindleMount();


//spindle();
rotate([90,0,0]) hangingSpoolHolder($fn=45);
