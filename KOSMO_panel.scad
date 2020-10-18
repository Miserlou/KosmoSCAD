//  KOSMOSCAD
// v2 by @Miserlou: https://github.com/Miserlou/KosmoSCAD
// v1 by @tomarus: https://github.com/tomarus/prototype

include <chamfer_extrude.scad>; 

/* Edit Me! */
width_cm = 7.5;

panelName = "U T L T";
panelNameFont = "Gill Sans";
panelNameSize = 10;
panelNameLeftOffset = 0;

/* Constants */
width_mm = width_cm*10;
panelThickness = 2.0;
textHeight = panelThickness + 1.5;
panelHp=20;
holeCount=4;
holeWidth = 4.0; //If you want wider holes for easier mounting. Otherwise set to any number lower than mountHoleDiameter. Can be passed in as parameter to kosmoPanel()

fiveUHeight = 175.00; // practical height
panelOuterHeight = 200.0; //metric 5U height
panelInnerHeight = 200; //rail clearance = ~11.675mm, top and bottom
railHeight = (fiveUHeight-panelOuterHeight)/2;
mountSurfaceHeight = (panelOuterHeight-panelInnerHeight-railHeight*2)/2;

hp=width_cm/2;
mountHoleDiameter = 4.0;
mountHoleRad =mountHoleDiameter/2;
hwCubeWidth = holeWidth-mountHoleDiameter;

offsetToMountHoleCenterY=mountSurfaceHeight/2;
offsetToMountHoleCenterX = hp - hwCubeWidth/2; // 1 hp from side to center of hole

quarterInchJackHole = 10;
eighthInchJackHole = 6.10;
switchHole = 7.10;
potHole = 7.10;
trimHole = 2.5;

railBuffer = 2;
railWidth = 3.5;

pcbHole = 3;

/* Functions */
module kosmoPanel(panelHp,  mountHoles=2, hw = holeWidth, ignoreMountHoles=false)
{
    //mountHoles ought to be even. Odd values are -=1
    difference(){
        cube([hp*panelHp, panelOuterHeight, panelThickness]);
        if(!ignoreMountHoles){
            kosmoMountHoles(panelHp, mountHoles, holeWidth);
        }
       
       /*
        Holes go here!
       */
       
       // 3:1 Passive Multiplier 
       punchHole(20, 175, quarterInchJackHole); 
       punchHole(55, 175, quarterInchJackHole);
       punchHole(20, 160, quarterInchJackHole); 
       punchHole(55, 160, quarterInchJackHole);
        
       // Passive Attenuators
       punchHole(20, 130, quarterInchJackHole);
       punchHole(37.5, 130, potHole);
       punchHole(55, 130, quarterInchJackHole);

       punchHole(20, 110, quarterInchJackHole);
       punchHole(37.5, 110, potHole);
       punchHole(55, 110, quarterInchJackHole);
       
       // Switch
       punchHole(55, 80, quarterInchJackHole);
       punchHole(55, 60, quarterInchJackHole);
       punchHole(37.5, 70, switchHole);
       punchHole(20, 70, quarterInchJackHole);
       
       // Eigth to Quarter
       punchHole(55, 35, eighthInchJackHole);
       punchHole(20, 35, quarterInchJackHole);
       punchHole(55, 20, eighthInchJackHole);
       punchHole(20, 20, quarterInchJackHole);
       
        // Embossed Text
        embossText(panelName);

    }
    
    // Vertical Rails
    verticalRail(railBuffer, 25);
    verticalRail(width_mm - railBuffer - railWidth, 25);
    
    // PCB Holders
    pcbHolder(railBuffer + railWidth, 22);
    pcbHolder(railBuffer + railWidth, 118);
    
    // Horizontal Rails
    horizontalRail(45);
    horizontalRail(90);
    horizontalRail(140);
    
    // Raised Text
    // Only use this if you want to print the panel upside down.
    // raiseText(panelName);
    
    }

module verticalRail(vertRailX, vertRailY){
    
    union(){
        translate([vertRailX, vertRailY, panelThickness]){
            cube([railWidth, panelOuterHeight - 50, panelThickness * 2]);
        }
    }
    
   l = railWidth;
   w = railWidth * 2;
   h = 5;
   translate([vertRailX, vertRailY - w, 1]){
       polyhedron(
               points=[[0,0,0], [l,0,0], [l,w,0], [0,w,0], [0,w,h], [l,w,h]],
               faces=[[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]
               );
   }
   
   translate([vertRailX, vertRailY + panelOuterHeight - 50, 0]){
       translate([l, w, 1]){
           rotate([0, 0, 180]){
             polyhedron(
                   points=[[0,0,0], [l,0,0], [l,w,0], [0,w,0], [0,w,h], [l,w,h]],
                   faces=[[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]
             );
           }
       }
   }

}

module horizontalRail(hozRailY){
    union(){
        translate([railBuffer + railWidth, hozRailY, panelThickness]){
            cube([width_cm * 10 - railWidth - railBuffer * 2, railWidth, panelThickness*2   ]);
        }
    }
}

module pcbHolder(x, y){
   l = railWidth;
   w = 30;
   h = 20;
    
    union(){
       difference(){
           union(){
               translate([x, y, 0]){
                   polyhedron(
                           points=[[0,0,0], [l,0,0], [l,w,0], [0,w,0], [0,w,h], [l,w,h]],
                           faces=[[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]
                           );
                }
               translate([x, y+60, 0]){
                   mirror([0,1,0]){
                       polyhedron(
                               points=[[0,0,0], [l,0,0], [l,w,0], [0,w,0], [0,w,h], [l,w,h]],
                               faces=[[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]
                               );
                   }
               }
           }
    translate([x-2, y+w, 10]){
       rotate([45, 0, 0]){
            cube([pcbHole*3, pcbHole, pcbHole]);
       }
   }
        }  
    }
}

module embossText(tstring){
    union(){
        translate([panelHp*3 + panelNameLeftOffset, fiveUHeight + 11, -.5]){
            mirror(v=[1,0,0]){
                chamfer_extrude(height=panelThickness, angle=55, $fn=0){
                    text(tstring, font=panelNameFont, size=panelNameSize, halign="left");
                    }
                }
            }
        }
}

module raiseText(tstring){
     translate([panelHp/2 + 5, fiveUHeight + 11, panelThickness]){
        union(){
            chamfer_extrude(height=panelThickness, angle=55, $fn=0){
                text(tstring, font=panelNameFont, size=panelNameSize, halign="left");
            }
        }
    }
}

module kosmoMountHoles(php, holes, hw)
{
    holes = holes-holes%2; //mountHoles ought to be even for the sake of code complexity. Odd values are -=1
    kosmoMountHolesTopRow(php, hw, holes/2);
    kosmoMountHolesBottomRow(php, hw, holes/2);
}

module kosmoMountHolesTopRow(php, hw, holes)
{
    
    //topleft
    translate([offsetToMountHoleCenterX,panelOuterHeight-offsetToMountHoleCenterY,0]){
        kosmoMountHole(hw);
    }
    if(holes>1){
        translate([(hp*php)-hwCubeWidth-hp,panelOuterHeight-offsetToMountHoleCenterY,0]){
            kosmoMountHole(hw);
        }
    }
    if(holes>2){
        holeDivs = php*hp/(holes-1);
        for (i =[1:holes-2]){
            translate([holeDivs*i,panelOuterHeight-offsetToMountHoleCenterY,0]){
                kosmoMountHole(hw);
            }
        }
    }
}

module kosmoMountHolesBottomRow(php, hw, holes)
{
    
    //bottomRight
    translate([(hp*php)-hwCubeWidth-hp,offsetToMountHoleCenterY,0]){
        kosmoMountHole(hw);
    }
 
    if(holes>1){
        translate([offsetToMountHoleCenterX,offsetToMountHoleCenterY,0]){
            kosmoMountHole(hw);
        }
    }

    if(holes>2){
        holeDivs = php*hp/(holes-1);
        for (i =[1:holes-2]){
            translate([holeDivs*i,offsetToMountHoleCenterY,0]){
                kosmoMountHole(hw);
            }
        }
    }
}

module kosmoMountHole(hw)
{
    
    mountHoleDepth = panelThickness+2; //because diffs need to be larger than the object they are being diffed from for ideal BSP operations
    
    if(hwCubeWidth<0){
        hwCubeWidth=0;
    }
    translate([0,0,-1]){
        union(){
            cylinder(r=mountHoleRad, h=mountHoleDepth, $fn=20);
            translate([0, -mountHoleRad, 0]){
                cube([hwCubeWidth, mountHoleDiameter, mountHoleDepth]);
            }
            translate([hwCubeWidth, 0, 0]){
                cylinder(r=mountHoleRad, h=mountHoleDepth, $fn=20);
            }
        }
    }
}

module punchHole(x, y, holeSize){
    
    holeDepth = panelThickness+2;

    translate([x, y, 0]){
        translate([0,0,-1]){
            union(){
                cylinder(r=holeSize/2, h=holeDepth, $fn=20);
                //translate([0, -holeSize/2, 0]){
                //    cube([hwCubeWidth, holeSize, holeDepth]);
                //}
                translate([hwCubeWidth, 0, 0]){
                    cylinder(r=holeSize/2, h=holeDepth, $fn=20);
                }
            }
        }
    }
}

/* Main */
kosmoPanel(panelHp, holeCount, holeWidth);
