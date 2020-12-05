module program_counter(clock, reset, pc_en, pc_mux, addr, disp, j_en, dest);

input clock, reset, pc_en, pc_mux, pc_mux, j_en;
input [7:0] disp;
input [15:0] dest;
wire [15:0] increment;
output reg[15:0] addr;

assign increment = pc_mux ? $signed(disp) : 1;

always @(posedge clock, negedge reset) begin

	$display("Addr: %h, Dest: %h, j_en: %b, Increment: %d, pc_en: %b", addr, dest, j_en, $signed(increment), pc_en);
	
	if (reset == 1'b0) addr <= 1'b0;
	else if (j_en == 1) addr <= dest;
	else if (pc_en == 1) addr <= addr + $signed(increment);
	else addr = addr;
	
end

endmodule