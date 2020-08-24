//
//
//  An extended lamp shade for:
//
//  "Sophie 1-Light Plug-in or Hardwire Wall Sconce, Chrome Gooseneck, 
//  Matte Rose, 6ft Clear Cord", Globe Electric 13064
//  Amazon ASIN B07JH4P8SY
//



Lamp_Lower_Dia = 130;
Lamp_Upper_Dia = 124;
Shade_Thickness = 2;
Lip_Thickness = 2;
Lip_Width = 8;
Height_Above = 20;

$fn = 90;

difference() {
    cylinder(d1=Lamp_Lower_Dia, d2=Lamp_Upper_Dia, h=Height_Above);
    translate([0,0,Lip_Thickness]) cylinder(d1=Lamp_Lower_Dia - (2*Shade_Thickness),
        d2=Lamp_Upper_Dia - (2*Shade_Thickness), h=Height_Above);
    cylinder(
        d1=Lamp_Lower_Dia - (2*Lip_Width),
        d2=Lamp_Lower_Dia - (2*Lip_Width), h=Height_Above, center=true);
    for (r=[0:45:360]) {
        rotate([0,0,r]) translate([64,0,Lip_Thickness+10]) cube([30,40,20], center=true);
    }
}
