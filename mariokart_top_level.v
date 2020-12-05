module mariokart_top_level (

input clock, reset,
output vga_clk, vga_blank_n, vga_vs, vga_hs,
output [7:0] r, g, b

);
//wire clock1hz;
//clock_divider divider1(.clock50mHz(clock50mHz), .reset(reset), .enable(1'b1), .clock1Hz(clock1Hz));
wire [15:0] sys_data;
wire[15:0] sys_addr;
wire[15:0]button_in;
wire[15:0] accel_in;

wire [15:0] alu_bus;
wire [4:0] flags;
wire [15:0] addr,  a_in, b_in, opcode;
wire ls_ctrl, flags_en, regfile_en, alu_mux, pc_en, ir_en, pc_mux, j_en,button_mux, accel_mux;

localparam SYS_DATA_WIDTH=16, SYS_ADDR_WIDTH=16;
localparam GLYPH_DATA_WIDTH=24, GLYPH_ADDR_WIDTH=14;


wire [(SYS_DATA_WIDTH-1):0] data_a, data_b;
wire [(SYS_ADDR_WIDTH-1):0] addr_a, addr_b, q_a, q_b;
wire we_a, we_b;


defparam vga.SYS_DATA_WIDTH = SYS_DATA_WIDTH;
defparam vga.SYS_ADDR_WIDTH = SYS_ADDR_WIDTH;
defparam vga.GLYPH_DATA_WIDTH = GLYPH_DATA_WIDTH;
defparam vga.GLYPH_ADDR_WIDTH = GLYPH_ADDR_WIDTH;
localparam COUNT = 12500000;	// 500 sec



vga vga (
	.clk(clock),
   .reset(~reset),									
	.sys_data(a_in),   
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
	.button_in(button_in),
   .accel_in(accel_in),
	.button_mux(button_mux),
   .accel_mux(accel_mux)

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
	.j_en(j_en)
);

endmodule
