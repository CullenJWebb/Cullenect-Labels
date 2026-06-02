/* [General Settings] */
//I want to generate...
Select_Output=0; // [0:Label, 01:Label Spacer, 10:Socket Test Fit, 11:Socket Negative Volume, 20:Vertical Socket Test Fit, 21:Vertical Socket Negative]
//model = "" // ["Cullenect label","Socket test fit","Socket Negative Volume"]
// Width in gridfinity units
label_width = 1; // .1
// Generate V1 Latches for 1U bins?
backward_compatible = true;
// Flush is 3MF only
label_surface = 00; // [00:Emboss, 01:Deboss, 02:Flush]
// Text / Icon Color.
Text_Color = "#333333";

/* [Label Text 1] */

// Label Text
Text1 = "Cullenect";
// Text Alignment
Text1_Align = "left"; // ["left","center","right"]
// Font Size
Text1_Font_Size = 5;  // .1
// Font Family
Text1_Font = "Open Sans"; // [Open Sans, Open Sans Condensed, Ubuntu, Montserrat]

// Font Style
Text1_Font_Style = "Regular"; // [Regular,Black,Bold,ExtraBol,ExtraLight,Light,Medium,SemiBold,Thin,Italic,Black Italic,Bold Italic,ExtraBold Italic,ExtraLight Italic,Light Italic,Medium Italic,SemiBold Italic,Thin Italic]
// Adjust X and Y Position
Text1_XY = [0,0]; // .1
/* [Label Text 2] */

// Label Text
Text2 = "";
// Text Alignment
Text2_Align = "right"; // ["left","center","right"]
// Font Size
Text2_Font_Size = 6;  // .1
// Font Family
Text2_Font = "Open Sans"; // [Open Sans, Open Sans Condensed, Ubuntu, Montserrat]

// Font Style
Text2_Font_Style = "Regular"; // [Regular,Black,Bold,ExtraBol,ExtraLight,Light,Medium,SemiBold,Thin,Italic,Black Italic,Bold Italic,ExtraBold Italic,ExtraLight Italic,Light Italic,Medium Italic,SemiBold Italic,Thin Italic]
// Adjust X and Y Position
Text2_XY = [0,0]; // .1

/* [Fastener Icon] */
Show_Fastener = false;
Fastener_Head="socket"; // [none:None, socket:Socket, countersunk:Countersunk, roundh:Round, pan:Pan]
Fastener_Shaft="machine"; // [none:None, machine:Machine, tapping:Tapping]
Fastener_Threads="full"; // [none:None, full:Full, partial:Partial]
Fastener_Driver="phillips"; // [none:None, slot:Slot, phillips:Phillips, phillips_slot:Phillips Slot, phillips_square:Phillips Square, torx:Torx/Star, hex:Hex, square:Robertson/Square, triangle:Triangle]
// Toggle flanged head
Fastener_Head_Flange=false;
// Toggle securty nub in center of driver
Fastener_Driver_Security=false;

/* [Hardware Icon] */
Select_Hardware="none"; // [none:None, washer:Washer, washer_locking:Locking Washer, threaded_insert:Threaded Insert, nut:Nut, nut_square:Square Nut, nut_nylon:Nylon Lock Nut, tnut_1:T-Nut Side, tnut_2:T-Nut Top, magnet:Magnet, crimp_ring_open:Crimp Ring - Open, crimp_ring_closed:Crimp Ring - Closed, crimp_fork_open:Crimp Fork - Open, crimp_fork_closed:Crimp Fork - Closed, crimp_spade_open:Crimp Spade - Open, crimp_spade_closed:Crimp Spade - Closed, crimp_receptacle_open:Crimp Receptacle - Open, crimp_receptacle_closed:Crimp Receptacle - Closed, crimp_butt_splice:Crimp Butt Splice]

/* [Advanced] */

//Ajust fitment for X and Y dimensions
offset_xy = [0,0]; // .1

// Use gridfinity U
gridfinity = true;

// Width of label in mm
labelXmm = 36.0;  // .1

// Height of label in mm
labelYmm = 11.0;  // .1

// Thickness of label in mm
labelZmm = 1.2;  // .1

layer = 0.2; // Layer height of text and icons (careful)

// Increase or decrease resolution of certain details
$fs = 0.01;  // .01
// Increase or decrease resolution of certain details
$fa = 1;

/* [Hidden] */
gridfinityX = 42; // Grid size for gridfinity units.
labelX = (gridfinity) ? ((label_width * gridfinityX) - 6) + offset_xy.x : labelXmm;
labelY = (gridfinity) ? 11 + offset_xy.y : labelYmm;
labelZ = (gridfinity) ? 1.2 : labelZmm;
latchX = 0.2; // Width of socket on label walls
latchZ = 0.6; // Z-height of wall socket
fudge = 0.0001; // Fix render for exact booleans


// Tool for rounded cubes
 module RoundedCube(size, radius) {
	offsetfix = radius * 2;
    width = size[0] - offsetfix;
    height = size[1] - offsetfix;
    depth = size[2];
	
    translate([radius, radius, 0]) linear_extrude(height = depth) offset(r = radius) square([width, height]);
}

// V1 Label with new wall sockets
// Will only generate V1 label XY with V2 label Z
module cullenect_base_v1(offset_xy = offset_xy) {

	// Variables
	labelX_v1 = 36 + offset_xy.x;
	labelY_v1 = 11 + offset_xy.y;
	$midX1 = 4.695 + (offset_xy.x / 2);
	$midX2 = 10.18;
	$midlatchX = 1.95;
	$bottomX1 = 5.395 + (offset_xy.x / 2);
	$bottomX2 = 11.18;
	$bottomlatchX = 0.95;
	
	// Base below socket
	// Base #1
		color("Silver")
			RoundedCube([$bottomX1, labelY_v1, 0.2], 0.5);
	
	// Base #2
	translate([$bottomX1 + $bottomlatchX,0,0])
		color("Silver")
			RoundedCube([$bottomX2, labelY_v1, 0.2], 0.5);
	// Base #3
	translate([$bottomX1 + $bottomlatchX + $bottomX2 + $bottomlatchX,0,0])
		color("Silver")
			RoundedCube([$bottomX2, labelY_v1, 0.2], 0.5);
	// Base #4
	translate([$bottomX1 + $bottomlatchX + $bottomX2 + $bottomlatchX + $bottomlatchX + $bottomX2,0,0])
		color("Silver")
			RoundedCube([$bottomX1, labelY_v1, 0.2], 0.5);

	// Middle along socket
	// Middle #1
	translate([latchX,latchX,0.2])
		color("Gray")
			RoundedCube([$midX1, labelY_v1 - (latchX * 2), 0.6], 0.5);
	// Middle #2
	translate([latchX + $midX1 + $midlatchX,latchX,0.2])
		color("Gray")
			RoundedCube([$midX2, labelY_v1 - (latchX * 2), 0.6], 0.5);
	// Middle #3
	translate([latchX + $midX1 + $midlatchX + $midX2 + $midlatchX,latchX,0.2])
		color("Gray")
			RoundedCube([$midX2, labelY_v1 - (latchX * 2), 0.6], 0.5);
	// Middle #4
	translate([latchX + $midX1 + $midlatchX + $midX2 + $midlatchX + $midX2 + $midlatchX,latchX,0.2])
		color("Gray")
			RoundedCube([$midX1, labelY_v1 - (latchX * 2), 0.6], 0.5);
	
	// Top above socket
	translate([0,0,0.8])
		color("Silver")
			RoundedCube([labelX_v1, labelY_v1, 0.4], 0.5);
}

// V2 Label without backward compatibility
module cullenect_base_v2(
            offset_xy = offset_xy,
            labelX = labelX,
            labelY = labelY,
            labelZ = labelZ,
            latchX = latchX,
        ){
    
	// Label base below socket
	color("Silver")
	RoundedCube([labelX, labelY, 0.2], 0.5);
	
	// Label middle within socket
	translate([latchX,latchX,0])
	color("Gray")
	RoundedCube([labelX - (latchX * 2), labelY - (latchX * 2), labelZ - 0.2], 0.5);
	
	// Label top above socket
	translate([0,0,0.2 + latchZ])
	color("Silver")
	RoundedCube([labelX, labelY, (labelZ - 0.2) - latchZ], 0.5);
}

// Module to generate the correct label type
module cullenect_base() {
	if (backward_compatible && gridfinity && (label_width == 1)){
		cullenect_base_v1();
	} else {
		cullenect_base_v2();
	}
}

// Calculate Text1 Position and font
Text1_posX = (Text1_Align == "left") ? 0 + Text1_XY.x : 
            (Text1_Align == "center") ? (offset_xy.x + labelX / 2) + Text1_XY.x : 
            (Text1_Align == "right") ? labelX + Text1_XY.x + offset_xy.x : 0; // Fallback to 0
Text1_posY = (labelY / 2) + Text1_XY.y;
Text1_posZ = labelZ;
Text1_pos = [Text1_posX, Text1_posY, Text1_posZ];

// Calculate Text2 Position and font
Text2_posX = (Text2_Align == "left") ? 0 + Text2_XY.x : 
            (Text2_Align == "center") ? (labelX / 2) + Text2_XY.x : 
            (Text2_Align == "right") ? labelX + Text2_XY.x : 0; // Fallback to 0
Text2_posY = (labelY / 2) + Text2_XY.y;
Text2_posZ = labelZ;
Text2_pos = [Text2_posX, Text2_posY, Text2_posZ];

// Generate Label Text #1
module label_text1(
            Text1 = Text1,
            Text1_Font = Text1_Font,
            Text1_Font_Style = Text1_Font_Style,
            Text1_Font_Size = Text1_Font_Size,
            Text1_Align = Text1_Align,
            Text1Pos = Text1_pos
        ) {
	translate(Text1Pos)
		linear_extrude(layer + fudge)
			text(Text1, Text1_Font_Size, font = str(Text1_Font, ":", Text1_Font_Style), halign = Text1_Align, valign = "center");
}

// Generate Label Text #2
module label_text2(
            Text2 = Text2,
            Text2_Font = Text2_Font,
            Text2_Font_Style = Text2_Font_Style,
            Text2_Font_Size = Text2_Font_Size,
            Text2_Align = Text2_Align,
            Text2Pos = Text2_pos
        ) {
	translate(Text2Pos)
		linear_extrude(layer + fudge)
			text(Text2, Text2_Font_Size, font = str(Text2_Font, ":", Text2_Font_Style), halign = Text2_Align, valign = "center");
}

// Socket and Socket Negative Variables
socket_offset = 0.3;
socket_walls = 2;
socketX = labelX + socket_offset;
socketY = labelY + socket_offset;
ribZ = 0.4;
// Generate socket
module cullenect_socket(
            socket_offset = socket_offset,
            socket_walls = socket_walls,
            socketX = socketX,
            socketY = socketY,
            ribZ = ribZ,
        ){
	union(){
		difference(){
			translate([-socket_walls,-socket_walls,-1])
                color("Silver")
                    RoundedCube([labelX + (socket_walls * 2), socketY + (socket_walls * 2), labelZ + 1], 0.2);
			
			color("Gray")
				RoundedCube([socketX, socketY, labelZ + 1], 0.5);
		}
		translate([0,0,0.2])
            color("Silver")
                cube([socketX, latchX, ribZ]);
		translate([0, socketY - latchX,0.2])
            color("Silver")
                cube([socketX, latchX, ribZ]);
	}
}

// Generate negative volume of socket
module cullenect_socket_negative(){

	difference(){
        color("Gray")
			RoundedCube([socketX, socketY, labelZ], 0.5);
        cullenect_socket();   
    }
        
}

// Vertical socket variables
vsocketOffset = 0.2; // Extra space for latch
vsocketX = labelX + vsocketOffset;
vsocketY = labelZ - latchZ - vsocketOffset; // define starting pos and depth
vsocketZ = socketY + 2; // Vertical height with 45 degree ceiling
vsocketDepth = (vsocketY * 2) + latchZ; // Total depth of vsocket


// Generate vertical socket
// Unlike the h-socket and label this starts with the negative volume due to easier rounded edges
// Rounded edges are needed for the vertical printing of the ribbing
module cullenect_vertical_socket_negative(
            vsocketOffset = vsocketOffset,
            vsocketX = vsocketX,
            vsocketY = vsocketY,
            vsocketZ = vsocketZ,
            vsocketDepth = vsocketDepth,
        ) {
	difference(){
		// Create base 
		union(){
			cube([vsocketX, (vsocketY / 2), vsocketZ]);// front of socket, no rounding
			RoundedCube([vsocketX, vsocketY + 0.001, vsocketZ], 0.1);// front of socket, rounded inside around rib
			translate([0,vsocketY,0])
				cube([vsocketX,latchZ,vsocketZ]); // Middle of socket, to be cut away later by rounded cube for rib
			translate([-vsocketOffset,vsocketY + latchZ,0])
				RoundedCube([vsocketX + (vsocketOffset * 2), vsocketY, vsocketZ], 0.1);
		}
		// Remove rounded ribs
		translate([-1,vsocketY,0])
			RoundedCube([latchX + 1, latchZ, vsocketZ], 0.1);
		translate([vsocketX - latchX,vsocketY,0])
			RoundedCube([latchX + 1, latchZ, vsocketZ], 0.1);
		// remove 45 degree top
		translate([-(latchX + 1),(vsocketY * 2) + latchZ,socketY])
            rotate([45,0,0])
                cube([2 + vsocketX + latchX * 2, latchX + 3, (vsocketY * 8)], false);
		
	}
    
}

// Generate vsocket test fitment
module cullenect_vertical_socket() {
    difference(){
        translate([-(socket_walls+vsocketOffset),0,-socket_walls])
            cube([labelX + (vsocketOffset * 2) +(socket_walls * 2),vsocketDepth + 1,vsocketZ + (socket_walls * 1.5)]);
        cullenect_vertical_socket_negative();
    }
}

// Fastener icon variables
driverX = 6; // Size of driver icon
driverWidth = 1; // Width of "most" driver shapes inside icon
driverLength = 5.333; // Length of most driver shapes inside icon
headY = driverX * 1.666666666666667; // Size of fastener heads
shaftX = headY * 0.856; // Length of fastener shaft
shaftY = headY/2;

// Generate Driver Icon
module cullenect_driver(
            driver="none",
            driverX = driverX,
            driverWidth = driverWidth,
            driverLength = driverLength,
            headY = headY,
            shaftX = shaftX,
            shaftY = shaftY,
        ) {
    
    // Blank
    module blank(){
        cylinder(h=layer, d=driverX, center=true, $fa=1);
    }
    
    // Slot
    module slot(driverLength=driverLength){
        cube([driverLength,driverWidth,layer], true);
    }
    
    // Phillips
    module phillips(){
        union(){
            slot();
            rotate([0,0,90])slot();
        }
    }
    
    // Phillips Slot
    module phillips_slot(){
        union(){
            slot();
            rotate([0,0,90])slot(driverLength=driverLength-2);
        }
    }
    
    // Phillips Square
    module phillips_square(){
        union(){
            slot();
            rotate([0,0,90])slot();
            rotate([0,0,45])cube([driverWidth*2.8,driverWidth*2.8,layer],true);
        }
    }
    
    // Torx
    module torx(){
        module torx_cyl() {cylinder(h=layer, d=driverWidth, center=true, $fa=1);};
        module torx_long(length=driverLength-driverWidth,cube=true){
            // Connecting cube
            if (cube==true){cube([length, driverWidth, layer], true);}
            // Rounded ends
            translate([(length) / 2,0,0])torx_cyl();
            // Rounded ends again but oposite side (copy/paste)
            rotate([0,0,180])translate([(length) / 2,0,0])torx_cyl();
        }
        
        // Torx: Bring everything together
        difference(){
            union(){
                torx_long();
                rotate([0,0,120])torx_long();
                rotate([0,0,60])torx_long();
                cylinder(h=layer, d=driverLength*0.69, center=true, $fa=1); // joining cylinder in the middle
            }
            rotate([0,0,30])torx_long(length=(driverLength-driverWidth)*0.92,cube=false);
            rotate([0,0,90])torx_long(length=(driverLength-driverWidth)*0.92,cube=false);
            rotate([0,0,-30])torx_long(length=(driverLength-driverWidth)*0.92,cube=false);
        } 
    }
    
    // Hex
    module hex(){
        cylinder(h=layer, d=driverX-1, $fn=6, center=true);
    }
    
    // Square
    module square(){
        rotate([0,0,45])
            cylinder(h=layer, d=driverX, $fn=4, center=true);
    }
    
    // Triangle
    module triangle(){
        rotate([0,0,-30])
            cylinder(h=layer, d=driverX, $fn=3, center=true);
    }
    
    // Security
    module security(){
        cylinder(h=layer, d=driverX/4, $fa=1, center=true);
    }
    
    // Output
    if (driver == "blank")blank();
    if (driver == "slot")slot();
    if (driver == "phillips")phillips();
    if (driver == "phillips_slot")phillips_slot();
    if (driver == "phillips_square")phillips_square();
    if (driver == "torx")torx();
    if (driver == "hex")hex();
    if (driver == "square")square();
    if (driver == "triangle")triangle();
    if (driver == "security")security();
}

// Generate Screw Head
module cullenect_head(
            head = "socket",
            flange = false,
        ){
    
    // Socket
    module socket(){
        cube([driverX,headY,layer], true);
    }
    
    // Countersunk
    module countersunk(){
        translate([0,0,-layer/2])
            linear_extrude(layer)
                polygon(points=[[-driverX/2,headY/4],[driverX/2,headY/2],[driverX/2,-headY/2],[-driverX/2,-headY/4]]);
    }
    
    // Round
    module roundh(){
        difference(){
            translate([-driverX/3,0,0])
                union(){
                    cylinder(h=layer, d=headY, $fa=1, center=true);
                    translate([-driverX/4,0,0])
                        cube([driverX/2,headY,layer], true);
                }
            translate([-driverX,0,0])
                cube([driverX,headY,layer], true);
        }
    }
    
    // Pan
    module pan(){
        union(){
            translate([-driverX/2,-headY/2,-layer/2])
                RoundedCube([driverX, headY, layer], 2.0);
            translate([-driverX/4,0,0])
                cube([driverX/2,headY,layer], true);
        }
    }
    
    // Flange
    flangeX = driverX / 4;
    module flange(){
        translate([-(driverX/2) + (flangeX/2),0,0])
        cube([flangeX,labelY,layer], true);
    }
    
    // Output
    if (head == "socket")socket();
    if (head == "countersunk")countersunk();
    if (head == "roundh")roundh();
    if (head == "pan")pan();
    if (flange == true && head != "countersunk")flange();
}

// Generate Fastener Shaft
module cullenect_shaft(shaft="machine",threads="full"){
    
    // Machine
    module machine(){
        translate([-(driverX/2 + shaftX/2),0,0])
            cube([shaftX,shaftY,layer], true);
    }
    
    // Tapping
    module tapping(){
        difference(){
            machine();
            translate([-(driverX/2 + shaftX),shaftY/2,0])
                rotate([0,0,45])
                    cube([shaftY*0.7,shaftY*0.7,layer], true);
            translate([-(driverX/2 + shaftX),-shaftY/2,0])
                rotate([0,0,45])
                    cube([shaftY*0.7,shaftY*0.7,layer], true);
        }
    }
    
    // Threads
    function get_thread_num() = 
        (threads == "full" && shaft == "machine") ? 6 :
        (threads == "partial" && shaft == "machine") ? 3 :
        (threads == "full" && shaft == "tapping") ? 4 :
        (threads == "partial" && shaft == "tapping") ? 2 :
        6;
    thread_num = get_thread_num();
    threadX = shaftY/5;
    thread_step = (threadX*1.41421);
    thread_pos_full = driverX/2 + thread_step/2;
    thread_pos_partial = driverX/2 + thread_step/2 + (thread_num * thread_step);
    thread_pos_x = (threads=="partial") ? thread_pos_partial : thread_pos_full;
    
    module threads(num=thread_num,pos=thread_pos_x){
        translate([-pos,0,0])
            for(i = [0:1:num-1]){
                translate([-(i*thread_step),shaftY/2,0])
                    rotate([0,0,45])
                        cube([threadX,threadX,layer], true);
                translate([-(i*thread_step),-shaftY/2,0])
                    rotate([0,0,45])
                        cube([threadX,threadX,layer], true);
            }
    }
    
    // Output
    if (shaft == "machine")machine();
    if (shaft == "tapping")tapping();
    if ((threads!="none" && shaft!="none"))threads();
    
}

// Hardware Variables
hardX = headY;
hardNegative = hardX * 0.6;

// Generate Hardware
module cullenect_hardware(hardware) {

    // Washer
    module washer(){
        difference(){
            cylinder(h=layer, d=hardX, center=true);
            cylinder(h=layer, d=hardNegative, center=true);
        }
    }
    
    // Locking Washer
    module washer_locking(){
        difference(){
            washer();
            translate([-hardX/5,hardX/3,0])
                rotate([0,0,45])
                    cube([hardX/5,hardX/2,layer], true);
        }
    }

    // Threaded Insert
    module threaded_insert(){
    
        stripeX = hardX*0.0849;
        stripeY = hardX*0.1376;
        stripeStep = stripeX + hardX*0.0776;
    
        module stripePoly(){
            linear_extrude(layer)
                polygon(points=[[0,0],[stripeX,0],[stripeX*2.5,-stripeY],[stripeX*1.5,-stripeY]]);
        }
    
        translate([-hardX/2,-hardX/2,-layer/2])
            difference(){
                union(){
                    RoundedCube([hardX, hardX/4, layer], 0.2); // Top of insert
                    translate([1,0,0])
                        cube([hardX-2, hardX, layer]);// Middle of insert
                    translate([0,hardX*0.75,0])
                        RoundedCube([hardX, hardX/4, layer], 0.2);// Bottom of insert
                }
                translate([-1,hardX/4,0])
                    RoundedCube([hardX/5 + 1, hardX/2, layer], 0.2);
                translate([hardX-hardX/5,hardX/4,0])
                    RoundedCube([hardX/5 + 1, hardX/2, layer], 0.2);
                translate([hardX*0.06,hardX*0.19,0])
                    for(i = [0:1:4]){
                        translate([(i*stripeStep),0,0])
                            stripePoly();
                        translate([(i*stripeStep),hardX*0.75,0])
                            stripePoly();
                    }
            }
    }
    
    // Nut
    module nut(){
        difference(){
            cylinder(h=layer, d=hardX, $fs=6, center=true);
            cylinder(h=layer, d=hardNegative, center=true);
        }
    }
    
    // Nut
    module nut_square(){
        difference(){
            cube([hardX,hardX,layer], true);
            cylinder(h=layer, d=hardNegative, center=true);
        }
    }
    
    // Nut Nylon Lock
    module nut_nylon(){
        difference(){
            cylinder(h=layer, d=hardX, $fs=6, center=true);
            cylinder(h=layer, d=hardNegative, center=true);
        }
        
        difference(){
            cylinder(h=layer, d=hardNegative*0.8, center=true);
            cylinder(h=layer, d=hardNegative*0.6, center=true);
        }
    }
    
    // T-Nut 1
    module tnut_1(){
    
        tnutY = hardX*0.66;
        tnutY2 = hardX*0.88;
        tnutX = hardX*1.456;
        tnutX2 = hardX*0.728;
        tnutCorner = hardX*0.4714;
        
        // TODO: Adjust size of tnuts and remove this right-aligned translate
        // They should all be the same size and not require special translates for each
        translate([-((tnutX-hardX)/2),0,0]){
            difference(){
                translate([-tnutX/2,-tnutY2/2,-layer/2]){
                    union(){
                        RoundedCube([tnutX, tnutY, layer], 0.5);
                        translate([(tnutX-tnutX2)/2,0,0])
                            RoundedCube([tnutX2, tnutY2, layer], 0.5);
                    }
                }
                translate([-tnutX/2,-tnutY2/2,0])
                    rotate([0,0,45])
                        cube([tnutCorner,tnutCorner,layer],true);
                translate([tnutX/2,-tnutY2/2,0])
                    rotate([0,0,45])
                        cube([tnutCorner,tnutCorner,layer],true);
            }
        }
    }
    
    
    // T-Nut 2
    module tnut_2(){
        tnutY = hardX*0.8;
        tnutX = hardX*1.456;
        slotX = hardX*0.08;
        slotY = hardX*0.4;
        slotStep = hardX*0.0518;
        
        // TODO: Adjust size of tnuts and remove this right-aligned translate
        // They should all be the same size and not require special translates for each
        translate([-((tnutX-hardX)/2),0,0]){
            difference(){
                translate([-tnutX/2,-tnutY/2,-layer/2]){
                    union(){
                        RoundedCube([tnutX, tnutY, layer], 3.33);
                        RoundedCube([tnutX/2, tnutY/2, layer], 0.5);
                        translate([tnutX/2,tnutY/2,0])
                            RoundedCube([tnutX/2, tnutY/2, layer], 0.5);
                    }
                }
                cylinder(h=layer, d=hardX/2, center=true);
                for(i = [0:1:2]){
                    translate([hardX/4+hardX*0.03945+((slotX+slotStep)*i),-slotY/2,-layer/2])
                        RoundedCube([slotX, slotY, layer], 0.25);
                    rotate([0,0,180])
                        translate([hardX/4+hardX*0.03945+((slotX+slotStep)*i),-slotY/2,-layer/2])
                            RoundedCube([slotX, slotY, layer], 0.25);
                }
            } 
        }
    }
    
    // Magnet
    module magnet(){
        difference(){
            union(){
                washer();
                translate([-hardX/4,0,0])
                    cube([hardX/2,hardX,layer], true);
            }
            translate([-hardX/4,0,0])
                    cube([hardX/2,hardNegative,layer], true);
            translate([-hardX/3,0,0])
                    cube([hardX*0.05,hardX,layer], true);
        }
    }
    
    // Crimp Fitting Variables
    crimpX = hardX*0.8;
    crimpNegative = hardNegative*0.8;
    
    // Crimp Shaft
    module crimp_barrel(barrel="closed",offset=0){
    
        crimpShaftX = crimpX + offset;
        crimpShaftY = crimpNegative;
        
        // Wings
        module barrel_open(){
            translate([(-crimpNegative/2) + offset,crimpShaftY/2,-layer/2])
            rotate([0,0,180]){
                union(){
                    cube([crimpShaftX,crimpShaftY,layer], center=false);
                    translate([crimpShaftX-(crimpShaftX*0.2),-crimpShaftY*0.2,0])
                        RoundedCube([crimpShaftX*0.2, crimpShaftY*1.4, layer], 0.25);
                    translate([crimpShaftX-(crimpShaftX*0.7),-crimpShaftY*0.2,0])
                        RoundedCube([crimpShaftX*0.4, crimpShaftY*1.4, layer], 0.25);
                }
            }
        }
        
        // Cylinder
        module barrel_closed(){
            translate([(-crimpNegative/2) + offset,crimpShaftY/2,-layer/2])
            rotate([0,0,180]){
                difference(){
                    union(){
                        cube([crimpShaftX,crimpShaftY,layer], center=false);
                        translate([crimpShaftX,crimpShaftY/2,layer/2]){
                            resize([crimpShaftY/2,0,0])
                                cylinder(h=layer, d=crimpShaftY*1.2, center=true);
                        }
                        translate([crimpNegative/4,crimpShaftY/2,layer/2]){
                            resize([crimpShaftY/2,0,0])
                                cylinder(h=layer, d=crimpShaftY*1.2, center=true);
                        }
                    }
                    translate([crimpShaftX,crimpShaftY/2,layer/2]){
                        resize([crimpShaftY/5,crimpShaftY*0.8,0])
                            cylinder(h=layer, d=crimpShaftY*1, center=true);
                    }
                }
            }
        }
            
        // Output
        if (barrel == "open")barrel_open();
        if (barrel == "closed")barrel_closed();
    }
    
    // Crimp Ring
    module crimp_ring(barrel="closed"){
        translate([hardX*0.1,0,0]){
            // Barrel
            crimp_barrel(barrel);
            // Ring
            difference(){
                cylinder(h=layer, d=crimpX, center=true);
                cylinder(h=layer, d=crimpNegative, center=true);
            }
        }
    }
    
    // Crimp Fork
    module crimp_fork(barrel="closed"){
        translate([hardX*0.13,0,0]){
            // Barrel
            crimp_barrel(barrel,offset=-crimpX*0.1);
            // Fork
            difference(){
                    union(){
                        cylinder(h=layer, d=crimpX, center=true);
                    translate([crimpX*0.25,0,0])
                        cube([crimpX*0.45,crimpX,layer], center=true);
                }
                cylinder(h=layer, d=crimpX/1.5, center=true);
                #translate([crimpX/4,0,0])
                    cube([crimpX/2,crimpX/1.5,layer], center=true);
            }
        }
    }
    
    // Crimp Spade
    module crimp_spade(barrel="closed"){
        translate([hardX*0.1,0,0]){
            // Barrel
            crimp_barrel(barrel,offset=-crimpX*0.1);
            // Spade
            translate([0,0,-layer/2])
            #difference(){
                linear_extrude(layer)
                    polygon(points=[
                        [-crimpX*0.4,crimpNegative/2],
                        [-crimpX/4,crimpX*0.4],
                        [crimpX/3,crimpX*0.4],
                        [crimpX/2,crimpX/4],
                        [crimpX/2,-crimpX/4],
                        [crimpX/3,-crimpX*0.4],
                        [-crimpX/4,-crimpX*0.4],
                        [-crimpX*0.4,-crimpNegative/2],
                    ]);
                    translate([crimpX*0.1,0,layer/2])
                        #cylinder(h=layer, d=crimpNegative/4, center=true);
            }
        }
    }
    
    // Crimp Receptacle
    module crimp_receptacle(barrel="closed"){
        translate([hardX*0.06,0,0]){
            // Barrel
            crimp_barrel(barrel,offset=-crimpX*0.1);
            // Receptacle
            difference(){
                union(){
                    cube([crimpX*0.85,crimpX*0.7,layer], center=true);
                    translate([-crimpX*0.45,crimpX*0.12,-layer/2])
                        RoundedCube([crimpX, crimpX*0.3, layer], 0.5);
                    translate([-crimpX*0.45,-crimpX*0.42,-layer/2])
                        RoundedCube([crimpX, crimpX*0.3, layer], 0.5);
                }
                cube([crimpX*0.06,crimpX*0.3,layer], center=true);
                translate([-crimpX/6,0,0])
                    cube([crimpX*0.06,crimpX*0.3,layer], center=true);
                translate([crimpX/6,0,0])
                    cube([crimpX*0.06,crimpX*0.3,layer], center=true);
            }
        }
    }
    // Crimp Butt Splice
    module crimp_butt_splice(barrel="closed"){
        leftBarrelOffset = crimpX*-0.2;
        rightBarrelOffset = -crimpX*1.08-leftBarrelOffset;

        translate([-leftBarrelOffset,0,0])
            crimp_barrel(barrel,offset=-crimpX*0.1);
        rotate([0,0,180])
            translate([-rightBarrelOffset,0,0])
                crimp_barrel(barrel,offset=-crimpX*0.1);
    }
    
    // Output
    if (hardware == "washer")washer();
    if (hardware == "washer_locking")washer_locking();
    if (hardware == "threaded_insert")threaded_insert();
    if (hardware == "nut")nut();
    if (hardware == "nut_nylon")nut_nylon();
    if (hardware == "nut_square")nut_square();
    if (hardware == "tnut_1")tnut_1();
    if (hardware == "tnut_2")tnut_2();
    if (hardware == "magnet")magnet();
    if (hardware == "crimp_ring_open")crimp_ring(barrel="open");
    if (hardware == "crimp_ring_closed")crimp_ring(barrel="closed");
    if (hardware == "crimp_fork_open")crimp_fork(barrel="open");
    if (hardware == "crimp_fork_closed")crimp_fork(barrel="closed");
    if (hardware == "crimp_spade_open")crimp_spade(barrel="open");
    if (hardware == "crimp_spade_closed")crimp_spade(barrel="closed");
    if (hardware == "crimp_receptacle_open")crimp_receptacle(barrel="open");
    if (hardware == "crimp_receptacle_closed")crimp_receptacle(barrel="closed");
    if (hardware == "crimp_butt_splice")crimp_butt_splice();
}

// Master function to generate configured label
module cullenect_label_generate(
            labelX = labelX,
            labelY = labelY,
            labelZ = labelZ,
            layer = layer,
            showFastener=Show_Fastener,
            fastenerHead=Fastener_Head,
            fastenerShaft=Fastener_Shaft,
            fastenerThreads=Fastener_Threads,
            fastenerDriver=Fastener_Driver,
            fastenerDriverSecurity=Fastener_Driver_Security,
            fastenerHeadFlange=Fastener_Head_Flange,
            hardware=Select_Hardware,
        ){
        
        marginRight = (labelY - hardX) / 2;
        fastener_pos = [labelX-driverX/2,labelY/2,labelZ+layer/2];
        hardware_pos = [labelX-(hardX/2)-marginRight,labelY/2,labelZ+layer/2];
        
        // Fastener
        module fastener(){
            translate(fastener_pos){
                union(){
                    difference(){
                        cullenect_head(head=fastenerHead,flange=fastenerHeadFlange);
                        cullenect_driver(driver=fastenerDriver);
                    }
                    cullenect_shaft(shaft=fastenerShaft,threads=fastenerThreads);
                    if(fastenerDriverSecurity)cullenect_driver(driver="security");
                }
            }
        }
        
        // Hardware
        module hardware(){
            translate(hardware_pos){
                cullenect_hardware(hardware);
            }
        }
        
        // Text, hardware, fastener
        module everything(){
            label_text1();
			label_text2();
            if(showFastener)fastener();
            hardware();
        }
        
        // Emboss or Deboss everything
        if (label_surface == 01) {
            // Deboss
            difference(){
                color("silver")cullenect_base();
                translate([0,0,-layer])
                    color(Text_Color)everything();
            }
        } else if (label_surface == 02) {
            // Flush
            union(){
                color("silver")cullenect_base();
                translate([0,0,-(layer - fudge)])
                    color(Text_Color)everything();
            }
        } else{
            // Emboss
            union(){
                color("silver")cullenect_base();
                color(Text_Color)everything();
            }
        }
}

// Generate Selected Model...
module selected_model() {
         if (Select_Output == 10) {cullenect_socket();}
    else if (Select_Output == 11) {cullenect_socket_negative();}
    else if (Select_Output == 20) {cullenect_vertical_socket();}
    else if (Select_Output == 21) {cullenect_vertical_socket_negative();}
    else                          {cullenect_label_generate();}
}
selected_model();
