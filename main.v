module main
	(
	CLOCK_50, //	On Board 50 MHz
	// Your inputs and outputs here
   KEY,
   SW,
	HEX0,
	HEX2,
	HEX3,
	HEX4
	//LEDR
	
	// Ports for Keyboard.
	/*
	PS2_DAT,
	PS2_CLK,
	// The ports below are for the VGA output.  Do not change.
	VGA_CLK,   						//	VGA Clock
	VGA_HS,							//	VGA H_SYNC
	VGA_VS,							//	VGA V_SYNC
	VGA_BLANK_N,						//	VGA BLANK
	VGA_SYNC_N,						//	VGA SYNC
	VGA_R,   						//	VGA Red[9:0]
	VGA_G,	 						//	VGA Green[9:0]
	VGA_B   						//	VGA Blue[9:0]
	*/
	);

	input	CLOCK_50;				//	50 MHz
	input [2:0] SW;
	input [3:0] KEY;
	//output [9:0] LEDR;
	output [6:0] HEX0;
	output [6:0] HEX2;
	output [6:0] HEX3;
	output [6:0] HEX4;
	
	// Keyboard inputs
	/*
	input PS2_DAT;
	input PS2_CLK;
	*/
	
	// Declare your inputs and outputs here
	// Do not change the following outputs
	/*
	output	VGA_CLK;   				//	VGA Clock
	output	VGA_HS;					//	VGA H_SYNC
	output	VGA_VS;					//	VGA V_SYNC
	output	VGA_BLANK_N;				//	VGA BLANK
	output	VGA_SYNC_N;				//	VGA SYNC
	output	[9:0]	VGA_R;   			//	VGA Red[9:0]
	output	[9:0]	VGA_G;	//	VGA Green[9:0]
	output	[9:0]	VGA_B;   			//	VGA Blue[9:0]
	*/
	
	wire resetn;
	assign resetn = KEY[0];
	wire resetg;
	
	// GO wires
	wire p_go, b_0_go, b_1_go, init_go, coll_go;
	// DONE wires
	wire p_done, b_0_done, b_1_done, init_done, coll_done, reset_done;
	// I/O wires
	wire [17:0] player, boulder_0, boulder_1, init;
	// DRAW
	wire draw;
	wire [1:0] draw_select;
	
	wire shift;
	wire gameOver;
	
	control c0 (
		.clock(CLOCK_50),
		.resetn(resetn),
		.start(!KEY[1]),
		.p_done(p_done),
		.b_0_done(b_0_done),
		.b_1_done(b_1_done),
		.init_done(init_done),
		.coll_done(coll_done),
		.reset_done(reset_done),
		.gameOver(gameOver),
		
		.p_go(p_go),
		.b_0_go(b_0_go),
		.b_1_go(b_1_go),
		.init_go(init_go),
		.coll_go(coll_go),
		.draw_select(draw_select),
		//.ledr(LEDR[5:0]),
		.shift(shift),
		.resetg(resetg),
		.score_0(HEX2),
		.score_1(HEX3),
		.score_2(HEX4)
	);
	
	model m0 (
		.clock(CLOCK_50),
		.resetn(!resetg),
		.p_go(p_go),
		.b_0_go(b_0_go),
		.b_1_go(b_1_go),
		.init_go(init_go),
		.coll_go(coll_go),
		.PS2_DAT(PS2_DAT),
		.PS2_CLK(PS2_CLK),
		.calc_select(draw_select),
		.shift(shift),
		.switches(SW[2:0]),
		
		.p_done(p_done),
		.b_0_done(b_0_done),
		.b_1_done(b_1_done),
		.init_done(init_done),
		.coll_done(coll_done),
		.reset_done(reset_done),
		.p_out(player),
		.b_0_out(boulder_0),
		.b_1_out(boulder_1),
		.init_out(init),
		.draw(draw),
		.gameOver(gameOver),
		.d_lives(HEX0)
		//.ledr(LEDR[9:6])
	);
	
	view v0 (
		.clock(CLOCK_50),
		.resetn(!resetg),
		.draw_select(draw_select),
		.draw(draw),
		.p_in(player),
		.b_0_in(boulder_0),
		.b_1_in(boulder_1),
		.init_in(init)
		
		/*
		.VGA_CLK(VGA_CLK),
		.VGA_HS(VGA_HS),
		.VGA_VS(VGA_VS),
		.VGA_BLANK_N(VGA_BLANK_N),
		.VGA_SYNC_N(VGA_SYNC_N),
		.VGA_R(VGA_R),
		.VGA_G(VGA_G),
		.VGA_B(VGA_B)
		*/
	);

endmodule
