include <RPi4_vars.scad>

module cylinderStandoff(
        h = 1, 
        center = false,
        standoff_outer = RPi4_standoffDiameter,
        standoff_inner = RPi4_mountingHoleDiameter
) {
    difference() {
        cylinder(d=standoff_outer, h=h, center=center);
        cylinder(d=standoff_inner, h=h*1.01, center=center);
    }
}


//cylinderStandoff(center=true, $fn=36);


module standoffs(
    height=1,
    center=false,
    hSpacing = RPi4_mountingHoleHSpacing,
    vSpacing = RPi4_mountingHoleVSpacing
) {
    h2 = hSpacing/2;
    v2 = vSpacing/2;
    union() {
        translate([-h2,-v2,0]) cylinderStandoff(h=height, center=center);
        translate([-h2, v2,0]) cylinderStandoff(h=height, center=center);
        translate([ h2,-v2,0]) cylinderStandoff(h=height, center=center);
        translate([ h2, v2,0]) cylinderStandoff(h=height, center=center);
    }
}

module standoffHoles(
    height=1,
    center=false,
    hSpacing = RPi4_mountingHoleHSpacing,
    vSpacing = RPi4_mountingHoleVSpacing,
    standoff_inner = RPi4_mountingHoleDiameter,
) {
    h2 = hSpacing/2;
    v2 = vSpacing/2;
    h = height;
    union() {
        translate([-h2,-v2,0]) cylinder(d=standoff_inner, h=h*1.01, center=center);
        translate([-h2, v2,0]) cylinder(d=standoff_inner, h=h*1.01, center=center);
        translate([ h2,-v2,0]) cylinder(d=standoff_inner, h=h*1.01, center=center);
        translate([ h2, v2,0]) cylinder(d=standoff_inner, h=h*1.01, center=center);
    }
}

//
//  Four standoffs connected together by small 
module displaySupportBracket(
    thickness = 2.5,
    zThickness = 2.8,
    zLeftThickness = 0,
    standoffHeight = 11
) {
    h2 = RPi4_mountingHoleHSpacing/2;
    v2 = RPi4_mountingHoleVSpacing/2;
    z2 = standoffHeight / 2;
    t2 = thickness / 2;
    zt2 = zThickness / 2;
    zLt = zLeftThickness == 0 ? zThickness : zLeftThickness;
    standoffs(height=standoffHeight, center=true);

    // (color coded to make it easier to see.)
    union() {    
        // power-and-hdmi side. inset for gpio expansion board
        // that will also be able to make use of this bracket (I hope)
        // (3rd gpio expansion connector will need the inset)
        color("red")translate([0,-v2+RPi4_standoffDiameter,z2-zt2]) 
            cube([RPi4_mountingHoleHSpacing-(RPi4_mountingHoleDiameter*0), 
                thickness, zThickness], center=true);
        // gpio side. inset to make room for gpio connector
        color("orange")translate([0, v2-RPi4_standoffDiameter,z2-zt2]) 
            cube([RPi4_mountingHoleHSpacing-(RPi4_mountingHoleDiameter*0), 
                thickness, zThickness], center=true);
        // display connector  and micro-sd side
        color("lightgreen")translate([-h2,0,z2-(zLt/2)])
            cube([thickness,
                RPi4_mountingHoleVSpacing-RPi4_mountingHoleDiameter,
                zLt], center=true);
        // usb and ethernet side
        color("lightblue")translate([ h2,0,z2-zt2])
            cube([thickness,
                RPi4_mountingHoleVSpacing-RPi4_mountingHoleDiameter,
                zThickness], center=true);
    }
}

// bracket with some of the left side standoffs chopped off
// to fit in cases with tabs on the left side of the board.
// (consider trying leftNotchedDisplaySupportBracket instead)
module truncatedDisplaySupportBracket(standoffHeight = 11, offset = 2) {
    intersection() {
        displaySupportBracket();
        translate([offset, 0,0]) cube([
            RPi4_mountingHoleHSpacing+RPi4_standoffDiameter-offset,
            RPi4_mountingHoleVSpacing+RPi4_standoffDiameter,
            standoffHeight],
            center=true);
    }
}


// Bracket with small notches cut out of bottom of left side standoffs
// to accommodate tabs in the left side of the case, for instance,
// the clear CanaKit case.
// Note: values of offsetH very close to where the two standoff
// cylinders intersect may result in an object that is non-manifold,
module leftNotchableSupportBracket(
    standoffHeight = 11, 
        leftNotch = true,
        einkNotch = false,
        einkNotchSize = 22,
        einkNotchThickness = 5.8,
        thickness = 2.5,
        zThickness = 2.8,
        zLeftThickness = 0,
        offsetH = 3, 
        offsetZ = 2.0) {
    difference() {
        displaySupportBracket(
            standoffHeight = standoffHeight,
            thickness = thickness,
            zThickness = zThickness,
            zLeftThickness = zLeftThickness);
        
        if (leftNotch) translate([
                -(RPi4_mountingHoleHSpacing/2)-(RPi4_standoffDiameter/2), 
                0, 
                -(standoffHeight/2)+(offsetZ/2)])
            cube([2*offsetH,
                RPi4_mountingHoleVSpacing+(2.999*RPi4_mountingHoleDiameter),
                offsetZ*1.01], center=true);
       
       if (einkNotch) translate([
                -(RPi4_mountingHoleHSpacing/2),
                0,
                (standoffHeight/2)-(einkNotchThickness/2)+0.01])
            cube([thickness*1.01, einkNotchSize, einkNotchThickness],center=true);
    }
}


// render and print upside down so won't need supports!

// fits gpio expansion board etc
//rotate([0,180,0]) leftNotchableSupportBracket(
//    standoffHeight=11, $fn=90);

// Fits under 3.5 inch LCD (but that has no holes),
// for Waveshare 2.7 eink display, set einkNotch=true 
// (TODO: need smaller notch on righht)
//rotate([0,180,0]) leftNotchableSupportBracket(
//    standoffHeight=16,
//    leftNotch=false, zThickness = 5.8, zLeftThickness = 10, einkNotch = true, $fn=90);


module thingy(
    thickness = 2.5,
    zThickness = 2.8,
    zLeftThickness = 0,
    standoffHeight = 5,
    bracketHeight = 3
) {
    h2 = RPi4_mountingHoleHSpacing/2;
    v2 = RPi4_mountingHoleVSpacing/2;
    z2 = standoffHeight / 2;
    t2 = thickness / 2;
    zt2 = zThickness / 2;
    zLt = zLeftThickness == 0 ? zThickness : zLeftThickness;
    difference() {
        union() {
            translate([0,0,(standoffHeight-bracketHeight)/2]) 
                standoffs(height=standoffHeight, center=true);
            w = 5;
            d = 5;
            h = 3;
            n = 1.4;
            m = 1.5;
            //union() {
                translate([-h2,-v2-(w*n/2),0]) cube([w,d*n,bracketHeight], center=true);
                translate([-h2, v2+(w*n/2),0]) cube([w,d*n,bracketHeight], center=true);
                translate([ h2,-v2-(w*n/2),0]) cube([w,d*n,bracketHeight], center=true);
                translate([ h2, v2+(w*n/2),0]) cube([w,d*n,bracketHeight], center=true);
            //}
            difference() {
                translate([10,0,0])cube([(RPi4_mountingHoleHSpacing+20)*1.3,
                    RPi4_mountingHoleVSpacing*1.3,
                    bracketHeight],center=true);
                translate([10,0,0])cube([(RPi4_mountingHoleHSpacing+20)*1.2,
                    RPi4_mountingHoleVSpacing*1.2,
                    bracketHeight*1.01],center=true);
            }
        }
        translate([0,0,(standoffHeight-bracketHeight)/2]) 
            standoffHoles(height=standoffHeight, center=true);
    }    

}
module thingy2(
    height=1,
    center=false,
    hSpacing = RPi4_mountingHoleHSpacing,
    vSpacing = RPi4_mountingHoleVSpacing
) {
    h2 = hSpacing/2;
    v2 = vSpacing/2;
    union() {
        translate([-h2,-v2,0]) cylinderStandoff(h=height, center=center);
        translate([-h2, v2,0]) cylinderStandoff(h=height, center=center);
        translate([ h2,-v2,0]) cylinderStandoff(h=height, center=center);
        translate([ h2, v2,0]) cylinderStandoff(h=height, center=center);
    }
}

thingy($fn=90);
