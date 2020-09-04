acu_depth= 27;
acu_width = 60;
acu_length = 78;

acu_stand_width = 27;
acu_stand_depth = 8;

bracket_thickness = 1.8;

//bracket_depth = 40;
//bracket_width = 70;
//bracket_length = 85;

bracket_depth = acu_depth + acu_stand_depth + (2*bracket_thickness);
bracket_width = acu_width + (2*bracket_thickness);
bracket_length = acu_length + (2*bracket_thickness);


mounting_tab_width = bracket_width;
mounting_tab_length = 12;
mounting_tab_thickness = 4;
mounting_tab_hole_diameter = 3.7;

module acuriteBracket3() {
    function makePoly(asw2, aw2, at, asd, ad, atd, adj=2.5) = [
        //[0,    0],          // 0
        //[asw2,    0],       // 1
        [asw2,asd],     // 2
        [aw2,asd],      // 3
        [aw2+adj,asd+ad],       // 4
        [aw2+at, asd+ad],     // 5
        [aw2+at, asd+ad+atd], // 6
        [-aw2-at,asd+ad+atd],  // 7
        [-aw2-at, asd+ad],   // 8
        [-aw2-adj,asd+ad],      // 9
        [-aw2,asd],     // 10
        [-asw2,asd],    // 11
        //[-asw2,    0]       // 12
        ];
    
    module outline(asw2, aw2, at, asd, ad, atd, height=10) {
        poly = makePoly(asw2, aw2, at, asd, ad, atd);
        translate([0,-(asd+ad+atd)/2, 0]) 
            linear_extrude(height=height, center=true, convexity=10)
                polygon(poly);
    }
    asw2 = acu_stand_width/2;
    aw2 = acu_width/2;
    at = mounting_tab_length;
    asd = acu_stand_depth;
    ad = acu_depth;
    atd = mounting_tab_thickness;
    difference() {
        scale([1.1,1.1,1.0]) outline(asw2, aw2, at, asd, ad, atd, height=mounting_tab_length);
        scale([1.0, 1.0, 2.0]) outline(asw2, aw2, 0, asd, ad, 0, height=mounting_tab_length);
        hx = (aw2+at)-2.5;  // minor fudge factor, sorry!
        translate([hx,0,0]) rotate([90,0,0])
            cylinder(h=1000, d=mounting_tab_hole_diameter,center=true, $fn=36);
        translate([-hx,0,0]) rotate([90,0,0])
            cylinder(h=1000, d=mounting_tab_hole_diameter,center=true, $fn=36);
        translate([0,-(asd/2)-(ad/2),0])cube([acu_stand_width,20,20], center=true);
    }
    // a little tab to keep the unit from sliding out
    cs=6; 
    translate([0,(asd/2)+(ad/2)-(cs/2),-5]) cube([15,cs,2],center=true);
    
    // little dots to hold the whole thing in just a bit tighter
    translate([-16.5,-asd-2,-2.5]) sphere(d=5, $fn=60);
    translate([ 16.5,-asd-2,-2.5]) sphere(d=5, $fn=60);
    translate([-16.5,-asd-2, 2.5]) sphere(d=5, $fn=60);
    translate([ 16.5,-asd-2, 2.5]) sphere(d=5, $fn=60);
    
}

module acuriteBracket2() {
    function makePoly(asw2, aw2, at, asd, ad, atd, adj=2.5) = [
        [0,0],          // 0
        [asw2,0],       // 1
        [asw2,asd],     // 2
        [aw2,asd],      // 3
        [aw2+adj,asd+ad],       // 4
        [aw2+at, asd+ad],     // 5
        [aw2+at, asd+ad+atd], // 6
        [-aw2-at,asd+ad+atd],  // 7
        [-aw2-at, asd+ad],   // 8
        [-aw2-adj,asd+ad],      // 9
        [-aw2,asd],     // 10
        [-asw2,asd],    // 11
        [-asw2,0]       // 12
        ];
    
    module outline(asw2, aw2, at, asd, ad, atd, height=10) {
        poly = makePoly(asw2, aw2, at, asd, ad, atd);
        translate([0,-(asd+ad+atd)/2, 0]) 
            linear_extrude(height=height, center=true, convexity=10)
                polygon(poly);
    }
    asw2 = acu_stand_width/2;
    aw2 = acu_width/2;
    at = mounting_tab_length;
    asd = acu_stand_depth;
    ad = acu_depth;
    atd = mounting_tab_thickness;
    difference() {
        scale([1.1,1.1,1.0]) outline(asw2, aw2, at, asd, ad, atd, height=mounting_tab_length);
        scale([1.0, 1.0, 2.0]) outline(asw2, aw2, 0, asd, ad, 0, height=mounting_tab_length);
        hx = (aw2+at)-2.5;  // minor fudge factor, sorry!
        translate([hx,0,0]) rotate([90,0,0])
            cylinder(h=1000, d=mounting_tab_hole_diameter,center=true, $fn=36);
        translate([-hx,0,0]) rotate([90,0,0])
            cylinder(h=1000, d=mounting_tab_hole_diameter,center=true, $fn=36);
        translate([0,-(asd/2)-(ad/2),0])cube([4,10,20], center=true);
    }
    // a little tab to keep the unit from sliding out
    cs=6; 
    translate([0,(asd/2)+(ad/2)-(cs/2),-5]) cube([15,cs,2],center=true);
    
}

module acuriteBracket() {
    module mountingTab() {
        difference() {
            cube([mounting_tab_width,mounting_tab_length,mounting_tab_thickness],center=true);
            xhole = (mounting_tab_width/2)-(mounting_tab_length/2);
            translate([-xhole,0,0]) cylinder(d=mounting_tab_hole_diameter, h=1000, center=true);
            translate([xhole,0,0]) cylinder(d=mounting_tab_hole_diameter, h=1000, center=true);
        }
    }
    
    difference() {
        d1 = (bracket_depth/2)-(acu_depth/2)+0.01;
        d2 = (bracket_depth/2)-(acu_depth)-(acu_stand_depth/2)+0.02;
        union() {
            cube([bracket_width,bracket_length,bracket_depth],center=true);
            ytab = (bracket_length/2) + (mounting_tab_length/2)-0.01;
            ztab = (bracket_depth/2)-(mounting_tab_thickness/2);
            translate([0,-ytab,ztab]) mountingTab($fn=36);
            translate([0,ytab,ztab]) mountingTab($fn=36);
        }
        translate([0,0,d1]) cube([acu_width,acu_length,acu_depth],center=true);
        translate([0,0,d2]) cube([acu_stand_width,acu_length,acu_stand_depth], center=true);
        //cube([100,10,100],center=true);
        y1 = (bracket_length/2)-((bracket_length-acu_length)/2)-(bracket_length/10);
        #for (y = [-y1:8:y1]) {
            translate([-66,y,-(bracket_depth/12)]) cube([100,4,bracket_depth],center=true);
            translate([ 66,y,-(bracket_depth/12)]) cube([100,4,bracket_depth],center=true);
        }
        // use less material and print faster!
        translate([0,0,0]) cube([acu_stand_width*0.7,acu_length*0.9,1000], center=true);
        b1 = bracket_width / 13;
        b2 = b1 * 3;
        b2a = b2 * 0.7;
        bx = (b2/2) + b1 + (b2/2);
        for (z = [0:bracket_thickness*2:(bracket_depth/2)-mounting_tab_thickness]) {
            translate([-bx,0,z]) cube([b2a,1000,bracket_thickness],center=true);
            translate([0,0,z]) cube([b2,1000,bracket_thickness],center=true);
            translate([bx,0,z]) cube([b2a,1000,bracket_thickness],center=true);
        }
    }
}


acuriteBracket3();
