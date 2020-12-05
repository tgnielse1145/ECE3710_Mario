module datapath(clock, reset, flags_en, regfile_en, alu_mux, opcode, mem_in, flags_out, alu_bus, a_in, b_in, button_mux, accel_mux, button_in, accel_in);

input clock, reset, flags_en, regfile_en, alu_mux, button_mux, accel_mux;
input [15:0] opcode, mem_in, button_in, accel_in;

output reg [4:0] flags_out;
output reg [15:0] alu_bus;

output reg [15:0] a_in, b_in;

reg [15:0] b_in0, r_en;

wire [4:0] flags_in;
wire [15:0] c, r_out0, r_out1, r_out2, r_out3, r_out4, r_out5, r_out6, r_out7, r_out8, r_out9, r_out10, r_out11, r_out12, r_out13, r_out14, r_out15;

register r15 (alu_bus, r_out15, clock, r_en[15], reset);
register r14 (alu_bus, r_out14, clock, r_en[14], reset);
register r13 (alu_bus, r_out13, clock, r_en[13], reset);
register r12 (alu_bus, r_out12, clock, r_en[12], reset);
register r11 (alu_bus, r_out11, clock, r_en[11], reset);
register r10 (alu_bus, r_out10, clock, r_en[10], reset);
register r9 (alu_bus, r_out9, clock, r_en[9], reset);
register r8 (alu_bus, r_out8, clock, r_en[8], reset);
register r7 (alu_bus, r_out7, clock, r_en[7], reset);
register r6 (alu_bus, r_out6, clock, r_en[6], reset);
register r5 (alu_bus, r_out5, clock, r_en[5], reset);
register r4 (alu_bus, r_out4, clock, r_en[4], reset);
register r3 (alu_bus, r_out3, clock, r_en[3], reset);
register r2 (alu_bus, r_out2, clock, r_en[2], reset);
register r1 (alu_bus, r_out1, clock, r_en[1], reset);
register r0 (alu_bus, r_out0, clock, r_en[0], reset);

//xxxx <- Opcode xxxx <- R_dest xxxx <- Op_ext xxxx <- R_src

// Decoder
always @(opcode, regfile_en) begin
	
	if (regfile_en == 1'b0) r_en = 16'b0000000000000000;
	else begin
	
		case (opcode[11:8])
			4'b0000: r_en = 16'b0000000000000001;
			4'b0001: r_en = 16'b0000000000000010;
			4'b0010: r_en = 16'b0000000000000100;
			4'b0011: r_en = 16'b0000000000001000;
			4'b0100: r_en = 16'b0000000000010000;
			4'b0101: r_en = 16'b0000000000100000;
			4'b0110: r_en = 16'b0000000001000000;
			4'b0111: r_en = 16'b0000000010000000;
			4'b1000: r_en = 16'b0000000100000000;
			4'b1001: r_en = 16'b0000001000000000;
			4'b1010: r_en = 16'b0000010000000000;
			4'b1011: r_en = 16'b0000100000000000;
			4'b1100: r_en = 16'b0001000000000000;
			4'b1101: r_en = 16'b0010000000000000;
			4'b1110: r_en = 16'b0100000000000000;
			4'b1111: r_en = 16'b1000000000000000;
		endcase
		
	end

end

always @(opcode, r_out0, r_out1, r_out2, r_out3, r_out4, r_out5, r_out6, r_out7, r_out8, r_out9, r_out10, r_out11, r_out12, r_out13, r_out14, r_out15) begin

	case (opcode[11:8])
		4'b0000: a_in = r_out0;
		4'b0001: a_in = r_out1;
		4'b0010: a_in = r_out2;
		4'b0011: a_in = r_out3;
		4'b0100: a_in = r_out4;
		4'b0101: a_in = r_out5;
		4'b0110: a_in = r_out6;
		4'b0111: a_in = r_out7;
		4'b1000: a_in = r_out8;
		4'b1001: a_in = r_out9;
		4'b1010: a_in = r_out10;
		4'b1011: a_in = r_out11;
		4'b1100: a_in = r_out12;
		4'b1101: a_in = r_out13;
		4'b1110: a_in = r_out14;
		4'b1111: a_in = r_out15;
	endcase
	
	case (opcode[3:0])
		4'b0000: b_in0 = r_out0;
		4'b0001: b_in0 = r_out1;
		4'b0010: b_in0 = r_out2;
		4'b0011: b_in0 = r_out3;
		4'b0100: b_in0 = r_out4;
		4'b0101: b_in0 = r_out5;
		4'b0110: b_in0 = r_out6;
		4'b0111: b_in0 = r_out7;
		4'b1000: b_in0 = r_out8;
		4'b1001: b_in0 = r_out9;
		4'b1010: b_in0 = r_out10;
		4'b1011: b_in0 = r_out11;
		4'b1100: b_in0 = r_out12;
		4'b1101: b_in0 = r_out13;
		4'b1110: b_in0 = r_out14;
		4'b1111: b_in0 = r_out15;
	endcase
	
	if (opcode[13] | opcode[12]) b_in = (opcode[7:0]);
	//if (opcode[13] | opcode[12]) b_in = $signed(opcode[7:0]);
	else if (opcode[15] & ~opcode[14] & ~opcode[13] & ~opcode[12] & ~opcode[7] & ~opcode[6]) b_in = opcode[3:0];
	else b_in = b_in0;
	
end

alu alu1(.A(a_in), .B(b_in), .C(c), .Carry_in(flags_out[4]), .Opcode({opcode[15:12], opcode[7:4]}), .Flags(flags_in));


always @(alu_mux, button_mux, accel_mux, button_in, accel_in, mem_in, c) begin
	if (alu_mux == 1) alu_bus = mem_in;
	else if (button_mux == 1) alu_bus = button_in;
	else if (accel_mux == 1) alu_bus = accel_in;
	else alu_bus = c;
end

//assign alu_bus = alu_mux ? mem_in : c; // 0 - Store ALU output, 1 - Store data from memory

always @(negedge reset, posedge clock) begin
	if (reset == 0) flags_out <= 0;
	else if (flags_en == 1) flags_out <= flags_in;
	else flags_out <= flags_out;
end

endmodule