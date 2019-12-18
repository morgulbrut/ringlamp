LedRingDiameter = 157;  // [20:200]
LedRingWidth = 20;      // [5:20]
LedRingHeight = 15;     // [10:20]
WallThickness = 2;      // [1:4]
CompartementWidth = 60; // [20:80]
CompartementHeight = 40;// [20:80]
CompartementLength = 80;// [20:120]
PotDistance = 20;       // [20:60]
PotCount = 3;           // [2:4]
PlexiThickness = 2.0;   // [1.5, 2.0, 2.5, 3, 3.5, 4.0]
PlexiWidth = 10;         // [3:10]
ShowPart = 5;           // [0:Cover, 1:Cover2D, 2:Body, 3:BodyMounted, 4:All, 5:AllMounted]

inner1 = LedRingDiameter/2-WallThickness-LedRingWidth/2;
outer1 = LedRingDiameter/2+WallThickness+LedRingWidth/2;
inner2 = LedRingDiameter/2-LedRingWidth/2;
outer2 = LedRingDiameter/2+LedRingWidth/2;

compDist = sqrt(outer1*outer1-(CompartementWidth/2)*(CompartementWidth/2));

/* makes a ring
 o is the outer diameter
 i is the inner diameter
 h is the height
*/
module ring(o,i,h){
    difference(){
        cylinder($fn=360,h = h, r = o, center = false);
        translate([0,0,-.5]){
            cylinder($fn=360,h = h+1, r = i, center = false);
        }
    }
}


/* makes a cross out f two cubes, o x PlexiWidth x PlexiThickness
  for a plexi connections
  l is the size 
*/
module plexiCons(l){
    translate([0,0,(PlexiThickness+1)/2]){
        union(){
            cube([l+PlexiWidth,PlexiWidth,PlexiThickness+1],true);
            cube([PlexiWidth,l+PlexiWidth,PlexiThickness+1],true);
        }
    }
}


/* makes a bunch of holes for pots */
module potentiometers(){
    radius =9.3/2;
    rotate([90,0,0]){
        for (a = [0 : PotCount - 1]) {
            translate([0,a*PotDistance,0]){
                cylinder($fn=360,h = CompartementWidth, r = radius , center = false);
            }
        }
    } 
}


/* makes the cover to lasercut */
module cover(){
    color("white"){
        union(){
            intersection(){
                union(){
                    ring(outer2,inner2,PlexiThickness);
                    plexiCons(outer2*2);
                }
                ring(outer1,inner1,PlexiThickness);
            }
            translate([LedRingDiameter/2+CompartementHeight/2,0,PlexiThickness/2]){
                intersection(){
                    union(){
                        cube([CompartementHeight-4*WallThickness,CompartementWidth-2*WallThickness,PlexiThickness],true);
                        translate([0,0,-PlexiThickness/2]){
                            plexiCons(outer2*2);
                        }
                    }
                   cube([CompartementHeight,CompartementWidth,PlexiThickness],true); 
                }
            }
        }
    }
}


/* makes the compartement for the controller to 3d print */
module controllerCompartement(){
    color("red"){
        translate([0,0,CompartementLength/2]){
            difference(){
                // outer cube
                cube([CompartementHeight,CompartementWidth,CompartementLength],true);
                translate([0,0,WallThickness]){
                    // make a shelF
                    cube([CompartementHeight-4*WallThickness,CompartementWidth-2*WallThickness,CompartementLength],true);   
                }
                translate([-(CompartementHeight/2+2*WallThickness),0,CompartementLength/2-LedRingHeight/2]){
                    union(){
                        cube([LedRingHeight,CompartementWidth+1,LedRingHeight+1],true); 
                        cube([CompartementHeight,CompartementWidth-2*WallThickness,LedRingHeight+1],true);
                    }
                }
                // holes for pots
                translate([0,0,-CompartementLength/2+PotDistance]){
                    potentiometers();
                }
                // notches for the plexi 
                translate([0,0,CompartementLength/2-PlexiThickness]){
                    plexiCons(90);
                }
                // mounting hole
                rotate([0,90,0]){
                    cylinder($fn=360,h = CompartementWidth, r = 4 , center = false);
                }
                // USB port
                translate([-CompartementHeight/2+3*WallThickness,0,-CompartementLength/2]){
                    cube([3,5,10],true);
                }
            }  
        }
    }
}


/* makes the ring for the LEDs to 3d print*/
module ledRing(){
    color("blue"){
        cutout = CompartementWidth-2*WallThickness;
        difference(){
            ring(outer1,inner1,LedRingHeight); 
            translate([0,0,WallThickness]){
                ring(outer2,inner2,LedRingHeight); 
            }
            translate([outer2-10,-cutout/2,WallThickness]){
                cube([20,cutout,LedRingHeight],false);   
            }
            translate([0,0,LedRingHeight-PlexiThickness]){
                plexiCons(outer1*2);
            }
        }
    }
}

/* connects a ring and a controller compartement to visualise the printed parts mounted */
module body(){
    translate([compDist+CompartementHeight/2,0,-(CompartementLength-LedRingHeight)]){
        controllerCompartement() ;
    }
    ledRing();
}



module ledRingCPL(){
    body();
    translate([0,0,LedRingHeight-PlexiThickness]){
        cover();
    }
}

if (ShowPart==0) cover();

if (ShowPart==1){
    render(){
        projection(){
            cover();
        }
    }
}

if (ShowPart==2){
    controllerCompartement();
    ledRing();
}

if (ShowPart==3) body();

if (ShowPart==4){
    controllerCompartement();
    ledRing();
    translate([-LedRingDiameter-100,0,0]){
        cover();
    }
}

if (ShowPart==5) ledRingCPL();