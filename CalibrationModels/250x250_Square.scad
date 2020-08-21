h = 1;
n = 2;
difference() {
    cube([250,250,h],center=true);
    cube([250-n,250-n,h*1.1],center=true);
}