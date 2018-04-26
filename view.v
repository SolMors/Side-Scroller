module view (
	input clock,
	input resetn,
	input [1:0] draw_select,
	input draw,
	input [17:0] p_in, b_0_in, b_1_in, init_in
	
	/*
	output VGA_CLK,
	output VGA_HS,
	output VGA_VS,
	output VGA_BLANK_N,
	output VGA_SYNC_N,
	output VGA_R,
	output VGA_G,
	output VGA_B
	*/
	);
	
	reg [17:0] toDraw;
	
	/*
	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	vga_adapter VGA(
			.resetn(resetn),
			.clock(clock),
			.colour(toDraw[2:0]),
			.x(toDraw[17:10]),
			.y(toDraw[9:3]),
			.plot(draw),
			// Signals for the DAC to drive the monitor.
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "black.mif";
		*/
		
		
		always @(*)
		begin
			case (draw_select)
				2'b00: toDraw = p_in;
				2'b01: toDraw = b_0_in;
				2'b10: toDraw = b_1_in;
				2'b11: toDraw = init_in;
			endcase
		end
	
endmodule
