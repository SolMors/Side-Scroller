module player_fsm (
	input clock,
	input resetn,
	input go,
	input [2:0] move,
	
	output reg [3:0] calc_op,
	output reg calc_go, load_p, draw, move_done
	);
	
	reg [6:0] current_state, next_state;
	
	localparam	WAIT		= 7'd0,
					MOVE		= 7'd1,
					// MOVE LEFT
					M_LEFT	= 7'd2,
					M_L_0		= 7'd3,
					M_L_1		= 7'd4,
					M_L_DONE	= 7'd5,
					// JUMP LEFT
					J_LEFT	= 7'd6,
					J_L_0		= 7'd7,
					J_L_1		= 7'd8,
					J_L_2		= 7'd9,
					J_LP_0	= 7'd10,
					J_L_3		= 7'd11,
					J_L_4		= 7'd12,
					J_L_5		= 7'd13,
					J_L_6		= 7'd14,
					J_LP_1	= 7'd15,
					J_L_7		= 7'd16,
					J_L_8		= 7'd17,
					J_L_9		= 7'd18,
					J_L_10	= 7'd19,
					J_LP_2	= 7'd20,
					J_L_11	= 7'd21,
					J_L_12	= 7'd22,
					J_L_13	= 7'd23,
					J_L_14	= 7'd24,
					J_L_DONE	= 7'd25,
					// JUMP UP
					J_UP		= 7'd26,
					J_U_0		= 7'd27,
					J_U_1		= 7'd28,
					J_UP_0	= 7'd29,
					J_U_2		= 7'd30,
					J_U_3		= 7'd31,
					J_U_4		= 7'd32,
					J_UP_1	= 7'd33,
					J_U_5		= 7'd34,
					J_U_6		= 7'd35,
					J_U_7		= 7'd36,
					J_UP_2	= 7'd37,
					J_U_8		= 7'd38,
					J_U_9		= 7'd39,
					J_U_10	= 7'd40,
					J_U_DONE	= 7'd41,
					// JUMP RIGHT
					J_RIGHT	= 7'd42,
					J_R_0		= 7'd43,
					J_R_1		= 7'd44,
					J_R_2		= 7'd45,
					J_RP_0	= 7'd46,
					J_R_3		= 7'd47,
					J_R_4		= 7'd48,
					J_R_5		= 7'd49,
					J_R_6		= 7'd50,
					J_RP_1	= 7'd51,
					J_R_7		= 7'd52,
					J_R_8		= 7'd53,
					J_R_9		= 7'd54,
					J_R_10	= 7'd55,
					J_RP_2	= 7'd56,
					J_R_11	= 7'd57,
					J_R_12	= 7'd58,
					J_R_13	= 7'd59,
					J_R_14	= 7'd60,
					J_R_DONE	= 7'd61,
					// MOVE RIGHT 
					M_RIGHT	= 7'd62,
					M_R_0		= 7'd63,
					M_R_1		= 7'd64,
					M_R_DONE	= 7'd65,
					//NO MOVE
					NO_MOVE	= 7'd66,
					N_M_DONE = 7'd67;
					
	always @(*)
	begin: state_table
		case (current_state)
			WAIT: next_state = go ? MOVE : WAIT;
			
			MOVE: begin
				case (move)
					3'b100: next_state = M_LEFT;
					3'b110: next_state = J_LEFT;
					3'b010: next_state = J_UP;
					3'b011: next_state = J_RIGHT;
					3'b001: next_state = M_RIGHT;
					default next_state = NO_MOVE;
				endcase
			end
			
			M_LEFT: next_state = M_L_0;
			M_L_0: next_state = M_L_1;
			M_L_1: next_state = M_L_DONE;
			M_L_DONE: next_state = WAIT;
			
			// JUMP LEFT
			J_LEFT: next_state = J_L_0;
			J_L_0:  next_state = J_L_1;
			J_L_1:  next_state = J_L_2;
			J_L_2:  next_state = J_LP_0;
			J_LP_0:  next_state =  go ? J_L_3 : J_LP_0;
			J_L_3:  next_state = J_L_4;
			J_L_4:  next_state = J_L_5;
			J_L_5:  next_state = J_L_6;
			J_L_6:  next_state = J_LP_1;
			J_LP_1:  next_state = go ? J_L_7 : J_LP_1;
			J_L_7:  next_state = J_L_8;
			J_L_8:  next_state = J_L_9;
			J_L_9:  next_state = J_L_10;
			J_L_10: next_state = J_LP_2;
			J_LP_2:  next_state = go ? J_L_11 : J_LP_2;
			J_L_11:  next_state = J_L_12;
			J_L_12:  next_state = J_L_13;
			J_L_13:  next_state = J_L_14;
			J_L_14:	next_state = J_L_DONE;
			J_L_DONE: next_state =  WAIT;
			
			// JUMP UP
			J_UP: next_state = J_U_0;
			J_U_0: next_state = J_U_1;
			J_U_1: next_state = J_UP_0;
			J_UP_0: next_state = go ? J_U_2 : J_UP_0;
			J_U_2: next_state = J_U_3;
			J_U_3: next_state = J_U_4;
			J_U_4: next_state = J_UP_1;
			J_UP_1: next_state = go ? J_U_5 : J_UP_1;
			J_U_5: next_state = J_U_6;
			J_U_6: next_state = J_U_7;
			J_U_7: next_state = J_UP_2;
			J_UP_2: next_state = go ? J_U_8 : J_UP_2;
			J_U_8: next_state = J_U_9;
			J_U_9: next_state = J_U_10;
			J_U_10: next_state = J_U_DONE;
			J_U_DONE: next_state = WAIT;
			
			// JUMP RIGHT
			J_RIGHT: next_state = J_R_0;
			J_R_0: next_state = J_R_1;
			J_R_1: next_state = J_R_2;
			J_R_2: next_state = J_RP_0;
			J_RP_0: next_state = go ? J_R_3 : J_RP_0;
			J_R_3: next_state = J_R_4;
			J_R_4: next_state = J_R_5;
			J_R_5: next_state = J_R_6;
			J_R_6: next_state = J_RP_1;
			J_RP_1: next_state = go ? J_R_7 : J_RP_1;
			J_R_7: next_state = J_R_8;
			J_R_8: next_state = J_R_9;
			J_R_9: next_state = J_R_10;
			J_R_10: next_state = J_RP_2;
			J_RP_2: next_state = go ? J_R_11 : J_RP_2;
			J_R_11: next_state = J_R_11;
			J_R_12: next_state = J_R_12;
			J_R_13: next_state = J_R_13;
			J_R_14: next_state = J_R_DONE;
			J_R_DONE: next_state = WAIT;
			
			// MOVE RIGHT 1
			M_RIGHT: next_state = M_R_0;
			M_R_0: next_state = M_R_1;
			M_R_1: next_state = M_R_DONE;
			M_R_DONE: next_state = WAIT;
			
			//NO MOVE
			NO_MOVE: next_state = N_M_DONE;
			N_M_DONE: next_state = WAIT;
			
		endcase
	end
		
	always @(*)
	begin: enable_signals
		calc_go = 0;
		load_p = 0;
		draw = 0;
		move_done = 0;
		
		case (current_state)
			WAIT: begin
				draw = 0;
			end
		
			// MOVE LEFT 1
			M_LEFT: begin
				calc_op = 4'b0001;
				calc_go = 1;
			end
			M_L_0: begin
				load_p = 1;
			end
			M_L_1: begin
				draw = 1;
			end
			M_L_DONE: begin
				move_done = 1;
			end
			
			// JUMP LEFT
			J_LEFT: begin
				calc_op = 4'b0101;
				calc_go = 1;
			end
			J_L_0: begin
				calc_op = 4'b0001;
				calc_go = 1;
			end
			J_L_1: begin
				load_p = 1;
			end
			J_L_2: begin
				draw = 1;
			end
			J_LP_0: begin // Phase 1 complete
				move_done = 1;
			end
			J_L_3: begin
				calc_op = 4'b0011;
				calc_go = 1;
			end
			J_L_4: begin
				calc_op = 4'b0001;
				calc_go = 1;
			end
			J_L_5: begin
				load_p = 1;
			end
			J_L_6: begin
				draw = 1;
			end
			J_LP_1: begin // Phase 2 complete
				move_done = 1;
			end
			J_L_7: begin
				calc_op = 4'b0010;
				calc_go = 1;
			end
			J_L_8: begin
				calc_op = 4'b0001;
				calc_go = 1;
			end
			J_L_9: begin
				load_p = 1;
			end
			J_L_10: begin
				draw = 1;
			end
			J_LP_2: begin // Phase 3 complete
				move_done = 1;
			end
			J_L_11: begin
				calc_op = 4'b0100;
				calc_go = 1;
			end
			J_L_12: begin
				calc_op = 4'b0001;
				calc_go = 1;
			end
			J_L_13: begin
				load_p = 1;
			end
			J_L_14: begin
				draw = 1;
			end 
			J_L_DONE: begin // JUMP COMPLETE
				move_done = 1;
			end
			
			// JUMP UP
			J_UP: begin
				calc_op = 4'b0101;
				calc_go = 1;
			end
			J_U_0: begin
				load_p = 1;
			end
			J_U_1: begin
				draw = 1;
			end
			J_UP_0: begin // Phase 1 complete
				move_done = 1;
			end
			J_U_2: begin
				calc_op = 4'b0011;
				calc_go = 1;
			end
			J_U_3: begin
				load_p = 1;
			end
			J_U_4: begin
				draw = 1;
			end
			J_UP_1: begin // Phase 2 complete
				move_done = 1;
			end
			J_U_5: begin
				calc_op = 4'b0010;
				calc_go = 1;
			end
			J_U_6: begin
				load_p = 1;
			end
			J_U_7: begin
				draw = 1;
			end
			J_UP_2: begin // Phase 3 complete
				move_done = 1;
			end
			J_U_8: begin
				calc_op = 4'b0100;
				calc_go = 1;
			end
			J_U_9: begin
				load_p = 1;
			end
			J_U_10: begin
				draw = 1;
			end 
			J_U_DONE: begin // JUMP COMPLETE
				move_done = 1;
			end
			
			// JUMP RIGHT
			J_RIGHT: begin
				calc_op = 4'b0101;
				calc_go = 1;
			end
			J_R_0: begin
				calc_op = 4'b0000;
				calc_go = 1;
			end
			J_R_1: begin
				load_p = 1;
			end
			J_R_2: begin
				draw = 1;
			end 
			J_RP_0: begin // Phase 1 complete
				move_done = 1;
			end
			J_R_3: begin
				calc_op = 4'b0011;
				calc_go = 1;
			end
			J_R_4: begin
				calc_op = 4'b0000;
				calc_go = 1;
			end
			J_R_5: begin
				load_p = 1;
			end
			J_R_6: begin
				draw = 1;
			end 
			J_RP_1: begin // Phase 2 complete
				move_done = 1;
			end
			J_R_7: begin
				calc_op = 4'b0010;
				calc_go = 1;
			end
			J_R_8: begin
				calc_op = 4'b0000;
				calc_go = 1;
			end
			J_R_9: begin
				load_p = 1;
			end
			J_R_10: begin
				draw = 1;
			end 
			J_RP_2: begin // Phase 3 complete
				move_done = 1;
			end
			J_R_11: begin
				calc_op = 4'b0100;
				calc_go = 1;
			end
			J_R_12: begin
				calc_op = 4'b0000;
				calc_go = 1;
			end
			J_R_13: begin
				load_p = 1;
			end
			J_R_14: begin
				draw = 1;
			end 
			J_R_DONE: begin // JUMP COMPLETE
				move_done = 1;
			end
			
			// MOVE RIGHT 1
			M_RIGHT: begin
				calc_op = 4'b0000;
				calc_go = 1;
			end
			M_R_0: begin
				load_p = 1;
			end
			M_R_1: begin
				draw = 1;
			end
			M_R_DONE: begin
				move_done = 1;
			end
			
			// NO MOVE
			NO_MOVE: begin
				draw = 1;
			end
			N_M_DONE: begin
				move_done = 1;
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
