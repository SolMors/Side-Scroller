module init_fsm(
		input clock,
		input resetn,
		input go,
		
		//output reg [2:0] calc_op,
		//output reg calc_go,
		output reg load_init,
		output reg draw,
		output reg i_done,
		output reg [17:0] init_out
		//output reg [3:0] ledr
	);
	
	reg [4:0] current_state, next_state;
	
	reg [6:0] walk_x;
	reg [5:0] walk_y;
	reg [7:0] save_x;
	
	localparam 	WAIT					= 5'd0,
					SETUP_BOX			= 5'd1,
					BOX_DRAW				= 5'd2,
					BOX_0					= 5'd3,
					BOX_0_LOAD			= 5'd4,
					BOX_0_DRAW			= 5'd5,
					SAVE_X_0				= 5'd6,
					BOX_1					= 5'd7,
					BOX_1_LOAD			= 5'd8,
					BOX_1_DRAW			= 5'd9,
					BOX_2					= 5'd10,
					BOX_2_LOAD			= 5'd11,
					BOX_2_DRAW			= 5'd12,
					SAVE_X_1				= 5'd13,
					BOX_3					= 5'd14,
					BOX_3_LOAD			= 5'd15,
					BOX_3_DRAW			= 5'd16,
					PLAYER				= 5'd17,
					PLAYER_LOAD			= 5'd18,
					PLAYER_DRAW			= 5'd19,
					BOULDER_0			= 5'd20,
					BOULDER_0_LOAD		= 5'd21,
					BOULDER_0_DRAW		= 5'd22,
					BOULDER_1			= 5'd23,
					BOULDER_1_LOAD		= 5'd24,
					BOULDER_1_DRAW		= 5'd25,
					INIT_DONE			= 5'd26;
					
					
	always @(*)
	begin: state_table
		case (current_state)
			WAIT: next_state = go ? SETUP_BOX : WAIT;
			SETUP_BOX: next_state = BOX_DRAW;
			BOX_DRAW: next_state = BOX_0;
			BOX_0: next_state = BOX_0_LOAD;
			BOX_0_LOAD: next_state = BOX_0_DRAW;
			BOX_0_DRAW: next_state = (walk_x == 7'b1010000) ? SAVE_X_0 : BOX_0;
			SAVE_X_0: next_state = BOX_1;
			BOX_1: next_state = BOX_1_LOAD;
			BOX_1_LOAD: next_state = BOX_1_DRAW;
			BOX_1_DRAW: next_state = (walk_y == 6'b101000) ? BOX_2 : BOX_1;
			BOX_2: next_state = BOX_2_LOAD;
			BOX_2_LOAD: next_state = BOX_2_DRAW;
			BOX_2_DRAW: next_state = (walk_x == 7'b0000000) ? SAVE_X_1 : BOX_2;
			SAVE_X_1: next_state = BOX_3;
			BOX_3: next_state = BOX_3_LOAD;
			BOX_3_LOAD: next_state = BOX_3_DRAW;
			BOX_3_DRAW: next_state = (walk_y == 6'b000000) ? PLAYER : BOX_3;
			PLAYER: next_state = PLAYER_LOAD;
			PLAYER_LOAD: next_state = PLAYER_DRAW;
			PLAYER_DRAW: next_state = BOULDER_0;
			BOULDER_0: next_state = BOULDER_0_LOAD;
			BOULDER_0_LOAD: next_state = BOULDER_0_DRAW;
			BOULDER_0_DRAW: next_state = BOULDER_1;
			BOULDER_1: next_state = BOULDER_1_LOAD;
			BOULDER_1_LOAD: next_state = BOULDER_1_DRAW;
			BOULDER_1_DRAW: next_state = INIT_DONE;
			INIT_DONE: next_state = INIT_DONE;
			default next_state = WAIT;
		endcase
	end
	
	always @(*)
	begin: enable_signals
		load_init = 0;
		//ledr[3:0] = 0;
		draw = 0;
		
		case (current_state)
			WAIT: begin

			end
			SETUP_BOX: begin
				init_out = 18'b001010000101000111; //(40, 40)
				load_init = 1;
				walk_x = 7'b0000000;
				walk_y = 6'b000000;
				save_x = 8'b00000000;
				i_done = 0;
				draw = 0;
			end
			BOX_DRAW: begin
				draw = 1;
			end
			BOX_0: begin
				init_out = {(init_out[17:10] + 1), init_out[9:0]};
				walk_x = walk_x + 1;
				//ledr[0] = 1;
			end
			BOX_0_LOAD: begin
				load_init = 1;
				//ledr[1] = 1;
			end
			BOX_0_DRAW: begin
				draw = 1;
				//ledr[2] = 1;
			end
			SAVE_X_0: begin
				save_x = init_out[17:10]; 
			end
			BOX_1: begin
				init_out[17:10] = save_x;
				init_out[9:0] = {(init_out[9:3] + 1), init_out[2:0]};
				walk_y = walk_y + 1;
				//ledr[2] = 1;
			end
			BOX_1_LOAD: begin
				load_init = 1;
			end
			BOX_1_DRAW: begin
				draw = 1;
			end
			BOX_2: begin
				init_out = {(init_out[17:10] - 1), init_out[9:0]};
				walk_x = walk_x - 1;
				//ledr[2] = 1;
			end
			BOX_2_LOAD: begin
				load_init = 1;
			end
			BOX_2_DRAW: begin
				draw = 1;
			end
			SAVE_X_1: begin
				save_x = init_out[17:10]; 
			end
			BOX_3: begin
				init_out[17:10] = save_x; 
				init_out[9:0] = {(init_out[9:3] - 1), init_out[2:0]};
				walk_y = walk_y - 1;
				//ledr[3] = 1;
			end
			BOX_3_LOAD: begin
				load_init = 1;
			end
			BOX_3_DRAW: begin
				draw = 1;
			end
			PLAYER: begin
				init_out = 18'b010100001001111001; //(80, 79)
			end
			PLAYER_LOAD: begin
				load_init = 1;
			end
			PLAYER_DRAW: begin
				draw = 1;
			end
			BOULDER_0: begin
				init_out = 18'b001111001001111100; //(60, 79)
			end
			BOULDER_0_LOAD: begin
				load_init = 1;
			end
			BOULDER_0_DRAW: begin
				draw = 1;
			end
			BOULDER_1: begin
				init_out = 18'b011001001001111100; //(100, 79)
			end
			BOULDER_1_LOAD: begin
				load_init = 1;
			end
			BOULDER_1_DRAW: begin
				draw = 1;
			end
			INIT_DONE: begin
				i_done = 1;
				//ledr[3] = 1;
			end 
		endcase
	end
	
	
	always @(posedge clock)
	begin: state_FFs
		if (!resetn)
			current_state <= WAIT;
		else
			current_state <= next_state;
	end
	
endmodule 