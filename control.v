module control (
	input clock,
	input resetn,
	input start,
	input p_done, b_0_done, b_1_done, init_done, coll_done, reset_done,
	input gameOver,
	
	output reg p_go, b_0_go, b_1_go, init_go, coll_go,
	output reg [1:0] draw_select,
	//output reg [5:0] ledr,
	output reg shift,
	output reg resetg,
	output [6:0] score_0, score_1, score_2
	);
	
	reg [3:0] current_state, next_state;
	wire fps_go;
	reg score_go;
	
	localparam	LOADED		= 4'd0,
					RESET			= 4'd1,
					RESET_WAIT	= 4'd2,
					INIT			= 4'd3,
					PLAY			= 4'd4,
					PLAYER		= 4'd5,
					BOULDER_0	= 4'd6,
					BOULDER_1	= 4'd7,
					COLL_DETECT	= 4'd8,
					GG				= 4'd9,
					OVER			= 4'd10;
					
	always @(*)
	begin: state_table
		case (current_state)
			LOADED: next_state = start ? RESET : LOADED;
			RESET: next_state = RESET_WAIT;
			RESET_WAIT: next_state = reset_done ? INIT : RESET_WAIT;
			INIT: next_state = init_done ? PLAY : INIT;
			PLAY: next_state = fps_go ? PLAYER : PLAY;
			PLAYER: next_state = p_done ? BOULDER_0 : PLAYER;
			BOULDER_0: next_state = b_0_done ? BOULDER_1 : BOULDER_0;
			BOULDER_1: next_state = b_1_done ? COLL_DETECT : BOULDER_1;
			COLL_DETECT: next_state = coll_done ? GG : COLL_DETECT;
			GG: next_state = gameOver ? OVER : PLAY;
			OVER: next_state = resetn ? LOADED : OVER;
			default next_state = LOADED;
		endcase
	end
	
	always @(*)
	begin: enable_signals
		init_go = 0;
		p_go = 0;
		b_0_go = 0;
		b_1_go = 0;
		coll_go = 0;
		//ledr[5:0] = 0;
		resetg = 0;
		shift = 0;	
		score_go = 0;
		
		case (current_state)
			LOADED: begin

			end
			RESET: begin
				score_go = 1;
				resetg = 1;
			end
			INIT: begin
				init_go = 1;
				draw_select = 2'b11;
				//ledr[0] = 1;
			end
			PLAY: begin
				score_go = 1;
				//ledr[1] = 1;
			end
			PLAYER: begin
				p_go = 1;
				draw_select = 2'b00;
				//ledr[2] = 1;
			end
			BOULDER_0: begin
				b_0_go = 1;
				draw_select = 2'b01;
				//ledr[3] = 1;
			end
			BOULDER_1: begin
				b_1_go = 1;
				draw_select = 2'b10;
				//ledr[4] = 1;
			end
			COLL_DETECT: begin
				coll_go = 1;
				//ledr[5] = 1;
			end
			GG: begin

			end
			OVER: begin

			end
		endcase
	end
	
	always @(posedge clock)
	begin: state_FFs
		if (!resetn)
			current_state <= LOADED;
		else
			current_state <= next_state;
	end
	
	fps f0(
		.clock(clock),
		.resetn(!resetg),
		
		.go(fps_go)
	);
	
	scoreKeeper sk0(
		.resetn(!resetg),
		.go(score_go),
		
		.d_0(score_0),
		.d_1(score_1),
		.d_2(score_2)
	);
	
endmodule

module fps (
	input clock,
	input resetn,

	output reg go
	);

	reg [3:0] count;

	always @(posedge clock)
	begin
		if (!resetn) begin
			count <= 0;
			go <= 0;
			end
		
		else if (count == 4'b1111) begin
				count <= 0;
				go <= 1;
				end
		else begin
				count <= count + 1;
				go <= 0;
				end
	end
endmodule

module scoreKeeper(
	input resetn,
	input go,
	
	output [6:0] d_0, d_1, d_2
	);
	
	reg [1:0] count;
	reg [3:0] decimal, tens, hundreds;
	reg score;
	
	always @(posedge go)
	begin
		if (!resetn) begin
			score <= 1;
			count <= 2'b00;
		end
		
		else if (count == 2'b11) begin
			score <= 1;
			count <= count + 1;
		end
		
		else begin
			score <= 0;
			count <= count + 1;
		end
	end
	
	always @(posedge score)
	begin
		if (!resetn) begin
			decimal <= 4'b0000;
			tens <= 4'b0000;
			hundreds <= 4'b0000;
		end
		
		else if ((decimal == 4'b1001) && (tens == 4'b1001) && (hundreds == 4'b1001)) begin
			decimal <= 4'b0000;
			tens <= 4'b0000;
			hundreds <= 4'b0000;
		end
		
		else if ((decimal == 4'b1001) && (tens == 4'b1001)) begin
			decimal <= 4'b0000;
			tens <= 4'b0000;
			hundreds <= hundreds + 1;
		end
		
		else if ((decimal == 4'b1001)) begin
			decimal <= 4'b0000;
			tens <= tens + 1;
		end
			
		else begin
			decimal <= decimal + 1;
		end
	end
		
	hex_dec h1 (
		.hex_digit(decimal),
		.segments(d_0)
	);

	hex_dec h2 (
		.hex_digit(tens),
		.segments(d_1)
	);

	hex_dec h3 (
		.hex_digit(hundreds),
		.segments(d_2)
	);	
endmodule

module hex_dec(hex_digit, segments);
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

