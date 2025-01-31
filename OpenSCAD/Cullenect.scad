/* [General Settings] */
//I want to generate...
Select_Output=0; // [0:Label, 10:Socket test fit, 11:Socket Negative Volume, 20:Vertical Socket, 21:Vertical Socket Negative]
//model = "" // ["Cullenect label","Socket test fit","Socket Negative Volume"]
// Width in gridfinity units
label_width = 1; // .1
// Generate V1 Latches for 1U labels?
backward_compatible = true;
// Deboss Text?
label_deboss = false;

/* [Label Text 1] */

// Label Text
Text1 = "Cullenect";
// Text Alignment
Text1_Align = "left"; // ["left","center","right"]
// Font Size
Text1_Font_Size = 6;  // .1
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

/* [Advanced] */
// Increase or decrease resolution of certain details
$fs = 0.01;  // .01

// Use gridfinity U
gridfinity = true;

// Width of label in mm
labelXmm = 36.0;  // .1

// Height of label in mm
labelYmm = 11.0;  // .1

// Thickness of label in mm
labelZmm = 1.2;  // .1

/* [Hidden] */
gridfinityX = 42; // Grid size for gridfinity units.
labelX = (gridfinity) ? (label_width * gridfinityX) - 6 : labelXmm;
labelY = (gridfinity) ? 11 : labelYmm;
labelZ = (gridfinity) ? 1.2 : labelZmm;
latchX = 0.2; // Width of socket on label walls
latchZ = 0.6; // Z-height of wall socket
layer = 0.2; // Layer height of text and icons
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
module Cullenect_Label_V1() {

	// Variables
	labelX_v1 = 36;
	labelY_v1 = 11;
	$midX1 = 4.695;
	$midX2 = 10.18;
	$midlatchX = 1.95;
	$bottomX1 = 5.395;
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
module Cullenect_Label_V2() {
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
module Cullenect_Label() {
	if (backward_compatible && gridfinity && (label_width == 1)){
		Cullenect_Label_V1();
	} else {
		Cullenect_Label_V2();
	}
}

// Calculate Text1 Position and font
Text1_posX = (Text1_Align == "left") ? 0 + Text1_XY.x : 
            (Text1_Align == "center") ? (labelX / 2) + Text1_XY.x : 
            (Text1_Align == "right") ? labelX + Text1_XY.x : 0; // Fallback to 0
Text1_posY = (labelY / 2) + Text1_XY.y;
Text1_posZ = labelZ - 0.2;
Text1_pos = [Text1_posX, Text1_posY, Text1_posZ];

// Calculate Text2 Position and font
Text2_posX = (Text2_Align == "left") ? 0 + Text2_XY.x : 
            (Text2_Align == "center") ? (labelX / 2) + Text2_XY.x : 
            (Text2_Align == "right") ? labelX + Text2_XY.x : 0; // Fallback to 0
Text2_posY = (labelY / 2) + Text2_XY.y;
Text2_posZ = labelZ - 0.2;
Text2_pos = [Text2_posX, Text2_posY, Text2_posZ];

// Generate Label Text #1
module label_text1() {
	translate(Text1_pos)
		linear_extrude(0.4)
			text(Text1, Text1_Font_Size, font = str(Text1_Font, ":", Text1_Font_Style), halign = Text1_Align, valign = "center");
}

// Generate Label Text #2
module label_text2() {
	translate(Text2_pos)
		linear_extrude(0.4)
			text(Text2, Text2_Font_Size, font = str(Text2_Font, ":", Text2_Font_Style), halign = Text2_Align, valign = "center");
}
		
// Join or difference the label and text
module cullenect_label_text(){
	if (label_deboss) {
		difference() {
			Cullenect_Label();
			color("Gray")
				label_text1();
			label_text2();
		}
	} else {
		union() {
			Cullenect_Label();
			color("Gray")
				label_text1();
			label_text2();
		}
	}
}

// Socket and Socket Negative Variables
socket_offset = 0.3;
socket_walls = 2;
socketX = labelX + socket_offset;
socketY = labelY + socket_offset;
ribZ = 0.4;
// Generate socket
module cullenect_socket(){
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
module cullenect_vertical_socket_negative() {
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

// Hardware icon variables
driverX = 6; // Size of driver icon
driverWidth = 1; // Width of "most" driver shapes inside icon
driverLength = 5.333; // Length of most driver shapes inside icon

// Generate Driver Icon
module cullenect_driver(driver="none") {
    
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
        
        // Bring everything together
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
    
    // Output
    if (driver == "blank")blank();
    if (driver == "slot")slot();
    if (driver == "phillips")phillips();
    if (driver == "phillips_slot")phillips_slot();
    if (driver == "phillips_square")phillips_square();
    if (driver == "torx")torx();
}
difference(){
    cullenect_driver(driver="blank");
    cullenect_driver(driver="torx");
}


// Generate Selected Model...
module selected_model() {
         if (Select_Output == 10) {cullenect_socket();}
    else if (Select_Output == 11) {cullenect_socket_negative();}
    else if (Select_Output == 20) {cullenect_vertical_socket();}
    else if (Select_Output == 21) {cullenect_vertical_socket_negative();}
    else                          {cullenect_label_text();}
}
*selected_model();
		