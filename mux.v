module mux(A,B,out,mux_cntl);
	input [15:0] A, B;
	input mux_cntl;
	output reg [15:0] out;
	
	always @(*) begin
		if(mux_cntl == 1) out = B;
		else out = A;
	end
	
endmodule
