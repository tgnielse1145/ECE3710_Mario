/** Supported Memory Block Configurations for Cyclone V Devices
  *
  * 397 M10K blocks available
  *
  * Each block can be configured as:
  *		Depth (bits)	| 	Programmable Width
  *			256			|		x40 or x32
  *			512			|		x20 or x16
  *			 1k			|		x10 or x8
  *			 2k			|		 x5 or x4
  *			 4k			|			 x2
  *			 8k			|			 x1
  */
module glyph_rom
// will technically be x40 or x32
#(parameter DATA_WIDTH=24, ADDR_WIDTH=8)
(
	input [(ADDR_WIDTH-1):0] addr,
	input clk, 
	output reg [(DATA_WIDTH-1):0] q
);

reg [(DATA_WIDTH-1):0] rom [((2**ADDR_WIDTH)-1):0];

initial
begin
	$readmemh("bigMarioKart.hex", rom);
	$readmemh("Obstacle.hex", rom, 1024);
	//$readmemh("star.hex", rom, 2048);
	//$readmemh("lightingBolt.hex", rom, 2516);
end

always @(posedge clk)begin
	q <= rom[addr];
end
endmodule
