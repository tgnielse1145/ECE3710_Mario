module bitgen 
#(parameter DATA_WIDTH=24)
(
	input bright, pix_en,
	input [(DATA_WIDTH-1):0] pixel, 
	input [23:0] bg_color,
	input [23:0] grid_color,
	input	[23:0] track_color,
	input	[23:0] bound_color,
	input [9:0] hcount, vcount, 
	output reg [23:0] rgb
);

wire [9:0] x_pos, y_pos;
assign x_pos = hcount;
assign y_pos = vcount; 


always @(bright, pixel, bg_color, grid_color, track_color, bound_color, pix_en, x_pos, y_pos) begin

	if (bright) begin
	
		// check if valid pixel even sent
		if (pix_en) begin
			
			// check for transparency bit -- h000000
			if (pixel == 24'h000000)
				
				if(x_pos >= 300 && x_pos < 650 &&
				   y_pos >= 0 && y_pos < 500)
				   rgb = track_color;
						  
				else if(x_pos >= 280 && x_pos < 300 &&
						  y_pos >= 0 && y_pos < 500)
						  rgb = bound_color;
						  
				else if(x_pos >= 650 && x_pos < 670 &&
						  y_pos >= 0 && y_pos < 500)
						  rgb = bound_color;

				else
					rgb = bg_color;
							
			else
				rgb = pixel;
				
		end
		
		// display grid for game background
		else begin
				  
		   if(x_pos >= 300 && x_pos < 650 &&
		      y_pos >= 0 && y_pos < 500)
		      rgb = track_color;
					  
		   else if(x_pos >= 280 && x_pos < 300 &&
					  y_pos >= 0 && y_pos < 500)
					  rgb = bound_color;
					  
			else if(x_pos >= 650 && x_pos < 670 &&
					  y_pos >= 0 && y_pos < 500)
					  rgb = bound_color;
				  
			else rgb = bg_color;
			
			end
		
	end
	
	// can't actually display anything
	else rgb = 0;

end

endmodule
