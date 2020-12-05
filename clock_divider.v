module clock_divider(clock50mHz, reset, enable, clock1Hz);

input clock50mHz, reset, enable;

output reg clock1Hz;

reg [24:0] count;

always @(posedge clock50mHz, negedge reset) begin

	if (reset == 0) begin
		count <= 25'd0;
		clock1Hz <= 0;
	end
	else if (enable == 0) begin
		count <= count;
	end
	else if (count == 25000000) begin
		count <= 25'd0;
		clock1Hz <= ~clock1Hz;
	end
	else begin
		count <= count + 25'd1;
	end

end

endmodule