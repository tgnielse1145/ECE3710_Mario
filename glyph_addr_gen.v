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
	output reg [23:0] bound_color,
	output reg pix_en
);


localparam BG_COLOR = 24'h98FB98;                     
localparam GRID_COLOR = 24'h228B22;
localparam TRACK_COLOR = 24'h808069;
localparam BOUND_COLOR = 24'hFFFFFF;


// multiple fetches if multiple data needed
localparam FETCH0  = 8'h00, FETCH1  = 8'h01,  FETCH2 = 8'h02,  FETCH3 = 8'h03,
			  FETCH4  = 8'h04, FETCH5  = 8'h05,  FETCH6 = 8'h06,  FETCH7 = 8'h07,
			  FETCH8  = 8'h08, FETCH9  = 8'h09, FETCH10 = 8'h10, FETCH11 = 8'h11,
			  FETCH12 = 8'h12, FETCH13 = 8'h13, FETCH14 = 8'h14, FETCH15 = 8'h15;

localparam FETCH_PIXEL = 8'hFF;

reg [7:0] PS, NS;
reg [15:0]displayBG, counterBG;

// recall x_start = 158 = H_BACK_PORCH + H_SYNC + H_FRONT_PORCH
// 		 x_end   = 745 = H_TOTAL - H_BACK_PORCH
//        y_start = 0
//        y_end   = 480 = V_DISPLAY_INT
wire [(LOG2_DISPLAY_WIDTH-1):0] x_pos;
wire [(LOG2_DISPLAY_HEIGHT-1):0] y_pos;
assign x_pos = hcount - 10'd158;
assign y_pos = vcount;


// store values fetched to process and use through framerate
reg mario_x_en, mario_y_en, mario_m_en, greenShell_x_en, greenShell_y_en, greenShell_m_en,redShell_x_en, redShell_y_en, redShell_m_en, bowser_y_en, bowser_x_en, bowser_m_en;
wire [(SYS_DATA_WIDTH-1):0] mario_x_pos, mario_y_pos, mario_m_pos, greenShell_x_pos, greenShell_y_pos, greenShell_m_pos,redShell_x_pos, redShell_y_pos, redShell_m_pos, boswer_x_pos, bowser_y_pos, bowswer_m_pos;

registerKris #(SYS_DATA_WIDTH) mario_x_reg (clk, reset, mario_x_en, sys_data, mario_x_pos);
registerKris #(SYS_DATA_WIDTH) mario_y_reg (clk, reset, mario_y_en, sys_data, mario_y_pos);
registerKris #(SYS_DATA_WIDTH) mario_m_reg (clk, reset, mario_m_en, sys_data, mario_m_pos);
registerKris #(SYS_DATA_WIDTH) greenShell_x_reg (clk, reset, greenShell_x_en, sys_data, greenShell_x_pos);
registerKris #(SYS_DATA_WIDTH) greenShell_y_reg (clk, reset, greenShell_y_en, sys_data, greenShell_y_pos);
registerKris #(SYS_DATA_WIDTH) greenShell_m_reg (clk, reset, greenShell_m_en, sys_data, greenShell_m_pos);
registerKris #(SYS_DATA_WIDTH) redShell_x_reg (clk, reset, redShell_x_en, sys_data, redShell_x_pos);
registerKris #(SYS_DATA_WIDTH) redShell_y_reg (clk, reset, redShell_y_en, sys_data, redShell_y_pos);
registerKris #(SYS_DATA_WIDTH) redShell_m_reg (clk, reset, redShell_m_en, sys_data, redShell_m_pos);
registerKris #(SYS_DATA_WIDTH) bowser_x_reg (clk, reset, bowser_x_en, sys_data, bowser_x_pos);
registerKris #(SYS_DATA_WIDTH) bowser_y_reg (clk, reset, bowser_y_en, sys_data, bowser_y_pos);
registerKris #(SYS_DATA_WIDTH) bowser_m_reg (clk, reset, bowser_m_en, sys_data, bowser_m_pos);


wire [(LOG2_DISPLAY_WIDTH-1):0] mario_x_off;
wire [(LOG2_DISPLAY_HEIGHT-1):0] mario_y_off;
wire [(LOG2_DISPLAY_WIDTH-1):0] greenShell_x_off;
wire [(LOG2_DISPLAY_HEIGHT-1):0] greenShell_y_off;
wire [(LOG2_DISPLAY_WIDTH-1):0] redShell_x_off;
wire [(LOG2_DISPLAY_HEIGHT-1):0] redShell_y_off;
wire [(LOG2_DISPLAY_WIDTH-1):0] bowser_x_off;
wire [(LOG2_DISPLAY_HEIGHT-1):0] bowser_y_off;

assign mario_x_off = x_pos - mario_x_pos;
assign mario_y_off = y_pos - mario_y_pos;
assign greenShell_x_off = x_pos - greenShell_x_pos;
assign greenShell_y_off = y_pos - greenShell_y_pos;
assign redShell_x_off = x_pos - redShell_x_pos;
assign redShell_y_off = y_pos - redShell_y_pos;
assign bowser_x_off = x_pos - bowser_x_pos;
assign bowser_y_off = y_pos - bowser_y_pos;

localparam MARIO_GLYPH_WIDTH = 32;
localparam MARIO_GLYPH_HEIGHT = 32;
localparam MARIO_GLYPH_SIZE = 1024;	
localparam GREENSHELL_GLYPH_WIDTH = 18;
localparam GREENSHELL_GLYPH_HEIGHT = 18;
localparam GREENSHELL_GLYPH_SIZE = 324;
localparam GREENSHELL_OFFSET = 3072;
localparam REDSHELL_GLYPH_WIDTH = 20;
localparam REDSHELL_GLYPH_HEIGHT = 20;
localparam REDSHELL_GLYPH_SIZE = 400;
localparam REDSHELL_OFFSET = 3396;
localparam BOWSER_GLYPH_WIDTH = 28;
localparam BOWSER_GLYPH_HEIGHT = 31;
localparam BOWSER_GLYPH_SIZE = 896;
localparam BOWSER_OFFSET = 3796;
	

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
	greenShell_x_en = 0;
	greenShell_y_en = 0;
	greenShell_m_en = 0;
	redShell_x_en = 0;
	redShell_y_en = 0;
	redShell_m_en = 0;
	bowser_x_en = 0;
	bowser_y_en = 0;
	bowser_m_en = 0;
	pix_en = 0;
	bg_color = BG_COLOR;
	track_color = TRACK_COLOR;
	grid_color= GRID_COLOR;
	bound_color = BOUND_COLOR;
	
	case (PS)
	
		// fetch memory needed ( try and store in as few memory locations possible )
		
		// save stage happens in next FETCH because it you send address and takes
		// 1 cycle for RAM to output value
		
		// fetch mario x-position
		FETCH0: begin
			sys_addr = 'h00c8;
			NS = FETCH1;
		end
		
		// save mario x-position and fetch mario y-position
		FETCH1: begin
			mario_x_en = 1'b1;
			sys_addr = 'h00c9;
			NS = FETCH2;
		end
		
		// save mario y-position and fetch mario movement position (which mario glyph)
		FETCH2: begin
			mario_y_en = 1'b1;
			sys_addr = 'h00ca;
			NS = FETCH3;
		end
		
		// save mario m-position
		FETCH3: begin
			mario_m_en = 1'b1;
			sys_addr = 'h00cb;
			NS = FETCH4;
		end
		FETCH4: begin
			greenShell_x_en = 1'b1;
			sys_addr = 'h00cc; //save object x position
			NS = FETCH5;
		end
		FETCH5: begin
			greenShell_y_en = 1'b1;
			sys_addr = 'h00cd; //save object y position
			NS = FETCH6;
		end
		FETCH6: begin
			greenShell_m_en = 1'b1;
			sys_addr = 'h00ce; //save object movement position
			//NS = FETCH_PIXEL;
			NS = FETCH7;
		end
      FETCH7: begin
			redShell_x_en = 1'b1;
			sys_addr = 'h00cf; 
			NS = FETCH8;
		end
		FETCH8: begin
			redShell_y_en = 1'b1;
			sys_addr = 'h00d0; 		
			NS = FETCH9;
		end
		FETCH9: begin
			redShell_m_en = 1'b1;
			sys_addr = 'h00d1;
			NS=FETCH10;
			
		end
		FETCH10: begin
			bowser_x_en = 1'b1;
			sys_addr = 'h00d2;
			NS=FETCH11;
			
		end
		FETCH11: begin
			bowser_y_en = 1'b1;
			sys_addr = 'h00d3;
			NS=FETCH12;
			
		end
		FETCH12: begin
			bowser_m_en = 1'b1;
			sys_addr = 'h00d3;
			NS = FETCH_PIXEL;
			
			
		end
		
		// fetch specific pixel based on position
		FETCH_PIXEL: begin
					$display("here is mario_m_pos %d \n ", mario_m_pos);						  // x-offset
				//bg_color = sys_addr;
			// check for when mario should be displayed
			if (x_pos >= mario_x_pos &&
				 x_pos < (mario_x_pos + MARIO_GLYPH_WIDTH) &&
				 y_pos >= mario_y_pos && 
				 y_pos < (mario_y_pos + MARIO_GLYPH_HEIGHT)) begin
				glyph_addr =(mario_m_pos * MARIO_GLYPH_SIZE)+ (mario_y_off * MARIO_GLYPH_WIDTH) +	// y-offset
								  mario_x_off;	
				pix_en = 1'b1;
			end
	      else if (x_pos >= greenShell_x_pos &&
				 x_pos < (greenShell_x_pos + GREENSHELL_GLYPH_WIDTH) &&
				 y_pos >= greenShell_y_pos && 
				 y_pos < (greenShell_y_pos + GREENSHELL_GLYPH_HEIGHT)) begin
				glyph_addr = GREENSHELL_OFFSET+ (greenShell_m_pos * GREENSHELL_GLYPH_SIZE) + 	// base address
								 (greenShell_y_off * GREENSHELL_GLYPH_WIDTH) +	// y-offset
								  greenShell_x_off;									// x-offset
				pix_en = 1'b1;
			end
			else if (x_pos >= redShell_x_pos &&
				 x_pos < (redShell_x_pos + REDSHELL_GLYPH_WIDTH) &&
				 y_pos >= redShell_y_pos && 
				 y_pos < (redShell_y_pos + REDSHELL_GLYPH_HEIGHT)) begin
				glyph_addr = REDSHELL_OFFSET+ (redShell_m_pos * REDSHELL_GLYPH_SIZE) + 	// base address
								 (redShell_y_off * REDSHELL_GLYPH_WIDTH) +	// y-offset
								  redShell_x_off;									// x-offset
				pix_en = 1'b1;
			end
			//else if (x_pos >= bowser_x_pos &&
			//	 x_pos < (bowser_x_pos + BOWSER_GLYPH_WIDTH) &&
			//	 y_pos >= bowser_y_pos && 
			//	 y_pos < (bowser_y_pos + BOWSER_GLYPH_HEIGHT)) begin
			//	glyph_addr = BOWSER_OFFSET+ (bowser_m_pos * BOWSER_GLYPH_SIZE) + 	// base address
			//					 (bowser_y_off * BOWSER_GLYPH_WIDTH) +	// y-offset
			//					  bowser_x_off;									// x-offset
			//	pix_en = 1'b1;
			//end
			
			$display("here is greenShell_x_pos %h \n", greenShell_x_pos);
			$display("here is greenShell_y_pos %h \n", greenShell_y_pos);
			$display("here is greenShell_m_pos %h \n", greenShell_m_pos);
			
			$display("here is redShell_x_pos %h \n", redShell_x_pos);
			$display("here is redShell_y_pos %h \n", redShell_y_pos);
			$display("here is redShell_m_pos %h \n", redShell_m_pos);
			
			
			//$display("here is bowser_x_pos %h \n", bowser_x_pos);
			//$display("here is bowser_y_pos %h \n", bowser_y_pos);
			//$display("here is bowser_m_pos %h \n", bowser_m_pos);


			
			
			
			NS = FETCH_PIXEL;
		end
	
	endcase 
	
end

endmodule
