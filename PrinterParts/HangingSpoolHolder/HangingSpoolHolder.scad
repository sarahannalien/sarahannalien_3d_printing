
// generally, how thick will the bracket be?
thickness = 10;



hanging_height = 135;
hanging_width = 90;

mounting_bracket_width = 90;
mounting_bracket_length = 35;
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
    
    // The part that hangs down into the container
    module hangingPart() {
        cube([hanging_height,mounting_bracket_length,thickness], center=true);
        //mbl2 = mounting_bracket_length/2;
        //hh = sdheight*0.7;
        //for (y = [-mbl2+(thickness/2),0,mbl2-(thickness/2)]) {
        //    translate([0,y,hh-thickness]) 
        //        cube([hanging_height,thickness,hh],center=true);
        //}
    }
    
    // Holes in the part that hangs down into the container
    // (saves material, and a little print time) 
    module hangingPartHoles() {
        //translate([-8,0,0])
        //cube([hanging_height*0.7, mounting_bracket_length*0.7,1000], center=true);
        
        n = 16;
        for (x=[-(hanging_height/2)+(2*n):n:(hanging_height/2)-(2*n)]) {
            translate([x,mounting_bracket_length/4.5,0]) 
                cylinder(d=n/2, h=1000, center=true);
            translate([x,-mounting_bracket_length/4.5,0]) 
                cylinder(d=n/2, h=1000, center=true);
        }
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
        t1 = thickness; // * 1.5;
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
        difference() {
            hangingPart();
            hangingPartHoles();
        }
        rotate([0,-2,0])spindle();
        difference() {
            mountingBracket();
            mountingBracketHoles();
        }
    }
    
}

hangingSpoolHolder($fn=45);
