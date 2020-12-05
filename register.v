module register(A,B,clock,en,reset);
	input [15:0] A;
	input reset, clock, en;
	output reg [15:0] B;
	
	always @(posedge clock, negedge reset) begin
		// Based on push button for reset - if button down is +Vcc, then change to posedge and rst == 1, else if button down is gnd, keep the way it is
		if (reset == 0) B <= 0;
		else if (en == 1) B <= A;
		else B <= B;
		
	end
	
endmodule


/* A parameterized-width positive-edge-trigged register, with synchronous reset. 
   The value to take on after a reset is the 2nd parameter. */
/* module 16bit_reg(in, out, clock, we, gwe, reset);
   parameter n = 1;
   parameter r = 0;
   
   output [15:0] out;
   input [15:0]  in;   
   input clock,we,gwe,reset;
     
   reg [15:0] state;

   assign #(1) out = state;

   always @(posedge clk) 
     begin 
       if (gwe & rst) 
         state = r;
       else if (gwe & we) 
         state = in; 
     end
endmodule
*/
