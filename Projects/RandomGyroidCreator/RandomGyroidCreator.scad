//
//  Random Gyroid Creator
//
//  https://animalcrossing.fandom.com/wiki/Gyroid_(furniture)
//


// seed for randomizer
seed_value = 1234; // [0:1000]

// rndIndex, min, max
ftDiameter   = [ 0, 10, 20 ];
// rndIndex, min, max
ftHeight     = [ 1, 10, 30 ];




module random_gyroid(seed_value) {

    rnd = rands(min_value=0, max_value=1, value_count=100, seed_value=seed_value);
    
    // indexes into the feature structure
    rndIndex = 0;  // which random number to use
    minIndex = 1;  // min value
    maxIndex = 2;  // max value

    function feature(ft) = ft[minIndex] + (rnd[rndIndex]*(ft[maxIndex]-ft[minIndex]));
        
    gy_diam = feature(ftDiameter);
    gy_height = feature(ftHeight);
    
    translate([0,0,gy_height/2]) cylinder(h=gy_height, d=gy_diam, center=true);
}

translate([-40,-40,0]) random_gyroid(seed_value);
translate([-40, 40,0]) random_gyroid(seed_value+1);
translate([ 40,-40,0]) random_gyroid(seed_value+2);
translate([ 40, 40,0]) random_gyroid(seed_value+3);
