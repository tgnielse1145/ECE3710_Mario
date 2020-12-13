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
	input [31:0] timer,
	output reg [23:0] rgb
	
);

wire [9:0] x_pos, y_pos;
assign x_pos = hcount;
assign y_pos = vcount;
localparam STRIP_COLOR = 24'hFFFF00; 
reg counter =0;


always @(bright, pixel, bg_color, grid_color, track_color, bound_color, pix_en, x_pos, y_pos) begin

if (bright) begin
	
	// check if valid pixel even sent
	if (pix_en) begin			
		
		// check for transparency bit -- h000000
		if (pixel == 24'h000000)begin
            if(timer <= 100)begin
				if(x_pos >= 300 && x_pos < 650 &&
				   y_pos >= 0 && y_pos < 500)begin
					
					if(timer % 2 == 0)begin					
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
					
					end // end for if(timer %2 ==0)
					
					else if(timer %2 !=0 ) begin
						if(x_pos >=475 && x_pos < 495&&
					        y_pos >=20 && y_pos < 40)begin
							//rgb=bound_color;
							rgb=STRIP_COLOR;
							end
					    else if(x_pos >=475 && x_pos < 495&&
					        y_pos >=60 && y_pos < 80)begin
							//rgb=bound_color;
							rgb=STRIP_COLOR;
							end
					    else if(x_pos >=475 && x_pos < 495&&
					        y_pos >=100 && y_pos < 120)begin
							//rgb=bound_color;
							rgb=STRIP_COLOR;
							end
					    else if(x_pos >=475 && x_pos < 495&&
					        y_pos >=140 && y_pos < 160)begin
							//rgb=bound_color;
							rgb=STRIP_COLOR;
							end
					    else if(x_pos >=475 && x_pos < 495&&
					        y_pos >=180 && y_pos < 200)begin
							//rgb=bound_color;
							rgb=STRIP_COLOR;
							end
					    else if(x_pos >=475 && x_pos < 495&&
					        y_pos >=220 && y_pos < 240)begin
							//rgb=bound_color;
							rgb=STRIP_COLOR;
							end
					    else if(x_pos >=475 && x_pos < 495&&
					        y_pos >=260 && y_pos < 280)begin
							//rgb=bound_color;
							rgb=STRIP_COLOR;
							end
					    else if(x_pos >=475 && x_pos < 495&&
					        y_pos >=300 && y_pos < 320)begin
							//rgb=bound_color;
							rgb=STRIP_COLOR;
							end
					    else if(x_pos >=475 && x_pos < 495&&
					        y_pos >=340 && y_pos < 360)begin
							//rgb=bound_color;
							rgb=STRIP_COLOR;
							end
					    else if(x_pos >=475 && x_pos < 495&&
					        y_pos >=380 && y_pos < 400)begin
							//rgb=bound_color;
							rgb=STRIP_COLOR;
							end
					    else if(x_pos >=475 && x_pos < 495&&
					        y_pos >=420 && y_pos < 440)begin
							//rgb=bound_color;
							rgb=STRIP_COLOR;
							end
					    else if(x_pos >=475 && x_pos < 495&&
					        y_pos >=460 && y_pos < 480)begin
							//rgb=bound_color;
							rgb=STRIP_COLOR;
							end

					    else
				            rgb = track_color;
					        end // end for if(timer %2 !=0)
					end // end for x_pos >= 300
				else if(x_pos >= 280 && x_pos < 300 &&
						  y_pos >= 0 && y_pos < 500)
						  rgb = bound_color;						  
				else if(x_pos >= 650 && x_pos < 670 &&
						  y_pos >= 0 && y_pos < 500)
						  rgb = bound_color;
                else
					rgb = bg_color;	

                end // end for if (timer <=100)	

                else if(timer > 100)begin
                    if(x_pos >= 300 && x_pos < 650 &&
							  y_pos >= 0 && y_pos < 500)begin
					
					if(timer % 2 == 0)begin					
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
					
					end // end for if(timer %2 ==0)
					
					else if(timer %2 !=0 ) begin
						if(x_pos >=475 && x_pos < 495&&
					        y_pos >=20 && y_pos < 40)begin
							//rgb=bound_color;
							rgb=STRIP_COLOR;
							end
					    else if(x_pos >=475 && x_pos < 495&&
					        y_pos >=60 && y_pos < 80)begin
							//rgb=bound_color;
							rgb=STRIP_COLOR;
							end
					    else if(x_pos >=475 && x_pos < 495&&
					        y_pos >=100 && y_pos < 120)begin
							//rgb=bound_color;
							rgb=STRIP_COLOR;
							end
					    else if(x_pos >=475 && x_pos < 495&&
					        y_pos >=140 && y_pos < 160)begin
							//rgb=bound_color;
							rgb=STRIP_COLOR;
							end
					    else if(x_pos >=475 && x_pos < 495&&
					        y_pos >=180 && y_pos < 200)begin
							//rgb=bound_color;
							rgb=STRIP_COLOR;
							end
					    else if(x_pos >=475 && x_pos < 495&&
					        y_pos >=220 && y_pos < 240)begin
							//rgb=bound_color;
							rgb=STRIP_COLOR;
							end
					    else if(x_pos >=475 && x_pos < 495&&
					        y_pos >=260 && y_pos < 280)begin
							//rgb=bound_color;
							rgb=STRIP_COLOR;
							end
					    else if(x_pos >=475 && x_pos < 495&&
					        y_pos >=300 && y_pos < 320)begin
							//rgb=bound_color;
							rgb=STRIP_COLOR;
							end
					    else if(x_pos >=475 && x_pos < 495&&
					        y_pos >=340 && y_pos < 360)begin
							//rgb=bound_color;
							rgb=STRIP_COLOR;
							end
					    else if(x_pos >=475 && x_pos < 495&&
					        y_pos >=380 && y_pos < 400)begin
							//rgb=bound_color;
							rgb=STRIP_COLOR;
							end
					    else if(x_pos >=475 && x_pos < 495&&
					        y_pos >=420 && y_pos < 440)begin
							//rgb=bound_color;
							rgb=STRIP_COLOR;
							end
					    else if(x_pos >=475 && x_pos < 495&&
					        y_pos >=460 && y_pos < 480)begin
							//rgb=bound_color;
							rgb=STRIP_COLOR;
							end

					    else
				            rgb = track_color;
					        end // end for if(timer %2 !=0)
					end // end for x_pos >= 300
				else if(x_pos >= 280 && x_pos < 300 &&
						  y_pos >= 0 && y_pos < 500)
						  rgb = bound_color;						  
				else if(x_pos >= 650 && x_pos < 670 &&
						  y_pos >= 0 && y_pos < 500)
						  rgb = bound_color;
                else
					rgb = bg_color;

                end // end for if (timer > 100 )

            end// end for if(pixel= 24'h000000)
			else // else for if(pixel== 24'h000000)
            begin
				rgb = pixel;
            end // for else after if(pixel == 24'h000000)
				
		end // end for if pix_en
		
	else // else for if pix_en
    begin // for else after if pix_en
        if(timer <= 100)begin
            if(x_pos >= 300 && x_pos < 650 &&
		      y_pos >= 0 && y_pos < 500)begin		  
					if(timer % 2 == 0)begin					
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
					
				end // end for if(timer %2 ==0) 
					
					else if(timer % 2 != 0) begin
						if(x_pos >=475 && x_pos < 495&&
					        y_pos >=20 && y_pos < 40)begin
							//rgb=bound_color;
							rgb=STRIP_COLOR;
							end
					    else if(x_pos >=475 && x_pos < 495&&
					        y_pos >=60 && y_pos < 80)begin
							//rgb=bound_color;
							rgb=STRIP_COLOR;
							end
					    else if(x_pos >=475 && x_pos < 495&&
					        y_pos >=100 && y_pos < 120)begin
							//rgb=bound_color;
							rgb=STRIP_COLOR;
							end
					    else if(x_pos >=475 && x_pos < 495&&
					         y_pos >=140 && y_pos < 160)begin
							//rgb=bound_color;
							rgb=STRIP_COLOR;
							end
					    else if(x_pos >=475 && x_pos < 495&&
					        y_pos >=180 && y_pos < 200)begin
							//rgb=bound_color;
							rgb=STRIP_COLOR;
							end
					    else if(x_pos >=475 && x_pos < 495&&
					        y_pos >=220 && y_pos < 240)begin
							//rgb=bound_color;
							rgb=STRIP_COLOR;
							end
					    else if(x_pos >=475 && x_pos < 495&&
					        y_pos >=260 && y_pos < 280)begin
							//rgb=bound_color;
							rgb=STRIP_COLOR;
							end
					    else if(x_pos >=475 && x_pos < 495&&
					        y_pos >=300 && y_pos < 320)begin
							//rgb=bound_color;
							rgb=STRIP_COLOR;
							end
					    else if(x_pos >=475 && x_pos < 495&&
					        y_pos >=340 && y_pos < 360)begin
							//rgb=bound_color;
							rgb=STRIP_COLOR;
							end
					    else if(x_pos >=475 && x_pos < 495&&
					        y_pos >=380 && y_pos < 400)begin
							//rgb=bound_color;
							rgb=STRIP_COLOR;
							end
					    else if(x_pos >=475 && x_pos < 495&&
					        y_pos >=420 && y_pos < 440)begin
							//rgb=bound_color;
							rgb=STRIP_COLOR;
							end
					    else if(x_pos >=475 && x_pos < 495&&
					        y_pos >=460 && y_pos < 480)begin
							//rgb=bound_color;
							rgb=STRIP_COLOR;
							end
					    else
				            rgb = track_color;
					end // end for if(timer %2 != 0)
					
				end // end for x_pos>=300

		    else if(x_pos >= 280 && x_pos < 300 &&
					  y_pos >= 0 && y_pos < 500)
					  rgb = bound_color;
					  
			else if(x_pos >= 650 && x_pos < 670 &&
					  y_pos >= 0 && y_pos < 500)
					  rgb = bound_color;	
			  
			else rgb = bg_color;
			
        
            end // end for if(time <=100)

            if(timer > 100)begin
                if(x_pos >= 300 && x_pos < 650 &&
				   y_pos >= 0 && y_pos < 500)begin
					
					if(timer % 2 == 0)begin					
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
					
					end // end for if(timer %2 ==0)
					
					else if(timer %2 !=0 ) begin
						if(x_pos >=475 && x_pos < 495&&
					        y_pos >=20 && y_pos < 40)begin
							//rgb=bound_color;
							rgb=STRIP_COLOR;
							end
					    else if(x_pos >=475 && x_pos < 495&&
					        y_pos >=60 && y_pos < 80)begin
							//rgb=bound_color;
							rgb=STRIP_COLOR;
							end
					    else if(x_pos >=475 && x_pos < 495&&
					        y_pos >=100 && y_pos < 120)begin
							//rgb=bound_color;
							rgb=STRIP_COLOR;
							end
					    else if(x_pos >=475 && x_pos < 495&&
					        y_pos >=140 && y_pos < 160)begin
							//rgb=bound_color;
							rgb=STRIP_COLOR;
							end
					    else if(x_pos >=475 && x_pos < 495&&
					        y_pos >=180 && y_pos < 200)begin
							//rgb=bound_color;
							rgb=STRIP_COLOR;
							end
					    else if(x_pos >=475 && x_pos < 495&&
					        y_pos >=220 && y_pos < 240)begin
							//rgb=bound_color;
							rgb=STRIP_COLOR;
							end
					    else if(x_pos >=475 && x_pos < 495&&
					        y_pos >=260 && y_pos < 280)begin
							//rgb=bound_color;
							rgb=STRIP_COLOR;
							end
					    else if(x_pos >=475 && x_pos < 495&&
					        y_pos >=300 && y_pos < 320)begin
							//rgb=bound_color;
							rgb=STRIP_COLOR;
							end
					    else if(x_pos >=475 && x_pos < 495&&
					        y_pos >=340 && y_pos < 360)begin
							//rgb=bound_color;
							rgb=STRIP_COLOR;
							end
					    else if(x_pos >=475 && x_pos < 495&&
					        y_pos >=380 && y_pos < 400)begin
							//rgb=bound_color;
							rgb=STRIP_COLOR;
							end
					    else if(x_pos >=475 && x_pos < 495&&
					        y_pos >=420 && y_pos < 440)begin
							//rgb=bound_color;
							rgb=STRIP_COLOR;
							end
					    else if(x_pos >=475 && x_pos < 495&&
					        y_pos >=460 && y_pos < 480)begin
							//rgb=bound_color;
							rgb=STRIP_COLOR;
							end

					    else
				            rgb = track_color;
					        end // end for if(timer %2 !=0)
					end // end for x_pos >= 300
				else if(x_pos >= 280 && x_pos < 300 &&
						  y_pos >= 0 && y_pos < 500)
						  rgb = bound_color;						  
				else if(x_pos >= 650 && x_pos < 670 &&
						  y_pos >= 0 && y_pos < 500)
						  rgb = bound_color;
                else
					rgb = bg_color;

            end// end for if(timer>100)
        end // for begin after else that's after if pix_en
		
	end // end for if (bright)
	
	// can't actually display anything
	else // else for if(bright)
    
    rgb = 0;

end //end for always statement

endmodule
