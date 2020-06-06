use <../../lib/tombstones.scad>
use <../../lib/RPCam2.scad>

module TombstoneCameraMount(
    width=43, 
    height=82,
    thickness = 10,
    inset = 2,
    extrusionSize=20,
    mountingTabThickness = 4,      // should be >= mountingHoleTaperHeight!
    mountingHoleDiameter = 3.6,
    mountingHoleTaperDiameter = 6,
    mountingHoleTaperHeight = 2,
    lensHeight = 50
) {
    
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
    
    difference() {
        union() {
            translate([0,0,mountingTabThickness]) 
                roundedTombstone(
                    width=width, 
                    height=height-mountingTabThickness,
                    thickness=thickness,
                    inset=inset);
            translate([0,0,mountingTabThickness/2]) mountingTabs();
        }
        translate([0,2,lensHeight]) rpiCamCutout();
    }
}

TombstoneCameraMount($fn=72);