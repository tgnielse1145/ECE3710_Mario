`timescale 1ps/1ps
module tb_mariokart_top_level;

reg clock, reset, up_button, down_button, left_button, right_button;
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
.b(b),
.up_button(up_button),
.down_button(down_button),
.left_button(left_button),
.right_button(right_button)
);

//glyph_vga uut(
//	clk, resetn,
//	vga_clk, vga_blank_n, vga_vs, vga_hs,
//	r, g, b
//);

initial begin
	clock = 0; up_button = 0; down_button = 0; left_button = 0; right_button = 0;
	reset = 1; #2;
	reset = 0; #10;
	reset = 1; #10;
end

always #5 clock = ~clock;

endmodule
