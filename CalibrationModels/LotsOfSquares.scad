xsize = 250;
ysize = 250;
xstep = 50;
ystep = 50;
xcube = 40;
ycube = 40;
zcube = 1;
dateStr = "2020-07-06";
textSize = 5;
textZ = zcube * 1.5;

for (y=[-ysize/2:ystep:ysize/2]) {
    for (x=[-xsize/2:xstep:xsize/2]) {
        s = str(x, ",", y);
        translate([x,y,0]) {
            union() {
                cube([xcube,ycube,zcube],center=true);
                
                translate([0,-textSize,0]) linear_extrude(textZ) {
                    text(s, size=textSize, halign="center");
                }
                translate([0, textSize,0]) linear_extrude(textZ) {
                    text(dateStr, size=textSize, halign="center");
                }
            }
        }
    }
}
