module clock_divider(clock50mHz, reset, enable, clock50Hz);

input clock50mHz, reset, enable;

output reg clock50Hz;

reg [24:0] count;

always @(posedge clock50mHz, negedge reset) begin

	if (reset == 0) begin
		count <= 25'd0;
		clock50Hz <= 0;
	end
	else if (enable == 0) begin
		count <= count;
	end
	else if (count == 500000) begin
		count <= 25'd0;
		clock50Hz <= ~clock50Hz;
	end
	else begin
		count <= count + 25'd1;
	end

end

endmodule
