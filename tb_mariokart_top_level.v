`timescale 1ps/1ps
module tb_mariokart_top_level;

reg clock, reset;
wire vga_clk, vga_blank_n, vga_vs, vga_hs;
wire [7:0] r, g, b;

mariokart_top_level uut(
.clock(clock),
.reset(reset), 
.vga_clk(vga_clk),
.vga_blank_n(vga_blank_n),
.vga_vs(vga_vs),
.vga_hs(vga_hs),
.r(r),
.g(g),
.b(b)
	);
//glyph_vga uut(
//	clk, resetn,
//	vga_clk, vga_blank_n, vga_vs, vga_hs,
//	r, g, b
//);

initial begin
	clock = 0;
	reset = 1; #2;
	reset = 0; #10;
	reset = 1; #10;
end

always #5 clock = ~clock;

endmodule
