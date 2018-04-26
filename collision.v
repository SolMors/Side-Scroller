module collision (
	input clock,
	input resetn,
	input go,
	input [17:0] player, boulder_0, boulder_1,
	
	output [6:0] display,
	output reg cd_done, gg
	);
	
	reg [3:0] current_state, next_state;
	reg [3:0] lives;
	
	reg collision;
	
	localparam 	SETUP				= 4'd0,
					IDLE				= 4'd1,
					COMPARE_B_0		= 4'd2,
					COMPARE_B_1		= 4'd3,
					COLL_DETECTED 	= 4'd4,
					CHECK_LIVES		= 4'd5,
					COLL_DONE		= 4'd6;
					
	always @(*)
	begin: state_table
		case (current_state)
			SETUP: next_state = IDLE;
			IDLE: next_state = go ? COMPARE_B_0 : IDLE;
			COMPARE_B_0: next_state = collision ? COLL_DETECTED : COMPARE_B_1;
			COMPARE_B_1: next_state = collision ? COLL_DETECTED : COLL_DONE;
			COLL_DETECTED: next_state = CHECK_LIVES;
			CHECK_LIVES: next_state = COLL_DONE;
			COLL_DONE: next_state = IDLE;
			default next_state = SETUP;
		endcase
	end
	
	always @(*)
	begin: enable_signals
		collision = 0;
		cd_done = 0;
		
		case (current_state)
			SETUP: begin
				lives = 4'b0011;
				gg = 0;
			end
			COMPARE_B_0: begin
				if (player[17:3] == boulder_0[17:3])
					collision = 1;
			end
			COMPARE_B_1: begin
				if (player[17:3] == boulder_1[17:3])
					collision = 1;
			end
			COLL_DETECTED: begin
				lives = lives - 1;
			end
			CHECK_LIVES: begin
				if (lives == 4'b0000) begin
					gg = 1;
				end
			end
			COLL_DONE: begin
				cd_done = 1;
			end
		endcase
	end
					
	always @(posedge clock)
	begin: state_FFs
		if (!resetn)
			current_state <= SETUP;
		else
			current_state <= next_state;
	end
	
	hex_decoder h0 (
		.hex_digit(lives),
		.segments(display)
	);
	
endmodule

module hex_decoder(hex_digit, segments);
    input [3:0] hex_digit;
    output reg [6:0] segments;
   
    always @(*)
        case (hex_digit)
            4'h0: segments = 7'b100_0000;
            4'h1: segments = 7'b111_1001;
            4'h2: segments = 7'b010_0100;
            4'h3: segments = 7'b011_0000;
            4'h4: segments = 7'b001_1001;
            4'h5: segments = 7'b001_0010;
            4'h6: segments = 7'b000_0010;
            4'h7: segments = 7'b111_1000;
            4'h8: segments = 7'b000_0000;
            4'h9: segments = 7'b001_1000;
            4'hA: segments = 7'b000_1000;
            4'hB: segments = 7'b000_0011;
            4'hC: segments = 7'b100_0110;
            4'hD: segments = 7'b010_0001;
            4'hE: segments = 7'b000_0110;
            4'hF: segments = 7'b000_1110;   
            default: segments = 7'h7f;
        endcase
endmodule
