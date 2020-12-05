module alu(A, B, C, Carry_in, Opcode, Flags);

input [15:0] A, B;
// B can be an immediate, depending on the value of the 5th literal in the op-code. An external mux will
// either load register B or an immediate.

input [7:0] Opcode;
input Carry_in;
output reg [15:0] C;
output reg [4:0] Flags;

parameter WAIT    = 8'b00000000;

parameter ADD     = 8'b00000101;
parameter ADDI    = 8'b0101xxxx;

parameter ADDU    = 8'b00000110;
parameter ADDUI   = 8'b0110xxxx;

parameter ADDC    = 8'b00000111;
parameter ADDCI   = 8'b0111xxxx;

parameter SUB     = 8'b00001001;
parameter SUBI    = 8'b1001xxxx;

parameter SUBC    = 8'b00001010;
parameter SUBCI   = 8'b1010xxxx;

parameter CMP     = 8'b00001011;
parameter CMPI    = 8'b1011xxxx;

parameter CMPU    = 8'b00001111;
parameter CMPUI   = 8'b1111xxxx;

parameter AND     = 8'b00000001;
parameter ANDI    = 8'b0001xxxx;

parameter OR      = 8'b00000010;
parameter ORI     = 8'b0010xxxx;

parameter XOR     = 8'b00000011;
parameter XORI    = 8'b0011xxxx;

parameter NOT     = 8'b00000100;
//No good place for NOTI in opcodes, NOT isn't even part of ISA

parameter LSH     = 8'b10000100;
parameter LSHI    = 8'b10000000;
parameter RSH     = 8'b10000101;
parameter RSHI    = 8'b10000001;

parameter ALSH    = 8'b10000110;
parameter ARSH    = 8'b10000111;
parameter ALSHI   = 8'b10000010;
parameter ARSHI   = 8'b10000011;

// Flag[4] - Carry Flag
// Flag[3] - Low Flag
// Flag[2] - Flag Bit
// Flag[1] - Z Bit
// Flag[0] - Negative Bit

always @(A, B, Carry_in, Opcode)
begin
	casex (Opcode)
	
	// Does nothing - CPU FSM stalls upon zeros in memory, may be useful later so as to wait for an interrupt flag given by input devices
	WAIT:
		begin
		Flags[4:0] = 5'b00000;
		C = 0;
		end
		
	ADD, ADDI:
		begin
			{Flags[4], C} = A + B; // Carry Flag
			if (C == 0) Flags[1] = 1'b1;
			else Flags[1] = 1'b0;
			if( (~A[15] & ~B[15] & C[15]) | (A[15] & B[15] & ~C[15]) ) Flags[2] = 1'b1; // Overflow Flag
			else Flags[2] = 1'b0;
			Flags[0] = 1'b0; Flags[4:3] = 2'b00;
			$display("here in the alu in the add section and here is c %d \n ", C);
		end

	ADDU, ADDUI:
		begin
			C = A + B;
			Flags[4:0] = 5'b00000;
		end
		
	ADDC, ADDCI:
		begin
			{Flags[4], C} = A + B + Carry_in; // Carry Flag
			if (C == 0) Flags[1] = 1'b1; 
			else Flags[1] = 1'b0;
			if( (~A[15] & ~B[15] & C[15]) | (A[15] & B[15] & ~C[15]) ) Flags[2] = 1'b1; // Overflow Flag
			else Flags[2] = 1'b0;
			Flags[0] = 1'b0; Flags[4:3] = 2'b00;
		end
		
	SUB, SUBI:
		begin
			{Flags[4], C} = A - B; // Borrow Flag
			if (C == 0) Flags[1] = 1'b1;
			else Flags[1] = 1'b0;
			if( (~A[15] & B[15] & C[15]) | (A[15] & ~B[15] & ~C[15]) ) Flags[2] = 1'b1; // Remember overflow on subtraction is different than addition
			else Flags[2] = 1'b0;
			Flags[3] = 1'b0; Flags[0] = 1'b0;
		end
		
	SUBC, SUBCI:
		begin
			{Flags[4], C} = A - B - Carry_in; // Borrow Flag
			if (C == 0) Flags[1] = 1'b1;
			else Flags[1] = 1'b0;
			if( (~A[15] & B[15] & C[15]) | (A[15] & ~B[15] & ~C[15]) ) Flags[2] = 1'b1; // Remember overflow on subtraction is different than addition
			else Flags[2] = 1'b0;
			Flags[3] = 1'b0; Flags[0] = 1'b0;
		end

	CMP, CMPI:
		begin
			if ($signed(A) < $signed(B))
				begin
				Flags[0] = 1'b0;
				Flags[3] = 1'b1;
				Flags[1] = 1'b0;
				end
			else if ($signed(B) < $signed(A))
				begin
				Flags[0] = 1'b1;
				Flags[3] = 1'b0;
				Flags[1] = 1'b0;
				end
			else
				begin
				Flags[0] = 1'b0;
				Flags[3] = 1'b0;
				Flags[1] = 1'b1;
				end
			Flags[4] = 1'b0; Flags[2] = 1'b0;
			C = B; // Subtraction without writeback is specified in the ISA.
		end

	CMPU, CMPUI:
		begin
			if (A < B)
				begin
				Flags[0] = 1'b0;
				Flags[3] = 1'b1;
				Flags[1] = 1'b0;
				end
			else if (B < A)
				begin
				Flags[0] = 1'b1;
				Flags[3] = 1'b0;
				Flags[1] = 1'b0;
				end
			else
				begin
				Flags[0] = 1'b0;
				Flags[3] = 1'b0;
				Flags[1] = 1'b1;
				end
			Flags[4] = 1'b0; Flags[2] = 1'b0;
			C = B; // Subtraction without writeback is specified in the ISA.
		end
		
	AND, ANDI:
		begin
			C = A & B;
			Flags[4:0] = 5'b00000;
		end
		
	OR, ORI:
		begin
			C = A | B;
			Flags[4:0] = 5'b00000;
		end
		
	XOR, XORI:
		begin
			C = A ^ B;
			Flags[4:0] = 5'b00000;
		end
		
	NOT:
		begin
		C = ~A;
		Flags[4:0] = 5'b00000;
		end
		
	LSH, LSHI:
		begin
			C = A << B;
			Flags[4:0] = 5'b00000;
		end

	RSH, RSHI:
		begin
			C = A >> B;
			Flags[4:0] = 5'b00000;
		end

	ALSH, ALSHI:
		begin
			C = A <<< B;
			Flags[4:0] = 5'b00000;
		end
		
	ARSH, ARSHI:
		begin
			C = A >>> B;
			Flags[4:0] = 5'b00000;
		end
	
	default:
		begin
			C = 0;
			Flags[4:0] = 5'b11111; // Signifies bad opcode
		end
	endcase
	$display("A: %b, B: %b, C: %b", A, B, C);
end

endmodule
