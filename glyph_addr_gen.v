module glyph_addr_gen 
#(parameter GLYPH_DATA_WIDTH=24, SYS_DATA_WIDTH=18, 
				SYS_ADDR_WIDTH=16, GLYPH_ADDR_WIDTH=16,
				LOG2_DISPLAY_WIDTH=10, LOG2_DISPLAY_HEIGHT=10)
(
	input clk, reset, bright, vsync, hsync, 
	input [9:0] hcount, vcount,
	input [(SYS_DATA_WIDTH-1):0] sys_data,
	
	output reg [(GLYPH_ADDR_WIDTH-1):0] glyph_addr,
	output reg [(SYS_ADDR_WIDTH-1):0] sys_addr,
	
	output reg [23:0] bg_color,
	output reg [23:0] grid_color,
	output reg [23:0] track_color,
	output reg pix_en
);
//localparam COUNT = 12500000;	// 500 sec
////localparam COUNT = 10;
//localparam STATE_ITER = 3;
//wire timer;
//
//// clk divider
//pulse clk_div (
//	clk, reset,
//	STATE_ITER, COUNT,
//	timer
//);

reg [23:0] printAddr;


localparam BG_COLOR = 24'h0000FF;
                     
localparam GRID_COLOR = 24'h228B22;
localparam TRACK_COLOR = 24'h4682B4;


// multiple fetches if multiple data needed
localparam FETCH0 = 8'h00, FETCH1 = 8'h01, FETCH2 = 8'h02, FETCH3 = 8'h03,
			  FETCH4 = 8'h04, FETCH5 = 8'h05, FETCH6 = 8'h06, FETCH7 = 8'h07;
localparam FETCH_PIXEL = 8'hFF;

reg [7:0] PS, NS;


// recall x_start = 158 = H_BACK_PORCH + H_SYNC + H_FRONT_PORCH
// 		 x_end   = 745 = H_TOTAL - H_BACK_PORCH
//        y_start = 0
//        y_end   = 480 = V_DISPLAY_INT
wire [(LOG2_DISPLAY_WIDTH-1):0] x_pos;
wire [(LOG2_DISPLAY_HEIGHT-1):0] y_pos;
wire [(LOG2_DISPLAY_WIDTH-1):0] x_pos1;
wire [(LOG2_DISPLAY_HEIGHT-1):0] y_pos1;
assign x_pos = hcount - 10'd158;
assign y_pos = vcount;
assign x_pos1= x_pos;
assign y_pos1= y_pos;
wire [(LOG2_DISPLAY_WIDTH-1):0] backGroundx_pos1;
wire [(LOG2_DISPLAY_WIDTH-1):0] backGroundx_pos2;
wire [(LOG2_DISPLAY_WIDTH-1):0] backGroundx_pos3;
wire [(LOG2_DISPLAY_WIDTH-1):0] backGroundx_pos4;
wire [(LOG2_DISPLAY_WIDTH-1):0] backGroundx_pos5;
wire [(LOG2_DISPLAY_WIDTH-1):0] backGroundx_pos6;
wire [(LOG2_DISPLAY_WIDTH-1):0] backGroundx_pos7;
wire [(LOG2_DISPLAY_WIDTH-1):0] backGroundx_pos8;
wire [(LOG2_DISPLAY_WIDTH-1):0] backGroundx_pos9;
wire [(LOG2_DISPLAY_WIDTH-1):0] backGroundx_pos10;
wire [(LOG2_DISPLAY_WIDTH-1):0] backGroundx_pos11;
wire [(LOG2_DISPLAY_WIDTH-1):0] backGroundx_pos12;
wire [(LOG2_DISPLAY_WIDTH-1):0] backGroundx_pos13;
wire [(LOG2_DISPLAY_WIDTH-1):0] backGroundx_pos14;
wire [(LOG2_DISPLAY_WIDTH-1):0] backGroundx_pos15;
wire [(LOG2_DISPLAY_WIDTH-1):0] backGroundx_pos16;
wire [(LOG2_DISPLAY_WIDTH-1):0] backGroundx_pos17;
wire [(LOG2_DISPLAY_WIDTH-1):0] backGroundx_pos18;
wire [(LOG2_DISPLAY_WIDTH-1):0] backGroundx_pos19;
wire [(LOG2_DISPLAY_WIDTH-1):0] backGroundx_pos20;
//wire [(LOG2_DISPLAY_HEIGHT-1):0] y_pos;
wire [(LOG2_DISPLAY_HEIGHT-1):0] backGroundy_pos1;
wire [(LOG2_DISPLAY_HEIGHT-1):0] backGroundy_pos2;
wire [(LOG2_DISPLAY_HEIGHT-1):0] backGroundy_pos3;
wire [(LOG2_DISPLAY_HEIGHT-1):0] backGroundy_pos4;
wire [(LOG2_DISPLAY_HEIGHT-1):0] backGroundy_pos5;
wire [(LOG2_DISPLAY_HEIGHT-1):0] backGroundy_pos6;
wire [(LOG2_DISPLAY_HEIGHT-1):0] backGroundy_pos7;
wire [(LOG2_DISPLAY_HEIGHT-1):0] backGroundy_pos8;
wire [(LOG2_DISPLAY_HEIGHT-1):0] backGroundy_pos9;
wire [(LOG2_DISPLAY_HEIGHT-1):0] backGroundy_pos10;
wire [(LOG2_DISPLAY_HEIGHT-1):0] backGroundy_pos11;
wire [(LOG2_DISPLAY_HEIGHT-1):0] backGroundy_pos12;
wire [(LOG2_DISPLAY_HEIGHT-1):0] backGroundy_pos13;
wire [(LOG2_DISPLAY_HEIGHT-1):0] backGroundy_pos14;
wire [(LOG2_DISPLAY_HEIGHT-1):0] backGroundy_pos15;
assign backGroundx_pos1=32;
assign backGroundx_pos2=64;
assign backGroundx_pos3=96;
assign backGroundx_pos4=128;
assign backGroundx_pos5=160;
assign backGroundx_pos6=192;
assign backGroundx_pos7=224;
assign backGroundx_pos8=256;
assign backGroundx_pos9=288;
assign backGroundx_pos10=320;
assign backGroundx_pos11=352;
assign backGroundx_pos12=384;
assign backGroundx_pos13=416;
assign backGroundx_pos14=448;
assign backGroundx_pos15=480;
assign backGroundx_pos16=512;
assign backGroundx_pos17=544;
assign backGroundx_pos18=576;
assign backGroundx_pos19=608;
assign backGroundx_pos20=640;
assign backGroundy_pos1=32;
assign backGroundy_pos2=64;
assign backGroundy_pos3=96;
assign backGroundy_pos4=128;
assign backGroundy_pos5=160;
assign backGroundy_pos6=192;
assign backGroundy_pos7=224;
assign backGroundy_pos8=256;
assign backGroundy_pos9=288;
assign backGroundy_pos10=320;
assign backGroundy_pos11=352;
assign backGroundy_pos12=384;
assign backGroundy_pos13=416;
assign backGroundy_pos14=448;
assign backGroundy_pos15=480;

// store values fetched to process and use through framerate
reg mario_x_en, mario_y_en, mario_m_en, obstacle_x_en, obstacle_y_en, obstacle_m_en;
wire [(SYS_DATA_WIDTH-1):0] mario_x_pos, mario_y_pos, mario_m_pos, obstacle_x_pos, obstacle_y_pos, obstacle_m_pos;

registerKris #(SYS_DATA_WIDTH) mario_x_reg (clk, reset, mario_x_en, sys_data, mario_x_pos);
registerKris #(SYS_DATA_WIDTH) mario_y_reg (clk, reset, mario_y_en, sys_data, mario_y_pos);
registerKris #(SYS_DATA_WIDTH) mario_m_reg (clk, reset, mario_m_en, sys_data, mario_m_pos);
registerKris #(SYS_DATA_WIDTH) obstacle_x_reg (clk, reset, obstacle_x_en, sys_data, obstacle_x_pos);
registerKris #(SYS_DATA_WIDTH) obstacle_y_reg (clk, reset, obstacle_y_en, sys_data, obstacle_y_pos);
registerKris #(SYS_DATA_WIDTH) obstacle_m_reg (clk, reset, obstacle_m_en, sys_data, obstacle_m_pos);


wire [(LOG2_DISPLAY_WIDTH-1):0] mario_x_off;
wire [(LOG2_DISPLAY_HEIGHT-1):0] mario_y_off;
wire [(LOG2_DISPLAY_WIDTH-1):0] obstacle_x_off;
wire [(LOG2_DISPLAY_HEIGHT-1):0] obstacle_y_off;

assign mario_x_off = x_pos - mario_x_pos;
assign mario_y_off = y_pos - mario_y_pos;
assign obstacle_x_off = x_pos - obstacle_x_pos;
assign obstacle_y_off = y_pos - obstacle_y_pos;

localparam MARIO_GLYPH_WIDTH = 16;
localparam MARIO_GLYPH_HEIGHT = 20;
localparam MARIO_GLYPH_SIZE = 320;	// MARIO_GLYPH_WIDTH * MARIO_GLYPH_HEIGHT
localparam OBSTACLE_GLYPH_WIDTH = 32;
localparam OBSTACLE_GLYPH_HEIGHT = 32;
localparam OBSTACLE_GLYPH_SIZE = 1024;
localparam OBSTACLE_OFFSET = 2560;

always @(posedge clk) begin
	if (reset) PS <= FETCH0;
	else if (!vsync) PS <= FETCH0;
	else PS <= NS;
end


always @* begin
	
	sys_addr = 'hx;
	glyph_addr = 'hx;
	mario_x_en = 0;
	mario_y_en = 0;
	mario_m_en = 0;
	obstacle_x_en = 0;
	obstacle_y_en = 0;
	obstacle_m_en = 0;
	pix_en = 0;
	bg_color = BG_COLOR;
	printAddr= 0;
	//track_color = TRACK_COLOR;
	//grid_color= GRID_COLOR;
	$display("here is sys_data %d \n ", sys_data);
	$display ("here is printAddr= %h\n", printAddr);
	case (PS)
	
		// fetch memory needed ( try and store in as few memory locations possible )
		
		// save stage happens in next FETCH because it you send address and takes
		// 1 cycle for RAM to output value
		
		// fetch mario x-position
		FETCH0: begin
			sys_addr = 'h0050;
			NS = FETCH1;
		end
		
		// save mario x-position and fetch mario y-position
		FETCH1: begin
			mario_x_en = 1'b1;
			sys_addr = 'h0051;
			NS = FETCH2;
		end
		
		// save mario y-position and fetch mario movement position (which mario glyph)
		FETCH2: begin
			mario_y_en = 1'b1;
			sys_addr = 'h0052;
			NS = FETCH3;
		end
		
		// save mario m-position
		FETCH3: begin
			mario_m_en = 1'b1;
			sys_addr = 'h0053;
			//NS = FETCH_PIXEL;
			NS = FETCH4;
		end
		FETCH4: begin
			obstacle_x_en = 1'b1;
			sys_addr = 'h0054; //fetch object x position
			NS = FETCH5;
		end
		FETCH5: begin
			obstacle_y_en = 1'b1;
			sys_addr = 'h0055; //fetch object y position
			NS = FETCH6;
		end
		FETCH6: begin
			obstacle_m_en = 1'b1;
			sys_addr = 'h0056; //fetch object x position
			NS = FETCH_PIXEL;
		end

		// fetch specific pixel based on position
		FETCH_PIXEL: begin
			
			// check for when mario should be displayed
			if (x_pos >= mario_x_pos &&
				 x_pos < (mario_x_pos + MARIO_GLYPH_WIDTH) &&
				 y_pos >= mario_y_pos && 
				 y_pos < (mario_y_pos + MARIO_GLYPH_HEIGHT)) begin
				glyph_addr = (mario_m_pos * MARIO_GLYPH_SIZE) + 	// base address
								 (mario_y_off * MARIO_GLYPH_WIDTH) +	// y-offset
								  mario_x_off;									// x-offset
				pix_en = 1'b1;
			end
	      else if (x_pos >= obstacle_x_pos &&
				 x_pos < (obstacle_x_pos + OBSTACLE_GLYPH_WIDTH) &&
				 y_pos >= obstacle_y_pos && 
				 y_pos < (obstacle_y_pos + OBSTACLE_GLYPH_HEIGHT)) begin
				glyph_addr = OBSTACLE_OFFSET+ (obstacle_m_pos * OBSTACLE_GLYPH_SIZE) + 	// base address
								 (obstacle_y_off * OBSTACLE_GLYPH_WIDTH) +	// y-offset
								  obstacle_x_off;									// x-offset
				pix_en = 1'b1;
			end

else if (x_pos >=0 && x_pos < backGroundx_pos1 &&
						y_pos >= 0 && y_pos < (backGroundy_pos1))
						begin										
						glyph_addr = OBSTACLE_OFFSET+ printAddr;//( OBSTACLE_GLYPH_SIZE) + (y_pos * OBSTACLE_GLYPH_WIDTH) +(x_pos);					
						pix_en = 1'b1;	
						printAddr= printAddr +'h0001;
			         //printAddr = OBSTACLE_OFFSET+ (((x_pos * OBSTACLE_GLYPH_HEIGHT) + (y_pos * OBSTACLE_GLYPH_WIDTH))/32);
			       $display("here is print_addr %d \n ", printAddr );			
						end	
else if (x_pos >0 && x_pos < backGroundx_pos2 &&
						y_pos >= 0 && y_pos < (backGroundy_pos1))
						begin										
						glyph_addr =OBSTACLE_OFFSET+ printAddr; 
						printAddr= printAddr +'h0001;
						//printAddr= printAddr +'h0001;(((x_pos * OBSTACLE_GLYPH_HEIGHT) + (y_pos * OBSTACLE_GLYPH_WIDTH))/32);// OBSTACLE_OFFSET+ ( OBSTACLE_GLYPH_SIZE) + (y_pos * OBSTACLE_GLYPH_WIDTH) +(x_pos);					
						pix_en = 1'b1;				
						end	
else if (x_pos >0 && x_pos < backGroundx_pos3 &&
						y_pos >= 0 && y_pos < (backGroundy_pos1))
						begin										
						glyph_addr =OBSTACLE_OFFSET+printAddr;//	(((x_pos * OBSTACLE_GLYPH_HEIGHT) + (y_pos * OBSTACLE_GLYPH_WIDTH))/32);// OBSTACLE_OFFSET+ ( OBSTACLE_GLYPH_SIZE) + (y_pos * OBSTACLE_GLYPH_WIDTH) +(x_pos);					
						printAddr= printAddr +'h0001;
						pix_en = 1'b1;				
						end	

else if (x_pos >0 && x_pos < backGroundx_pos4 &&
						y_pos >= 0 && y_pos < (backGroundy_pos1))
						begin										
						glyph_addr =OBSTACLE_OFFSET+printAddr;// (((x_pos * OBSTACLE_GLYPH_HEIGHT) + (y_pos * OBSTACLE_GLYPH_WIDTH))/32);// OBSTACLE_OFFSET+ ( OBSTACLE_GLYPH_SIZE) + (y_pos * OBSTACLE_GLYPH_WIDTH) +(x_pos);					
						printAddr= printAddr +'h0001;
						pix_en = 1'b1;				
						end	
else if (x_pos >0 && x_pos < backGroundx_pos5 &&
						y_pos >= 0 && y_pos < (backGroundy_pos1))
						begin										
						glyph_addr = OBSTACLE_OFFSET+ printAddr;// (((x_pos * OBSTACLE_GLYPH_HEIGHT) + (y_pos * OBSTACLE_GLYPH_WIDTH))/32);//OBSTACLE_OFFSET+ ( OBSTACLE_GLYPH_SIZE) + (y_pos * OBSTACLE_GLYPH_WIDTH) +(x_pos);					
						printAddr= printAddr +'h0001;
						pix_en = 1'b1;				
						end	
else if (x_pos >0 && x_pos < backGroundx_pos6 &&
						y_pos >= 0 && y_pos < (backGroundy_pos1))
						begin										
						glyph_addr =OBSTACLE_OFFSET+ printAddr;//(((x_pos * OBSTACLE_GLYPH_HEIGHT) + (y_pos * OBSTACLE_GLYPH_WIDTH))/32);// OBSTACLE_OFFSET+ ( OBSTACLE_GLYPH_SIZE) + (y_pos * OBSTACLE_GLYPH_WIDTH) +(x_pos);					
						printAddr= printAddr +'h0001;
						pix_en = 1'b1;				
						end	
else if (x_pos >0 && x_pos < backGroundx_pos7 &&
						y_pos >= 0 && y_pos < (backGroundy_pos1))
						begin										
						glyph_addr = OBSTACLE_OFFSET+printAddr;// (((x_pos * OBSTACLE_GLYPH_HEIGHT) + (y_pos * OBSTACLE_GLYPH_WIDTH))/32);//OBSTACLE_OFFSET+ ( OBSTACLE_GLYPH_SIZE) + (y_pos * OBSTACLE_GLYPH_WIDTH) +(x_pos);					
						printAddr= printAddr +'h0001;
						pix_en = 1'b1;				
						end	
else if (x_pos >0 && x_pos < backGroundx_pos8 &&
						y_pos >= 0 && y_pos < (backGroundy_pos1))
						begin										
						glyph_addr =OBSTACLE_OFFSET+ (((x_pos * OBSTACLE_GLYPH_HEIGHT) + (y_pos * OBSTACLE_GLYPH_WIDTH))/32);// OBSTACLE_OFFSET+ ( OBSTACLE_GLYPH_SIZE) + (y_pos * OBSTACLE_GLYPH_WIDTH) +(x_pos);					
						pix_en = 1'b1;				
						end	
else if (x_pos >0 && x_pos < backGroundx_pos9 &&
						y_pos >= 0 && y_pos < (backGroundy_pos1))
						begin										
						glyph_addr = OBSTACLE_OFFSET+ (((x_pos * OBSTACLE_GLYPH_HEIGHT) + (y_pos * OBSTACLE_GLYPH_WIDTH))/32);//OBSTACLE_OFFSET+ ( OBSTACLE_GLYPH_SIZE) + (y_pos * OBSTACLE_GLYPH_WIDTH) +(x_pos);					
						pix_en = 1'b1;				
						end	
else if (x_pos >0 && x_pos < backGroundx_pos10 &&
						y_pos >= 0 && y_pos < (backGroundy_pos1))
						begin										
						glyph_addr = OBSTACLE_OFFSET+ (((x_pos * OBSTACLE_GLYPH_HEIGHT) + (y_pos * OBSTACLE_GLYPH_WIDTH))/32);//OBSTACLE_OFFSET+ ( OBSTACLE_GLYPH_SIZE) + (y_pos * OBSTACLE_GLYPH_WIDTH) +(x_pos);					
						pix_en = 1'b1;				
						end	

else if (x_pos >0 && x_pos < backGroundx_pos11 &&
						y_pos >= 0 && y_pos < (backGroundy_pos1))
						begin										
						glyph_addr = OBSTACLE_OFFSET+ (((x_pos * OBSTACLE_GLYPH_HEIGHT) + (y_pos * OBSTACLE_GLYPH_WIDTH))/32);//OBSTACLE_OFFSET+ ( OBSTACLE_GLYPH_SIZE) + (y_pos * OBSTACLE_GLYPH_WIDTH) +(x_pos);					
						pix_en = 1'b1;				
						end	
else if (x_pos >0 && x_pos < backGroundx_pos12 &&
						y_pos >= 0 && y_pos < (backGroundy_pos1))
						begin										
						glyph_addr = OBSTACLE_OFFSET+ ( OBSTACLE_GLYPH_SIZE) + (y_pos * OBSTACLE_GLYPH_WIDTH) +(x_pos);					
						pix_en = 1'b1;				
						end	
else if (x_pos >0 && x_pos < backGroundx_pos13 &&
						y_pos >= 0 && y_pos < (backGroundy_pos1))
						begin										
						glyph_addr = OBSTACLE_OFFSET+ ( OBSTACLE_GLYPH_SIZE) + (y_pos * OBSTACLE_GLYPH_WIDTH) +(x_pos);					
						pix_en = 1'b1;				
						end	
else if (x_pos >0 && x_pos < backGroundx_pos14 &&
						y_pos >= 0 && y_pos < (backGroundy_pos1))
						begin										
						glyph_addr = OBSTACLE_OFFSET+ ( OBSTACLE_GLYPH_SIZE) + (y_pos * OBSTACLE_GLYPH_WIDTH) +(x_pos);					
						pix_en = 1'b1;				
						end	
else if (x_pos >0 && x_pos < backGroundx_pos15 &&
						y_pos >= 0 && y_pos < (backGroundy_pos1))
						begin										
						glyph_addr = OBSTACLE_OFFSET+ ( OBSTACLE_GLYPH_SIZE) + (y_pos * OBSTACLE_GLYPH_WIDTH) +(x_pos);					
						pix_en = 1'b1;				
						end	
else if (x_pos >0 && x_pos < backGroundx_pos16 &&
						y_pos >= 0 && y_pos < (backGroundy_pos1))
						begin										
						glyph_addr = OBSTACLE_OFFSET+ ( OBSTACLE_GLYPH_SIZE) + (y_pos * OBSTACLE_GLYPH_WIDTH) +(x_pos);					
						pix_en = 1'b1;				
						end	
else if (x_pos >0 && x_pos < backGroundx_pos17 &&
						y_pos >= 0 && y_pos < (backGroundy_pos1))
						begin										
						glyph_addr = OBSTACLE_OFFSET+ ( OBSTACLE_GLYPH_SIZE) + (y_pos * OBSTACLE_GLYPH_WIDTH) +(x_pos);					
						pix_en = 1'b1;				
						end	

else if (x_pos >0 && x_pos < backGroundx_pos18 &&
						y_pos >= 0 && y_pos < (backGroundy_pos1))
						begin										
						glyph_addr = OBSTACLE_OFFSET+ ( OBSTACLE_GLYPH_SIZE) + (y_pos * OBSTACLE_GLYPH_WIDTH) +(x_pos);					
						pix_en = 1'b1;				
						end	
else if (x_pos >0 && x_pos < backGroundx_pos19 &&
						y_pos >= 0 && y_pos < (backGroundy_pos1))
						begin										
						glyph_addr = OBSTACLE_OFFSET+ ( OBSTACLE_GLYPH_SIZE) + (y_pos * OBSTACLE_GLYPH_WIDTH) +(x_pos);					
						pix_en = 1'b1;				
						end	
else if (x_pos >0 && x_pos < backGroundx_pos20 &&
						y_pos >= 0 && y_pos < (backGroundy_pos1))
						begin										
						glyph_addr = OBSTACLE_OFFSET+ ( OBSTACLE_GLYPH_SIZE) + (y_pos * OBSTACLE_GLYPH_WIDTH) +(x_pos);					
						pix_en = 1'b1;				
						end	
else if (x_pos >0 && x_pos < backGroundx_pos1 &&
						y_pos >= 0 && y_pos < (backGroundy_pos2))
						begin										
						glyph_addr = OBSTACLE_OFFSET+ ( OBSTACLE_GLYPH_SIZE) + (y_pos * OBSTACLE_GLYPH_WIDTH) +(x_pos);					
						pix_en = 1'b1;				
						end	
else if (x_pos >0 && x_pos < backGroundx_pos2 &&
						y_pos >= 0 && y_pos < (backGroundy_pos2))
						begin										
						glyph_addr = OBSTACLE_OFFSET+ ( OBSTACLE_GLYPH_SIZE) + (y_pos * OBSTACLE_GLYPH_WIDTH) +(x_pos);					
						pix_en = 1'b1;				
						end	
else if (x_pos >0 && x_pos < backGroundx_pos3 &&
						y_pos >= 0 && y_pos < (backGroundy_pos2))
						begin										
						glyph_addr = OBSTACLE_OFFSET+ ( OBSTACLE_GLYPH_SIZE) + (y_pos * OBSTACLE_GLYPH_WIDTH) +(x_pos);					
						pix_en = 1'b1;				
						end	

else if (x_pos >0 && x_pos < backGroundx_pos4 &&
						y_pos >= 0 && y_pos < (backGroundy_pos2))
						begin										
						glyph_addr = OBSTACLE_OFFSET+ ( OBSTACLE_GLYPH_SIZE) + (y_pos * OBSTACLE_GLYPH_WIDTH) +(x_pos);					
						pix_en = 1'b1;				
						end	
else if (x_pos >0 && x_pos < backGroundx_pos5 &&
						y_pos >= 0 && y_pos < (backGroundy_pos2))
						begin										
						glyph_addr = OBSTACLE_OFFSET+ ( OBSTACLE_GLYPH_SIZE) + (y_pos * OBSTACLE_GLYPH_WIDTH) +(x_pos);					
						pix_en = 1'b1;				
						end	
else if (x_pos >0 && x_pos < backGroundx_pos6 &&
						y_pos >= 0 && y_pos < (backGroundy_pos2))
						begin										
						glyph_addr = OBSTACLE_OFFSET+ ( OBSTACLE_GLYPH_SIZE) + (y_pos * OBSTACLE_GLYPH_WIDTH) +(x_pos);					
						pix_en = 1'b1;				
						end	
else if (x_pos >0 && x_pos < backGroundx_pos7 &&
						y_pos >= 0 && y_pos < (backGroundy_pos2))
						begin										
						glyph_addr = OBSTACLE_OFFSET+ ( OBSTACLE_GLYPH_SIZE) + (y_pos * OBSTACLE_GLYPH_WIDTH) +(x_pos);					
						pix_en = 1'b1;				
						end	
else if (x_pos >0 && x_pos < backGroundx_pos8 &&
						y_pos >= 0 && y_pos < (backGroundy_pos2))
						begin										
						glyph_addr = OBSTACLE_OFFSET+ ( OBSTACLE_GLYPH_SIZE) + (y_pos * OBSTACLE_GLYPH_WIDTH) +(x_pos);					
						pix_en = 1'b1;				
						end	
else if (x_pos >0 && x_pos < backGroundx_pos9 &&
						y_pos >= 0 && y_pos < (backGroundy_pos2))
						begin										
						glyph_addr = OBSTACLE_OFFSET+ ( OBSTACLE_GLYPH_SIZE) + (y_pos * OBSTACLE_GLYPH_WIDTH) +(x_pos);					
						pix_en = 1'b1;				
						end	
else if (x_pos >0 && x_pos < backGroundx_pos10 &&
						y_pos >= 0 && y_pos < (backGroundy_pos2))
						begin										
						glyph_addr = OBSTACLE_OFFSET+ ( OBSTACLE_GLYPH_SIZE) + (y_pos * OBSTACLE_GLYPH_WIDTH) +(x_pos);					
						pix_en = 1'b1;				
						end	

else if (x_pos >0 && x_pos < backGroundx_pos11 &&
						y_pos >= 0 && y_pos < (backGroundy_pos2))
						begin										
						glyph_addr = OBSTACLE_OFFSET+ ( OBSTACLE_GLYPH_SIZE) + (y_pos * OBSTACLE_GLYPH_WIDTH) +(x_pos);					
						pix_en = 1'b1;				
						end	
else if (x_pos >0 && x_pos < backGroundx_pos12 &&
						y_pos >= 0 && y_pos < (backGroundy_pos2))
						begin										
						glyph_addr = OBSTACLE_OFFSET+ ( OBSTACLE_GLYPH_SIZE) + (y_pos * OBSTACLE_GLYPH_WIDTH) +(x_pos);					
						pix_en = 1'b1;				
						end	
else if (x_pos >0 && x_pos < backGroundx_pos13 &&
						y_pos >= 0 && y_pos < (backGroundy_pos2))
						begin										
						glyph_addr = OBSTACLE_OFFSET+ ( OBSTACLE_GLYPH_SIZE) + (y_pos * OBSTACLE_GLYPH_WIDTH) +(x_pos);					
						pix_en = 1'b1;				
						end	
else if (x_pos >0 && x_pos < backGroundx_pos14 &&
						y_pos >= 0 && y_pos < (backGroundy_pos2))
						begin										
						glyph_addr = OBSTACLE_OFFSET+ ( OBSTACLE_GLYPH_SIZE) + (y_pos * OBSTACLE_GLYPH_WIDTH) +(x_pos);					
						pix_en = 1'b1;				
						end	
else if (x_pos >0 && x_pos < backGroundx_pos15 &&
						y_pos >= 0 && y_pos < (backGroundy_pos2))
						begin										
						glyph_addr = OBSTACLE_OFFSET+ ( OBSTACLE_GLYPH_SIZE) + (y_pos * OBSTACLE_GLYPH_WIDTH) +(x_pos);					
						pix_en = 1'b1;				
						end	
else if (x_pos >0 && x_pos < backGroundx_pos16 &&
						y_pos >= 0 && y_pos < (backGroundy_pos2))
						begin										
						glyph_addr = OBSTACLE_OFFSET+ ( OBSTACLE_GLYPH_SIZE) + (y_pos * OBSTACLE_GLYPH_WIDTH) +(x_pos);					
						pix_en = 1'b1;				
						end	
else if (x_pos >0 && x_pos < backGroundx_pos17 &&
						y_pos >= 0 && y_pos < (backGroundy_pos2))
						begin										
						glyph_addr = OBSTACLE_OFFSET+ ( OBSTACLE_GLYPH_SIZE) + (y_pos * OBSTACLE_GLYPH_WIDTH) +(x_pos);					
						pix_en = 1'b1;				
						end	

else if (x_pos >0 && x_pos < backGroundx_pos18 &&
						y_pos >= 0 && y_pos < (backGroundy_pos2))
						begin										
						glyph_addr = OBSTACLE_OFFSET+ ( OBSTACLE_GLYPH_SIZE) + (y_pos * OBSTACLE_GLYPH_WIDTH) +(x_pos);					
						pix_en = 1'b1;				
						end	
else if (x_pos >0 && x_pos < backGroundx_pos19 &&
						y_pos >= 0 && y_pos < (backGroundy_pos2))
						begin										
						glyph_addr = OBSTACLE_OFFSET+ ( OBSTACLE_GLYPH_SIZE) + (y_pos * OBSTACLE_GLYPH_WIDTH) +(x_pos);					
						pix_en = 1'b1;				
						end	
else if (x_pos >0 && x_pos < backGroundx_pos20 &&
						y_pos >= 0 && y_pos < (backGroundy_pos2))
						begin										
						glyph_addr = OBSTACLE_OFFSET+ ( OBSTACLE_GLYPH_SIZE) + (y_pos * OBSTACLE_GLYPH_WIDTH) +(x_pos);					
						pix_en = 1'b1;				
						end	

else if (x_pos >0 && x_pos < backGroundx_pos1 &&
						y_pos >= 0 && y_pos < (backGroundy_pos15))
						begin										
						glyph_addr = OBSTACLE_OFFSET+ ( OBSTACLE_GLYPH_SIZE) + (y_pos * OBSTACLE_GLYPH_WIDTH) +(x_pos);					
						pix_en = 1'b1;				
						end	
else if (x_pos >0 && x_pos < backGroundx_pos2 &&
						y_pos >= 0 && y_pos < (backGroundy_pos15))
						begin										
						glyph_addr = OBSTACLE_OFFSET+ ( OBSTACLE_GLYPH_SIZE) + (y_pos * OBSTACLE_GLYPH_WIDTH) +(x_pos);					
						pix_en = 1'b1;				
						end	
else if (x_pos >0 && x_pos < backGroundx_pos3 &&
						y_pos >= 0 && y_pos < (backGroundy_pos15))
						begin										
						glyph_addr = OBSTACLE_OFFSET+ ( OBSTACLE_GLYPH_SIZE) + (y_pos * OBSTACLE_GLYPH_WIDTH) +(x_pos);					
						pix_en = 1'b1;				
						end	

else if (x_pos >0 && x_pos < backGroundx_pos4 &&
						y_pos >= 0 && y_pos < (backGroundy_pos15))
						begin										
						glyph_addr = OBSTACLE_OFFSET+ ( OBSTACLE_GLYPH_SIZE) + (y_pos * OBSTACLE_GLYPH_WIDTH) +(x_pos);					
						pix_en = 1'b1;				
						end	
else if (x_pos >0 && x_pos < backGroundx_pos5 &&
						y_pos >= 0 && y_pos < (backGroundy_pos15))
						begin										
						glyph_addr = OBSTACLE_OFFSET+ ( OBSTACLE_GLYPH_SIZE) + (y_pos * OBSTACLE_GLYPH_WIDTH) +(x_pos);					
						pix_en = 1'b1;				
						end	
else if (x_pos >0 && x_pos < backGroundx_pos6 &&
						y_pos >= 0 && y_pos < (backGroundy_pos15))
						begin										
						glyph_addr = OBSTACLE_OFFSET+ ( OBSTACLE_GLYPH_SIZE) + (y_pos * OBSTACLE_GLYPH_WIDTH) +(x_pos);					
						pix_en = 1'b1;				
						end	
else if (x_pos >0 && x_pos < backGroundx_pos7 &&
						y_pos >= 0 && y_pos < (backGroundy_pos15))
						begin										
						glyph_addr = OBSTACLE_OFFSET+ ( OBSTACLE_GLYPH_SIZE) + (y_pos * OBSTACLE_GLYPH_WIDTH) +(x_pos);					
						pix_en = 1'b1;				
						end	
else if (x_pos >0 && x_pos < backGroundx_pos8 &&
						y_pos >= 0 && y_pos < (backGroundy_pos15))
						begin										
						glyph_addr = OBSTACLE_OFFSET+ ( OBSTACLE_GLYPH_SIZE) + (y_pos * OBSTACLE_GLYPH_WIDTH) +(x_pos);					
						pix_en = 1'b1;				
						end	
else if (x_pos >0 && x_pos < backGroundx_pos9 &&
						y_pos >= 0 && y_pos < (backGroundy_pos15))
						begin										
						glyph_addr = OBSTACLE_OFFSET+ ( OBSTACLE_GLYPH_SIZE) + (y_pos * OBSTACLE_GLYPH_WIDTH) +(x_pos);					
						pix_en = 1'b1;				
						end	
else if (x_pos >0 && x_pos < backGroundx_pos10 &&
						y_pos >= 0 && y_pos < (backGroundy_pos15))
						begin										
						glyph_addr = OBSTACLE_OFFSET+ ( OBSTACLE_GLYPH_SIZE) + (y_pos * OBSTACLE_GLYPH_WIDTH) +(x_pos);					
						pix_en = 1'b1;				
						end	

else if (x_pos >0 && x_pos < backGroundx_pos11 &&
						y_pos >= 0 && y_pos < (backGroundy_pos15))
						begin										
						glyph_addr = OBSTACLE_OFFSET+ ( OBSTACLE_GLYPH_SIZE) + (y_pos * OBSTACLE_GLYPH_WIDTH) +(x_pos);					
						pix_en = 1'b1;				
						end	
else if (x_pos >0 && x_pos < backGroundx_pos12 &&
						y_pos >= 0 && y_pos < (backGroundy_pos15))
						begin										
						glyph_addr = OBSTACLE_OFFSET+ ( OBSTACLE_GLYPH_SIZE) + (y_pos * OBSTACLE_GLYPH_WIDTH) +(x_pos);					
						pix_en = 1'b1;				
						end	
else if (x_pos >0 && x_pos < backGroundx_pos13 &&
						y_pos >= 0 && y_pos < (backGroundy_pos15))
						begin										
						glyph_addr = OBSTACLE_OFFSET+ ( OBSTACLE_GLYPH_SIZE) + (y_pos * OBSTACLE_GLYPH_WIDTH) +(x_pos);					
						pix_en = 1'b1;				
						end	
else if (x_pos >0 && x_pos < backGroundx_pos14 &&
						y_pos >= 0 && y_pos < (backGroundy_pos15))
						begin										
						glyph_addr = OBSTACLE_OFFSET+ ( OBSTACLE_GLYPH_SIZE) + (y_pos * OBSTACLE_GLYPH_WIDTH) +(x_pos);					
						pix_en = 1'b1;				
						end	
else if (x_pos >0 && x_pos < backGroundx_pos15 &&
						y_pos >= 0 && y_pos < (backGroundy_pos15))
						begin										
						glyph_addr = OBSTACLE_OFFSET+ ( OBSTACLE_GLYPH_SIZE) + (y_pos * OBSTACLE_GLYPH_WIDTH) +(x_pos);					
						pix_en = 1'b1;				
						end	
else if (x_pos >0 && x_pos < backGroundx_pos16 &&
						y_pos >= 0 && y_pos < (backGroundy_pos15))
						begin										
						glyph_addr = OBSTACLE_OFFSET+ ( OBSTACLE_GLYPH_SIZE) + (y_pos * OBSTACLE_GLYPH_WIDTH) +(x_pos);					
						pix_en = 1'b1;				
						end	
else if (x_pos >0 && x_pos < backGroundx_pos17 &&
						y_pos >= 0 && y_pos < (backGroundy_pos15))
						begin										
						glyph_addr = OBSTACLE_OFFSET+ ( OBSTACLE_GLYPH_SIZE) + (y_pos * OBSTACLE_GLYPH_WIDTH) +(x_pos);					
						pix_en = 1'b1;				
						end	

else if (x_pos >0 && x_pos < backGroundx_pos18 &&
						y_pos >= 0 && y_pos < (backGroundy_pos15))
						begin										
						glyph_addr = OBSTACLE_OFFSET+ ( OBSTACLE_GLYPH_SIZE) + (y_pos * OBSTACLE_GLYPH_WIDTH) +(x_pos);					
						pix_en = 1'b1;				
						end	
else if (x_pos >0 && x_pos < backGroundx_pos19 &&
						y_pos >= 0 && y_pos < (backGroundy_pos15))
						begin										
						glyph_addr = OBSTACLE_OFFSET+ ( OBSTACLE_GLYPH_SIZE) + (y_pos * OBSTACLE_GLYPH_WIDTH) +(x_pos);					
						pix_en = 1'b1;				
						end	
else if (x_pos >0 && x_pos < backGroundx_pos20 &&
						y_pos >= 0 && y_pos < (backGroundy_pos15))
						begin										
						glyph_addr = OBSTACLE_OFFSET+ ( OBSTACLE_GLYPH_SIZE) + (y_pos * OBSTACLE_GLYPH_WIDTH) +(x_pos);					
						pix_en = 1'b1;				
						end	

							else if (x_pos >0 && x_pos < backGroundx_pos1 &&
						y_pos >= 0 && y_pos < (backGroundy_pos9))
						begin										
						glyph_addr = OBSTACLE_OFFSET+ ( OBSTACLE_GLYPH_SIZE) + (y_pos * OBSTACLE_GLYPH_WIDTH) +(x_pos);					
						pix_en = 1'b1;				
						end	
else if (x_pos >0 && x_pos < backGroundx_pos2 &&
						y_pos >= 0 && y_pos < (backGroundy_pos9))
						begin										
						glyph_addr = OBSTACLE_OFFSET+ ( OBSTACLE_GLYPH_SIZE) + (y_pos * OBSTACLE_GLYPH_WIDTH) +(x_pos);					
						pix_en = 1'b1;				
						end	
else if (x_pos >0 && x_pos < backGroundx_pos3 &&
						y_pos >= 0 && y_pos < (backGroundy_pos9))
						begin										
						glyph_addr = OBSTACLE_OFFSET+ ( OBSTACLE_GLYPH_SIZE) + (y_pos * OBSTACLE_GLYPH_WIDTH) +(x_pos);					
						pix_en = 1'b1;				
						end	

else if (x_pos >0 && x_pos < backGroundx_pos4 &&
						y_pos >= 0 && y_pos < (backGroundy_pos9))
						begin										
						glyph_addr = OBSTACLE_OFFSET+ ( OBSTACLE_GLYPH_SIZE) + (y_pos * OBSTACLE_GLYPH_WIDTH) +(x_pos);					
						pix_en = 1'b1;				
						end	
else if (x_pos >0 && x_pos < backGroundx_pos5 &&
						y_pos >= 0 && y_pos < (backGroundy_pos9))
						begin										
						glyph_addr = OBSTACLE_OFFSET+ ( OBSTACLE_GLYPH_SIZE) + (y_pos * OBSTACLE_GLYPH_WIDTH) +(x_pos);					
						pix_en = 1'b1;				
						end	
else if (x_pos >0 && x_pos < backGroundx_pos6 &&
						y_pos >= 0 && y_pos < (backGroundy_pos9))
						begin										
						glyph_addr = OBSTACLE_OFFSET+ ( OBSTACLE_GLYPH_SIZE) + (y_pos * OBSTACLE_GLYPH_WIDTH) +(x_pos);					
						pix_en = 1'b1;				
						end	
else if (x_pos >0 && x_pos < backGroundx_pos7 &&
						y_pos >= 0 && y_pos < (backGroundy_pos9))
						begin										
						glyph_addr = OBSTACLE_OFFSET+ ( OBSTACLE_GLYPH_SIZE) + (y_pos * OBSTACLE_GLYPH_WIDTH) +(x_pos);					
						pix_en = 1'b1;				
						end	
else if (x_pos >0 && x_pos < backGroundx_pos8 &&
						y_pos >= 0 && y_pos < (backGroundy_pos9))
						begin										
						glyph_addr = OBSTACLE_OFFSET+ ( OBSTACLE_GLYPH_SIZE) + (y_pos * OBSTACLE_GLYPH_WIDTH) +(x_pos);					
						pix_en = 1'b1;				
						end	
else if (x_pos >0 && x_pos < backGroundx_pos9 &&
						y_pos >= 0 && y_pos < (backGroundy_pos9))
						begin										
						glyph_addr = OBSTACLE_OFFSET+ ( OBSTACLE_GLYPH_SIZE) + (y_pos * OBSTACLE_GLYPH_WIDTH) +(x_pos);					
						pix_en = 1'b1;				
						end	
else if (x_pos >0 && x_pos < backGroundx_pos10 &&
						y_pos >= 0 && y_pos < (backGroundy_pos9))
						begin										
						glyph_addr = OBSTACLE_OFFSET+ ( OBSTACLE_GLYPH_SIZE) + (y_pos * OBSTACLE_GLYPH_WIDTH) +(x_pos);					
						pix_en = 1'b1;				
						end	

else if (x_pos >0 && x_pos < backGroundx_pos11 &&
						y_pos >= 0 && y_pos < (backGroundy_pos9))
						begin										
						glyph_addr = OBSTACLE_OFFSET+ ( OBSTACLE_GLYPH_SIZE) + (y_pos * OBSTACLE_GLYPH_WIDTH) +(x_pos);					
						pix_en = 1'b1;				
						end	
else if (x_pos >0 && x_pos < backGroundx_pos12 &&
						y_pos >= 0 && y_pos < (backGroundy_pos9))
						begin										
						glyph_addr = OBSTACLE_OFFSET+ ( OBSTACLE_GLYPH_SIZE) + (y_pos * OBSTACLE_GLYPH_WIDTH) +(x_pos);					
						pix_en = 1'b1;				
						end	
else if (x_pos >0 && x_pos < backGroundx_pos13 &&
						y_pos >= 0 && y_pos < (backGroundy_pos9))
						begin										
						glyph_addr = OBSTACLE_OFFSET+ ( OBSTACLE_GLYPH_SIZE) + (y_pos * OBSTACLE_GLYPH_WIDTH) +(x_pos);					
						pix_en = 1'b1;				
						end	
else if (x_pos >0 && x_pos < backGroundx_pos14 &&
						y_pos >= 0 && y_pos < (backGroundy_pos9))
						begin										
						glyph_addr = OBSTACLE_OFFSET+ ( OBSTACLE_GLYPH_SIZE) + (y_pos * OBSTACLE_GLYPH_WIDTH) +(x_pos);					
						pix_en = 1'b1;				
						end	
else if (x_pos >0 && x_pos < backGroundx_pos15 &&
						y_pos >= 0 && y_pos < (backGroundy_pos9))
						begin										
						glyph_addr = OBSTACLE_OFFSET+ ( OBSTACLE_GLYPH_SIZE) + (y_pos * OBSTACLE_GLYPH_WIDTH) +(x_pos);					
						pix_en = 1'b1;				
						end	
else if (x_pos >0 && x_pos < backGroundx_pos16 &&
						y_pos >= 0 && y_pos < (backGroundy_pos9))
						begin										
						glyph_addr = OBSTACLE_OFFSET+ ( OBSTACLE_GLYPH_SIZE) + (y_pos * OBSTACLE_GLYPH_WIDTH) +(x_pos);					
						pix_en = 1'b1;				
						end	
else if (x_pos >0 && x_pos < backGroundx_pos17 &&
						y_pos >= 0 && y_pos < (backGroundy_pos9))
						begin										
						glyph_addr = OBSTACLE_OFFSET+ ( OBSTACLE_GLYPH_SIZE) + (y_pos * OBSTACLE_GLYPH_WIDTH) +(x_pos);					
						pix_en = 1'b1;				
						end	

else if (x_pos >0 && x_pos < backGroundx_pos18 &&
						y_pos >= 0 && y_pos < (backGroundy_pos9))
						begin										
						glyph_addr = OBSTACLE_OFFSET+ ( OBSTACLE_GLYPH_SIZE) + (y_pos * OBSTACLE_GLYPH_WIDTH) +(x_pos);					
						pix_en = 1'b1;				
						end	
else if (x_pos >0 && x_pos < backGroundx_pos19 &&
						y_pos >= 0 && y_pos < (backGroundy_pos9))
						begin										
						glyph_addr = OBSTACLE_OFFSET+ ( OBSTACLE_GLYPH_SIZE) + (y_pos * OBSTACLE_GLYPH_WIDTH) +(x_pos);					
						pix_en = 1'b1;				
						end	
else if (x_pos >0 && x_pos < backGroundx_pos20 &&
						y_pos >= 0 && y_pos < (backGroundy_pos9))
						begin										
						glyph_addr = OBSTACLE_OFFSET+ ( OBSTACLE_GLYPH_SIZE) + (y_pos * OBSTACLE_GLYPH_WIDTH) +(x_pos);					
						pix_en = 1'b1;				
						end	

						NS = FETCH_PIXEL;
		end
	
	endcase 
	
end

endmodule
