// KOSMOSCAD
// v2 by Rich Jones: https://github.com/Miserlou/KosmoSCAD
// v1 by @tomarus: https://github.com/tomarus/prototype

/* Constants */
panelThickness = 2.0;
panelHp=20;
holeCount=4;
holeWidth = 6.08; //If you want wider holes for easier mounting. Otherwise set to any number lower than mountHoleDiameter. Can be passed in as parameter to kosmoPanel()

fiveUHeight = 175.00; // practical height
panelOuterHeight = 200.0; //metric 5U height
panelInnerHeight = 200; //rail clearance = ~11.675mm, top and bottom
railHeight = (fiveUHeight-panelOuterHeight)/2;
mountSurfaceHeight = (panelOuterHeight-panelInnerHeight-railHeight*2)/2;

hp=5.0;
mountHoleDiameter = 6.2;
mountHoleRad =mountHoleDiameter/2;
hwCubeWidth = holeWidth-mountHoleDiameter;

offsetToMountHoleCenterY=mountSurfaceHeight/2;
offsetToMountHoleCenterX = hp - hwCubeWidth/2; // 1 hp from side to center of hole

/* Functions */
module kosmoPanel(panelHp,  mountHoles=2, hw = holeWidth, ignoreMountHoles=false)
{
    //mountHoles ought to be even. Odd values are -=1
    difference(){
        cube([hp*panelHp,panelOuterHeight,panelThickness]);
        if(!ignoreMountHoles){
            kosmoMountHoles(panelHp, mountHoles, holeWidth);
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
            translate([0,-mountHoleRad,0]){
                cube([hwCubeWidth, mountHoleDiameter, mountHoleDepth]);
            }
            translate([hwCubeWidth,0,0]){
                cylinder(r=mountHoleRad, h=mountHoleDepth, $fn=20);
            }
        }
    }
}

/* Main */
kosmoPanel(panelHp, holeCount,holeWidth);
