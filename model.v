module model (
	input clock,
	input resetn,
	input p_go, b_0_go, b_1_go, init_go, coll_go,
	input PS2_DAT, PS2_CLK,
	input [1:0] calc_select,
	input shift,
	input [2:0] switches, // used for testing
	
	output p_done, b_0_done, b_1_done, init_done, coll_done, 
	output reset_done,
	output [17:0] p_out, b_0_out, b_1_out, init_out,
	output draw, gameOver,
	output [6:0] d_lives
	//output [3:0] ledr
	);
	
	wire move_done;
	wire init_fsm, p_fsm;
	wire load_p, load_b_0, load_b_1;
	wire coll_start, calc_go;
	wire [3:0] calc_op;
	wire drawControl, drawModel;
	wire i_fsm_done;
	wire cd_done;
	
	assign draw = drawControl ^ drawModel;
	
	modelControl mc0(
		.clock(clock),
		.resetn(resetn),
		.p_go(p_go),
		.b_0_go(b_0_go),
		.b_1_go(b_1_go),
		.init_go(init_go),
		.coll_go(coll_go),
		.move_done(move_done),
		.shift(shift),
		.cd_done(cd_done),
		.i_fsm_done(i_fsm_done),
		
		.load_p(load_p),
		.load_b_0(load_b_0),
		.load_b_1(load_b_1),
		.calc_op(calc_op),
		.calc_go(calc_go),
		.coll_start(coll_start),
		.p_done(p_done),
		.b_0_done(b_0_done),
		.b_1_done(b_1_done),
		.init_done(init_done),
		.coll_done(coll_done),
		.draw(drawControl),
		.init_fsm(init_fsm),
		.p_fsm(p_fsm)
		//.ledr(ledr[0])
	);
	
	modelData md0(
		.clock(clock),
		.resetn(resetn),
		.load_p(load_p),
		.load_b_0(load_b_0),
		.load_b_1(load_b_1),
		//.shift(),
		.coll_start(coll_start),
		.calc_go(calc_go),
		.calc_sel(calc_select),
		.calc_op(calc_op),
		.i_fsm(init_fsm),
		.p_fsm(p_fsm),
		.move(switches),
		
		.player(p_out),
		.boulder_0(b_0_out),
		.boulder_1(b_1_out),
		.init(init_out),
		.cd_done(cd_done),
		.gameOver(gameOver),
		.i_fsm_done(i_fsm_done),
		.move_done(move_done),
		.draw(drawModel),
		.display_lives(d_lives),
		//.ledr(ledr),
		.reset_done(reset_done)
	);
	
endmodule


module modelControl (
		input clock,
		input resetn,
		input p_go, b_0_go, b_1_go, init_go, coll_go,
		input move_done,
		input shift,
		input cd_done,
		input i_fsm_done,
		
		output reg load_p, load_b_0, load_b_1,
		output reg [3:0] calc_op,
		output reg calc_go, coll_start,
		output reg p_done, b_0_done, b_1_done, init_done, coll_done,
		output reg draw, init_fsm, p_fsm
		//output reg ledr
	);
	
	reg [5:0] current_state, next_state;
	
	localparam	IDLE						= 6'd0,
	
					INIT						= 6'd1,
					WAIT_INIT				= 6'd2,
					INIT_DONE				= 6'd3,
	
					PLAYER					= 6'd4,
					ERASE_CALC				= 6'd5,
					ERASE_LOAD				= 6'd6,
					ERASE_DRAW				= 6'd7,
					REST_C_P					= 6'd8,
					REST_C_P_LOAD			= 6'd9,
					MOVE_PLAYER				= 6'd10,
					WAIT_PLAYER				= 6'd11,
					PLAYER_DONE				= 6'd12,
					
					BOULDER_0				= 6'd13,
					B_0_ERASE_CALC			= 6'd14,
					B_0_ERASE_LOAD			= 6'd15,
					B_0_ERASE				= 6'd16,
					B_0_R_COLOR				= 6'd17,
					B_0_R_LOAD				= 6'd18,
					B_0_SHIFT_CALC			= 6'd19,
					B_0_SHIFT_LOAD			= 6'd20,
					B_0_SHIFT				= 6'd21,
					B_0_DONE					= 6'd22,
					
					BOULDER_1				= 6'd23,
					B_1_ERASE_CALC			= 6'd24,
					B_1_ERASE_LOAD			= 6'd25,
					B_1_ERASE				= 6'd26,
					B_1_R_COLOR				= 6'd27,
					B_1_R_LOAD				= 6'd28,
					B_1_SHIFT_CALC			= 6'd29,
					B_1_SHIFT_LOAD			= 6'd30,
					B_1_SHIFT				= 6'd31,
					B_1_DONE					= 6'd32,
					
					COLL_DETECT				= 6'd33,
					COLL_WAIT				= 6'd34,
					COLL_DONE				= 6'd35;
					
	always @(*)
	begin: state_table
		case (current_state)
			IDLE:begin
				if (init_go)
					next_state = INIT;
				else if (p_go)
					next_state = PLAYER;
				else if (b_0_go)
					next_state = BOULDER_0;
				else if (b_1_go)
					next_state = BOULDER_1;
				else if (coll_go)
					next_state = COLL_DETECT;
				else
					next_state = IDLE;
			end
			
			INIT: next_state = WAIT_INIT;
			WAIT_INIT: next_state = i_fsm_done ? INIT_DONE : WAIT_INIT;
			INIT_DONE: next_state = IDLE;
			
			PLAYER: next_state = ERASE_CALC;
			ERASE_CALC: next_state = ERASE_LOAD;
			ERASE_LOAD: next_state = ERASE_DRAW;
			ERASE_DRAW: next_state = REST_C_P;
			REST_C_P: next_state = REST_C_P_LOAD;
			REST_C_P_LOAD: next_state = MOVE_PLAYER;
			MOVE_PLAYER: next_state = WAIT_PLAYER;
			WAIT_PLAYER: next_state = move_done ? PLAYER_DONE : WAIT_PLAYER;
			PLAYER_DONE: next_state = IDLE;
			
			BOULDER_0: next_state = shift ? B_0_ERASE_CALC : B_0_DONE;
			B_0_ERASE_CALC: next_state = B_0_ERASE_LOAD;
			B_0_ERASE_LOAD: next_state = B_0_ERASE;
			B_0_ERASE: next_state = B_0_R_COLOR;
			B_0_R_COLOR: next_state = B_0_R_LOAD;
			B_0_R_LOAD: next_state = B_0_SHIFT_CALC;
			B_0_SHIFT_CALC: next_state = B_0_SHIFT_LOAD;
			B_0_SHIFT_LOAD: next_state = B_0_SHIFT;
			B_0_SHIFT: next_state = B_0_DONE;
			B_0_DONE: next_state = IDLE;
			
			BOULDER_1: next_state = shift ? B_1_ERASE_CALC : B_1_DONE;
			B_1_ERASE_CALC: next_state = B_1_ERASE_LOAD;
			B_1_ERASE_LOAD: next_state = B_1_ERASE;
			B_1_ERASE: next_state = B_1_R_COLOR;
			B_1_R_COLOR: next_state = B_1_R_LOAD;
			B_1_R_LOAD: next_state = B_1_SHIFT_CALC;
			B_1_SHIFT_CALC: next_state = B_1_SHIFT_LOAD;
			B_1_SHIFT_LOAD: next_state = B_1_SHIFT;
			B_1_SHIFT: next_state = B_1_DONE;
			B_1_DONE: next_state = IDLE;
			
			COLL_DETECT: next_state = COLL_WAIT;
			COLL_WAIT: next_state = cd_done? COLL_DONE : COLL_WAIT;
			COLL_DONE: next_state = IDLE;
			
			default next_state = IDLE;
		endcase
	end
	
	always @(*)
	begin: enable_signals
		load_p = 0;
		load_b_0 = 0;
		load_b_1 = 0;
		coll_start = 0;
		calc_go = 0;
		p_done = 0;
		b_0_done = 0;
		b_1_done = 0;
		init_done = 0;
		coll_done = 0;
		draw = 0;
		p_fsm = 0;
		init_fsm = 0;
		//ledr = 0;
		
		case (current_state)
			IDLE: begin
			
			end
			
			// INIT STATES
			INIT: begin
				init_fsm = 1;
			end
			WAIT_INIT: begin
				//ledr = 1;
			end
			INIT_DONE: begin
				init_done = 1;
			end
			
			// PLAYER STATES
			PLAYER: begin
			
			end
			ERASE_CALC: begin
				calc_op = 4'b0110;
				calc_go = 1;
			end
			ERASE_LOAD: begin
				load_p = 1;
			end
			ERASE_DRAW: begin
				draw = 1;
			end
			REST_C_P: begin
				calc_op = 4'b0111;
				calc_go = 1;
			end
			REST_C_P_LOAD: begin
				load_p = 1;
			end
			MOVE_PLAYER: begin
				p_fsm = 1;
			end
			WAIT_PLAYER: begin
			
			end
			PLAYER_DONE: begin
				p_done = 1;
			end
			
			//BOULDER 0
			BOULDER_0: begin
			
			end
			B_0_ERASE_CALC: begin
				calc_op = 4'b0110;
				calc_go = 1;
			end
			B_0_ERASE_LOAD: begin
				load_b_0 = 1;
			end
			B_0_ERASE: begin
				draw = 1;
			end
			B_0_R_COLOR: begin
				calc_op = 4'b1000;
				calc_go = 1;
			end
			B_0_R_LOAD:begin
				load_b_0 = 1;
			end
			B_0_SHIFT_CALC: begin
				calc_op = 4'b0001;
				calc_go = 1;
			end
			B_0_SHIFT_LOAD: begin
				load_b_0 = 1;
			end
			B_0_SHIFT: begin
				draw = 1;
			end
			B_0_DONE: begin
				b_0_done =1;
			end
			
			//BOULDER 1
			BOULDER_1: begin
			
			end
			B_1_ERASE_CALC: begin
				calc_op = 4'b0110;
				calc_go = 1;
			end
			B_1_ERASE_LOAD: begin
				load_b_1 = 1;
			end
			B_1_ERASE: begin
				draw = 1;
			end
			B_1_R_COLOR: begin
				calc_op = 4'b1000;
				calc_go = 1;
			end
			B_1_R_LOAD:begin
				load_b_0 = 1;
			end
			B_1_SHIFT_CALC: begin
				calc_op = 4'b0001;
				calc_go = 1;
			end
			B_1_SHIFT_LOAD: begin
				load_b_1 = 1;
			end
			B_1_SHIFT: begin
				draw = 1;
			end
			B_1_DONE: begin
				b_1_done =1;
			end
			
			//COLLISION DETECT
			COLL_DETECT: begin
				coll_start = 1;
			end
			COLL_WAIT: begin
			
			end
			COLL_DONE: begin
				 coll_done = 1;
			end
		
		endcase
	end
	
	always @(posedge clock)
	begin: state_FFs
		if (!resetn)
			current_state <= IDLE;
		else
			current_state <= next_state;
	end
	
endmodule

module modelData (
		input clock,
		input resetn,
		input load_p, load_b_0, load_b_1,
		//input shift,
		input coll_start,
		input calc_go,
		input [1:0] calc_sel,
		input [3:0] calc_op,
		input p_fsm, i_fsm,
		input [2:0] move,
		
		output reg [17:0] player, boulder_0, boulder_1, init,
		output cd_done, gameOver, i_fsm_done, move_done, draw,
		output [6:0] display_lives,
		//output [3:0] ledr,
		output reg reset_done
	);
	
	//reg [17:0] player, boulder_0, boulder_1, init;
	
	//temp wire
	wire shift;
	
	wire load_init, load_p_fsm;
	wire [17:0] calc_out, init_out, p_calc_out;
	wire p_draw, init_draw;
	
	assign draw = p_draw ^ init_draw;
	
	
	always @(posedge clock)
	begin
		if (!resetn) begin
			reset_done <= 1;
			player <= 18'b010100001001111001;
			boulder_0 <= 18'b001111001001111100;
			boulder_1 <= 18'b011001001001111100;
			init <= 18'b001010000101000111;
		end
		
		
		else if (load_p)
			player <= calc_out;
		else if (load_p_fsm)
			player <= p_calc_out;
		else if (load_b_0)
			boulder_0 <= calc_out;
		else if (load_b_1)
			boulder_1 <= calc_out;
		else if (load_init)
			init <= init_out;
			
		else if (shift) begin
			player <= {(player[17:10] - 1), player[9:0]};
			boulder_0 <= {(boulder_0[17:10] - 1), boulder_0[9:0]};
			boulder_1 <= {(boulder_1[17:10] - 1), boulder_1[9:0]};
		end
	end
	
	wire [3:0] p_op;
	wire p_fsm_calc;
	
	player_fsm pfms0(
		.clock(clock),
		.resetn(resetn),
		.go(p_fsm),
		.move(move),
		
		.calc_op(p_op),
		.calc_go(p_fsm_calc),
		.load_p(load_p_fsm),
		.draw(p_draw),
		.move_done(move_done)
	);
		
	calc calcPlayer(
		.clock(clock),
		.resetn(resetn),
		.p_in(player),
		.b_0_in(boulder_0),
		.b_1_in(boulder_1),
		.init_in(init),
		.in_load(2'b00),
		.op(p_op),
		.calc_go(p_fsm_calc),
		
		.calc_out(p_calc_out)
	);
		
	init_fsm ifms0(
		.clock(clock),
		.resetn(resetn),
		.go(i_fsm),
		
		//.calc_op(i_op),
		//.calc_go(i_fsm_calc),
		.load_init(load_init),
		.draw(init_draw),
		.i_done(i_fsm_done),
		.init_out(init_out)
		//.ledr(ledr)
	);
	
	/*
	calc calcInit(
		.clock(clock),
		.resetn(resetn),
		.p_in(player),
		.b_0_in(boulder_0),
		.b_1_in(boulder_1),
		.init_in(init),
		.in_load(2'b11),
		.op(i_op),
		.calc_go(i_fsm_calc),
		
		.calc_out(i_calc_out)
	);*/
	
	calc calc0(
		.clock(clock),
		.resetn(resetn),
		.p_in(player),
		.b_0_in(boulder_0),
		.b_1_in(boulder_1),
		.init_in(init),
		.in_load(calc_sel),
		.op(calc_op),
		.calc_go(calc_go),
		
		.calc_out(calc_out)
	);
	
	collision cd0(
		.clock(clock),
		.resetn(resetn),
		.go(coll_start),
		.player(player),
		.boulder_0(boulder_0),
		.boulder_1(boulder_1),
		
		.display(display_lives),
		.cd_done(cd_done),
		.gg(gameOver)
	);
		
endmodule
