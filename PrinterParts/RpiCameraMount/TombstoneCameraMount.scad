use <../../lib/tombstones.scad>;
include <../../lib/RPcam2_vars.scad>;
use <../../lib/RPcam2.scad>;

echo("Z", RPcam2_height);

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
            cyDiam = 200,
            cyThickness = 4,
            cyWidth = 20, // 16mm for cable + 4mm tolerance
    ) {
        fx = 0;
        fy = 0.5;
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
            #cableCutout($fn=180);
            //translate([ 0, -coverThickness, v/2 ])
            //    cube([w-(2*coverThickness),thickness,v*1.1],center=true);
            //translate([ 0, 0, 0 ])
            //    cube([w-(2*coverThickness),thickness*1.1,2],center=true);
        }
        
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
        }
        cutoutYfudgeFactor = 5.5;  // fixme?
        translate([0,cutoutYfudgeFactor,lensHeight]) rpiCamCutout();
    }
}
echo("C",RPcam2_height);
TombstoneCameraMount($fn=72);