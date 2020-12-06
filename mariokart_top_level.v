module mariokart_top_level (

input clock, reset, up_button, down_button, left_button, right_button,
output vga_clk, vga_blank_n, vga_vs, vga_hs,
output [7:0] r, g, b

);

wire clock50Hz;
clock_divider divider1(.clock50mHz(clock), .reset(reset), .enable(1'b1), .clock50Hz(clock50Hz));
wire [15:0] sys_data;
wire [15:0] sys_addr;
wire [15:0] alu_bus;
wire [4:0] flags;
wire [15:0] addr,  a_in, b_in, opcode, button_in, accel_in;
wire ls_ctrl, flags_en, regfile_en, alu_mux, pc_en, ir_en, pc_mux, j_en, button_mux, accel_mux;

assign button_in[15:2] = 14'd0;
assign button_in[1] = ~up_button;
assign button_in[0] = ~down_button;

assign accel_in[15] = ~left_button;
assign accel_in[14:0] = ~$signed(right_button);

localparam SYS_DATA_WIDTH=16, SYS_ADDR_WIDTH=16;
localparam GLYPH_DATA_WIDTH=24, GLYPH_ADDR_WIDTH=14;


wire [(SYS_DATA_WIDTH-1):0] data_a, data_b, q_a, q_b;
wire [(SYS_ADDR_WIDTH-1):0] addr_a, addr_b;
wire we_a, we_b;

assign we_b = 1'b0;
assign data_b = 'b0;

defparam vga.SYS_DATA_WIDTH = SYS_DATA_WIDTH;
defparam vga.SYS_ADDR_WIDTH = SYS_ADDR_WIDTH;
defparam vga.GLYPH_DATA_WIDTH = GLYPH_DATA_WIDTH;
defparam vga.GLYPH_ADDR_WIDTH = GLYPH_ADDR_WIDTH;
localparam COUNT = 12500000;	// 500 sec


vga vga (
	.clk(clock),
   .reset(~reset),									
	.sys_data(q_b),   
	.vga_clk(vga_clk),
	.vga_blank_n(vga_blank_n),
	.vga_vs(vga_vs),
   .vga_hs(vga_hs),	
	.r(r),
	.g(g),
	.b(b),											
	.sys_addr(addr_b)
);


defparam ram.DATA_WIDTH = SYS_DATA_WIDTH;
defparam ram.ADDR_WIDTH = SYS_ADDR_WIDTH;

bram ram (
	.data_a(a_in),
	.data_b(data_b),	
	.addr_a(addr_a),
	.addr_b(addr_b),	
	.we_a(we_a),
	.we_b(we_b),
	.clk(clock),	
	.q_a(q_a),
	.q_b(q_b)				
);

program_counter pc1(
	.clock(clock),
	.reset(reset),
	.pc_en(pc_en),
	.addr(addr),
	.pc_mux(pc_mux),
	.disp(opcode[7:0]),
	.j_en(j_en),
	.dest(b_in)
);

assign addr_a = ls_ctrl ? b_in : addr;

datapath dp1(
	.clock(clock),
	.reset(reset),
	.flags_en(flags_en),
	.regfile_en(regfile_en),
	.alu_mux(alu_mux),
	.opcode(opcode),
	.mem_in(q_a),
	.flags_out(flags),
	.alu_bus(alu_bus),
	.a_in(a_in),
	.b_in(b_in),
	.button_mux(button_mux),
	.accel_mux(accel_mux),
	.button_in(button_in),
	.accel_in(accel_in)
);

register instruction_register(
	.A(q_a),
	.B(opcode),
	.clock(clock),
	.en(ir_en),
	.reset(reset)
);


fsm_v3 decoder(
	.clock(clock),
	.reset(reset),
	.opcode(opcode),
	.flags(flags),
	.pc_en(pc_en),
	.regfile_en(regfile_en),
	.we_a(we_a),
	.alu_mux(alu_mux),
	.ls_ctrl(ls_ctrl),
	.ir_en(ir_en),
	.flags_en(flags_en),
	.pc_mux(pc_mux),
	.j_en(j_en),
	.button_mux(button_mux),
	.accel_mux(accel_mux)
);

endmodule
