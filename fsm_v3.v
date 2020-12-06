module fsm_v3 (clock, reset, opcode, flags, pc_en, regfile_en, we_a, alu_mux, ls_ctrl, ir_en, flags_en, pc_mux, j_en, button_mux, accel_mux);

input clock, reset;
input [15:0] opcode;
input [4:0] flags;

reg [3:0] current_state, next_state;

output reg pc_en, regfile_en, we_a, alu_mux, ls_ctrl, ir_en, flags_en, pc_mux, j_en;

output button_mux, accel_mux;

parameter [3:0]
 s0 = 4'b0000,
 s1 = 4'b0001,
 s2 = 4'b0010,
 s3 = 4'b0011,
 s4 = 4'b0100,
 s5 = 4'b0101,
 s6 = 4'b0110,
 s7 = 4'b0111,
 s8 = 4'b1000,
 s9 = 4'b1001,
 s10 = 4'b1010,
 s11 = 4'b1011,
 s12 = 4'b1100,
 s13 = 4'b1101,
 s14 = 4'b1110,
 s15 = 4'b1111;

assign button_mux = (current_state == s9) ? 1'b1 : 1'b0;
assign accel_mux = (current_state == s10) ? 1'b1 : 1'b0;

always @(posedge clock, negedge reset) begin

	if (reset == 0) current_state <= s15;
	else current_state <= next_state;

end

always @(current_state, flags, opcode) begin
	$display("State: %d, Flags: %b, Opcode: %h", current_state, flags, opcode);
	case(current_state)
		s0: next_state = s1;
		s1: begin
			casex({opcode[15:12], opcode[7:4]})
				8'b0100_0000: next_state = s4; // LOAD
				8'b0100_0100: next_state = s3; // STORE
				8'b0000_0000: next_state = s15; // WAIT
				8'b0000_0100: next_state = s9; // STR BUTTON
				8'b0000_1000: next_state = s10; // STR ACCEL
				8'b1100_xxxx: begin // BRANCH
					case(opcode[11:8])
						// Flag[4] - Carry Flag - C
						// Flag[3] - Low Flag - L
						// Flag[2] - Flag Bit - F
						// Flag[1] - Z Bit - Z
						// Flag[0] - Negative Bit - N
						4'b0000: begin if(flags[1]) next_state = s7; else next_state = s6; end // Equal, Z = 1
						4'b0001: begin if(~flags[1]) next_state = s7; else next_state = s6; end // Not Equal, Z = 0
						4'b1101: begin if(flags[0] | flags[1]) next_state = s7; else next_state = s6; end // Greater than or Equal, N = 1 or Z = 1
						4'b0010: begin if(flags[4]) next_state = s7; else next_state = s6; end // Carry Set, C = 1
						4'b0011: begin if(~flags[4]) next_state = s7; else next_state = s6; end // Carry Clear, C = 0
						4'b0100: begin if(flags[3]) next_state = s7; else next_state = s6; end // Higher than, L = 1
						4'b0101: begin if(~flags[3]) next_state = s7; else next_state = s6; end // Lower than or same as, L = 0
						4'b1010: begin if(~flags[3] & ~flags[1]) next_state = s7; else next_state = s6; end // Lower than, L = 0 and Z = 0
						4'b1011: begin if(flags[3] | flags[1]) next_state = s7; else next_state = s6; end // Higher than or same as, L = 1 or Z = 1
						4'b0110: begin if(flags[0]) next_state = s7; else next_state = s6; end // Greater than, N = 1
						4'b0111: begin if(~flags[0]) next_state = s7; else next_state = s6; end // Less than or equal, N = 0
						4'b1000: begin if(flags[2]) next_state = s7; else next_state = s6; end // Flag set, F = 1
						4'b1001: begin if(~flags[2]) next_state = s7; else next_state = s6; end // Flag clear, F = 0
						4'b1100: begin if(~flags[0] & ~flags[1]) next_state = s7; else next_state = s6; end // Less than, N = 0 and Z = 0
						4'b1110: next_state = s7; // Unconditional
						4'b1111: next_state = s6; // Never Jump
					endcase
				end
				8'b0100_1100: begin // JUMP
					case(opcode[11:8])
						// Flag[4] - Carry Flag - C
						// Flag[3] - Low Flag - L
						// Flag[2] - Flag Bit - F
						// Flag[1] - Z Bit - Z
						// Flag[0] - Negative Bit - N
						4'b0000: begin if(flags[1]) next_state = s8; else next_state = s6; end // Equal, Z = 1
						4'b0001: begin if(~flags[1]) next_state = s8; else next_state = s6; end // Not Equal, Z = 0
						4'b1101: begin if(flags[0] | flags[1]) next_state = s8; else next_state = s6; end // Greater than or Equal, N = 1 or Z = 1
						4'b0010: begin if(flags[4]) next_state = s8; else next_state = s6; end // Carry Set, C = 1
						4'b0011: begin if(~flags[4]) next_state = s8; else next_state = s6; end // Carry Clear, C = 0
						4'b0100: begin if(flags[3]) next_state = s8; else next_state = s6; end // Higher than, L = 1
						4'b0101: begin if(~flags[3]) next_state = s8; else next_state = s6; end // Lower than or same as, L = 0
						4'b1010: begin if(~flags[3] & ~flags[1]) next_state = s8; else next_state = s6; end // Lower than, L = 0 and Z = 0
						4'b1011: begin if(flags[3] | flags[1]) next_state = s8; else next_state = s6; end // Higher than or same as, L = 1 or Z = 1
						4'b0110: begin if(flags[0]) next_state = s8; else next_state = s6; end // Greater than, N = 1
						4'b0111: begin if(~flags[0]) next_state = s8; else next_state = s6; end // Less than or equal, N = 0
						4'b1000: begin if(flags[2]) next_state = s8; else next_state = s6; end // Flag set, F = 1
						4'b1001: begin if(~flags[2]) next_state = s8; else next_state = s6; end // Flag clear, F = 0
						4'b1100: begin if(~flags[0] & ~flags[1]) next_state = s8; else next_state = s6; end // Less than, N = 0 and Z = 0
						4'b1110: next_state = s8; // Unconditional
						4'b1111: next_state = s6; // Never Jump
					endcase
					//8'b0100_1000: ; // JUMP and LINK
				end
				default: next_state = s2; // RTYPES and ITYPES
			endcase
		end
		s2: next_state = s15;
		s3: next_state = s15;
		s4: next_state = s5;
		s5: next_state = s15;
		s6: next_state = s15;
		s7: next_state = s15;
		s8: next_state = s15;
		s9: next_state = s15;
		s10: next_state = s15;
		s15: next_state = s0;
		default: next_state = s15;
	endcase

end

always @(current_state) begin

	case(current_state)
		s15: begin // WAIT FOR MEMORY
			pc_en = 0;
			regfile_en = 0;
			we_a = 0;
			alu_mux = 0;
			ls_ctrl = 0;
			ir_en = 0;
			flags_en = 0;
			pc_mux = 0;
			j_en = 0;
		end
		s0: begin // FETCH
			pc_en = 0;
			regfile_en = 0;
			we_a = 0;
			alu_mux = 0;
			ls_ctrl = 0;
			ir_en = 1;
			flags_en = 0;
			pc_mux = 0;
			j_en = 0;
		end
		s1: begin // DECODE
			pc_en = 0;
			regfile_en = 0;
			we_a = 0;
			alu_mux = 0;
			ls_ctrl = 0;
			ir_en = 0;
			flags_en = 0;
			pc_mux = 0;
			j_en = 0;
		end
		s2: begin // R/I TYPE
			pc_en = 1;
			regfile_en = 1;
			we_a = 0;
			alu_mux = 0;
			ls_ctrl = 0;
			ir_en = 0;
			flags_en = 1;
			pc_mux = 0;
			j_en = 0;
		end
		s3: begin // STORE
			pc_en = 1;
			regfile_en = 0;
			we_a = 1;
			alu_mux = 0;
			ls_ctrl = 1;
			ir_en = 0;
			flags_en = 0;
			pc_mux = 0;
			j_en = 0;
			end
		s4: begin // LOAD PART 1
			pc_en = 0;
			regfile_en = 0;
			we_a = 0;
			alu_mux = 0;
			ls_ctrl = 1;
			ir_en = 0;
			flags_en = 0;
			pc_mux = 0;
			j_en = 0;
		end
		s5: begin // LOAD PART 2
			pc_en = 1;
			regfile_en = 1;
			we_a = 0;
			alu_mux = 1;
			ls_ctrl = 0;
			ir_en = 0;
			flags_en = 0;
			pc_mux = 0;
			j_en = 0;
		end
		s6: begin // FAILED BRANCH/JUMP
			pc_en = 1;
			regfile_en = 0;
			we_a = 0;
			alu_mux = 0;
			ls_ctrl = 0;
			ir_en = 0;
			flags_en = 0;
			pc_mux = 0;
			j_en = 0;
		end
		s7: begin // SUCCESSFUL BRANCH
			pc_en = 1;
			regfile_en = 0;
			we_a = 0;
			alu_mux = 0;
			ls_ctrl = 0;
			ir_en = 0;
			flags_en = 0;
			pc_mux = 1;
			j_en = 0;
		end
		s8: begin // SUCCESSFUL JUMP
			pc_en = 0;
			regfile_en = 0;
			we_a = 0;
			alu_mux = 0;
			ls_ctrl = 0;
			ir_en = 0;
			flags_en = 0;
			pc_mux = 0;
			j_en = 1;
		end
		s9: begin // STORE BUTTON
			pc_en = 1;
			regfile_en = 1;
			we_a = 0;
			alu_mux = 0;
			ls_ctrl = 0;
			ir_en = 0;
			flags_en = 0;
			pc_mux = 0;
			j_en = 0;
		end
		s10: begin // STORE ACCEL
			pc_en = 1;
			regfile_en = 1;
			we_a = 0;
			alu_mux = 0;
			ls_ctrl = 0;
			ir_en = 0;
			flags_en = 0;
			pc_mux = 0;
			j_en = 0;
		end
	endcase
	
end

endmodule








