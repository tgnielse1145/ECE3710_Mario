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
				   y_pos >= 0 && y_pos < 500)begin
					
						  if(x_pos >=475 && x_pos < 495&&
					   y_pos >=0 && y_pos < 20)begin
							rgb=bound_color;
							end
					  else if(x_pos >=475 && x_pos < 495&&
					   y_pos >=40 && y_pos < 60)begin
							rgb=bound_color;
							end
					 else if(x_pos >=475 && x_pos < 495&&
					   y_pos >=80 && y_pos < 100)begin
							rgb=bound_color;
							end
					 else if(x_pos >=475 && x_pos < 495&&
					   y_pos >=120 && y_pos < 140)begin
							rgb=bound_color;
							end
					 else if(x_pos >=475 && x_pos < 495&&
					   y_pos >=160 && y_pos < 180)begin
							rgb=bound_color;
							end
					else if(x_pos >=475 && x_pos < 495&&
					   y_pos >=200 && y_pos < 220)begin
							rgb=bound_color;
							end
					else if(x_pos >=475 && x_pos < 495&&
					   y_pos >=240 && y_pos < 260)begin
							rgb=bound_color;
							end
					else if(x_pos >=475 && x_pos < 495&&
					   y_pos >=280 && y_pos < 300)begin
							rgb=bound_color;
							end
					else if(x_pos >=475 && x_pos < 495&&
					   y_pos >=320 && y_pos < 340)begin
							rgb=bound_color;
							end
					else if(x_pos >=475 && x_pos < 495&&
					   y_pos >=360 && y_pos < 380)begin
							rgb=bound_color;
							end
					else if(x_pos >=475 && x_pos < 495&&
					   y_pos >=400 && y_pos < 420)begin
							rgb=bound_color;
							end
					else if(x_pos >=475 && x_pos < 495&&
					   y_pos >=440 && y_pos < 460)begin
							rgb=bound_color;
							end
					else if(x_pos >=475 && x_pos < 495&&
					   y_pos >=480 && y_pos < 500)begin
							rgb=bound_color;
							end
					else
				   rgb = track_color;
					
					
						  end
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
		      y_pos >= 0 && y_pos < 500)begin
		  
					  if(x_pos >=475 && x_pos < 495&&
					   y_pos >=0 && y_pos < 20)begin
							rgb=bound_color;
							end
					  else if(x_pos >=475 && x_pos < 495&&
					   y_pos >=40 && y_pos < 60)begin
							rgb=bound_color;
							end
					 else if(x_pos >=475 && x_pos < 495&&
					   y_pos >=80 && y_pos < 100)begin
							rgb=bound_color;
							end
					 else if(x_pos >=475 && x_pos < 495&&
					   y_pos >=120 && y_pos < 140)begin
							rgb=bound_color;
							end
					 else if(x_pos >=475 && x_pos < 495&&
					   y_pos >=160 && y_pos < 180)begin
							rgb=bound_color;
							end
					else if(x_pos >=475 && x_pos < 495&&
					   y_pos >=200 && y_pos < 220)begin
							rgb=bound_color;
							end
					else if(x_pos >=475 && x_pos < 495&&
					   y_pos >=240 && y_pos < 260)begin
							rgb=bound_color;
							end
					else if(x_pos >=475 && x_pos < 495&&
					   y_pos >=280 && y_pos < 300)begin
							rgb=bound_color;
							end
					else if(x_pos >=475 && x_pos < 495&&
					   y_pos >=320 && y_pos < 340)begin
							rgb=bound_color;
							end
					else if(x_pos >=475 && x_pos < 495&&
					   y_pos >=360 && y_pos < 380)begin
							rgb=bound_color;
							end
					else if(x_pos >=475 && x_pos < 495&&
					   y_pos >=400 && y_pos < 420)begin
							rgb=bound_color;
							end
					else if(x_pos >=475 && x_pos < 495&&
					   y_pos >=440 && y_pos < 460)begin
							rgb=bound_color;
							end
					else if(x_pos >=475 && x_pos < 495&&
					   y_pos >=480 && y_pos < 500)begin
							rgb=bound_color;
							end
					else
				   rgb = track_color;
					
						   end
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
