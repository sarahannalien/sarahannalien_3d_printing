use <../../lib/tombstones.scad>;
include <../../lib/RPcam2_vars.scad>;
use <../../lib/RPcam2.scad>;

echo("Z", RPcam2_height);

LED_Ring_Inner = 23.2;

LED_Ring_Outer = 37.7;

LED_Ring_Thickness = 3.25;

module TombstoneCameraMount(
    width=43, 
    height=92,
    thickness = 10,
    inset = 2,
    extrusionSize=20,
    mountingTabThickness = 4,      // should be >= mountingHoleTaperHeight!
    mountingHoleDiameter = 3.6,
    mountingHoleTaperDiameter = 6,
    mountingHoleTaperHeight = 2,
    lensHeight = 60,
    coverThickness = 1.5,
    coverBottomCutoutHeight = 3
) {
    echo("A", RPcam2_height);
   
    module ledRing(adjOuter=1.05, adjInner=0.95) {
        difference() {
            cylinder(d=LED_Ring_Outer*adjOuter, h=LED_Ring_Thickness, center=true);
            cylinder(d=LED_Ring_Inner*adjInner, h=LED_Ring_Thickness*1.1, center=true);
        }
    }
    module ledUnderRing(adjOuter=1.05, adjInner=0.95) {
        ledRing(adjOuter=0.9, adjInner=1.1);
    }
    module ledWiresCutout() {
        //cylinder(d=2, h=50, center=true);
        cube([4,2,50],center=true);
    }
    module ledLipFirstIdea() {
        
        #rotate([0,0,-135]) rotate_extrude(angle=90,convexity=10) {
            translate([1,1,0]) square([0.5,1],center=false);
        }
    }
    module ledLip() {
        intersection() {
            difference() {
                cylinder(d1=LED_Ring_Outer*1.5, d2=LED_Ring_Outer*0.97, h=5, center=true);
                cylinder(d=LED_Ring_Outer*0.97, h=5.1, center=true);
                
            }
            rotate([0,0,-135]) cube([LED_Ring_Outer, LED_Ring_Outer, LED_Ring_Outer], center=false);
        }
    }
    
    module lensShroud(outer1=LED_Ring_Inner*1.2, outer2=15,inner=12, length=8) {
        difference() {
            cylinder(d1=outer1, d2=outer2, h=length, center=true);
            cylinder(d=inner, h=length*1.1, center=true);
        }
    }
   
    module mountingTabs() {
        wx = width + (2*extrusionSize);
        e2 = extrusionSize/2;
        mtt = mountingTabThickness;
        difference() {
            cube([wx, extrusionSize, mtt],center=true);
            for (xi=[-1,1]) {
                translate([xi*((wx/2)-e2),0,0]) 
                    cylinder(
                        d=mountingHoleDiameter, 
                        h=mtt*1.1, center=true);
                translate([xi*((wx/2)-e2),0, (mountingHoleTaperHeight/2)*1.1]) 
                    cylinder(
                        d1=mountingHoleDiameter, 
                        d2=mountingHoleTaperDiameter, 
                        h=mountingHoleTaperHeight, center=true);
            }
        }
    }
    
    // Cutout for Raspberry pi centered on the lens.
    module rpiCamCutout() {
        rotate([90,0,0]) Raspberry_Pi_Camera_v21(cutout=true, $fn=36);
    }
    
    module cableCutout(
            cyDiam = 170,
            cyThickness = 6,
            cyWidth = 20, // 16mm for cable + 4mm tolerance
    ) {
        fx = 0;
        fy = -1.0;
        fz = 26;
        translate([fx, (cyDiam/2) + fy, fz])
        rotate([90,0,90]) {
            difference() {
                cylinder(h=cyWidth, d=cyDiam, center=true);
                cylinder(h=cyWidth + 0.1, d=cyDiam-cyThickness, center=true);
            }
        }
    }
    
    module cableCover() {
        echo("B", RPcam2_height);
        v = lensHeight-(RPcam2_height/2) ;
        w = RPcam2_width + RPcam2_cutoutTolerance;
        color("lightblue")
        difference() {
            translate([ 0, 0, v/2 ])
                cube([w-0.1,thickness,v],center=true);
            
            //translate([ 0, -coverThickness, v/2 ])
            //    cube([w-(2*coverThickness),thickness,v*1.1],center=true);
            //translate([ 0, 0, 0 ])
            //    cube([w-(2*coverThickness),thickness*1.1,2],center=true);
        }
        
    }
    
    module bottomReinforcement() {
        scale([1,2,1]) cylinder(d=5, h=width, center=true);
    }
    
    difference() {
        union() {
            translate([0,((extrusionSize-thickness)/2)-2,mountingTabThickness]) 
                roundedTombstone(
                    width=width, 
                    height=height-mountingTabThickness,
                    thickness=thickness,
                    inset=inset);
            translate([0,0,mountingTabThickness/2]) mountingTabs();
            translate([0,(thickness/2), 
                    mountingTabThickness ]) 
                cableCover();
            translate([0,-0.75,lensHeight-(mountingTabThickness/2)]) 
                rotate([90,0,0])
                    lensShroud();
            translate([0,-1,lensHeight-(mountingTabThickness/2)]) 
                rotate([90,0,0])
                    ledLip();
            translate([0,0,mountingTabThickness]) rotate([0,90,0]) bottomReinforcement();
            
        }
        cutoutYfudgeFactor = 5.5;  // fixme?
        translate([0,cutoutYfudgeFactor,lensHeight]) rpiCamCutout();
        translate([0,(thickness/2), mountingTabThickness ]) 
            cableCutout($fn=180);
        translate([0,-.4,lensHeight-(mountingTabThickness/2)]) 
                rotate([90,0,0]) 
                    ledRing();
        translate([0,-0.05,lensHeight-(mountingTabThickness/2)]) 
                rotate([90,0,0]) 
                    ledUnderRing();
        v = lensHeight-(RPcam2_height/2) ;
        w = RPcam2_width + RPcam2_cutoutTolerance;
        wTweak = 2;
        vTweak = 0.5;
        translate([(w/2)-wTweak,0,v+vTweak])rotate([90,0,0]) ledWiresCutout();
        translate([-(w/2)+wTweak,0,v+vTweak])rotate([90,0,0]) ledWiresCutout();
    }
}
echo("C",RPcam2_height);
TombstoneCameraMount($fn=72);