module calc (
	input clock,
	input resetn,
	input [17:0] p_in, b_0_in, b_1_in, init_in,
	input [1:0] in_load,
	input [3:0] op,
	input calc_go,
	
	output reg [17:0] calc_out
	);
	
	reg [17:0] calc;
	
	always @(*)
	begin 
		case (in_load)
			2'b00: calc = p_in; 
			2'b01: calc = b_0_in;
			2'b10: calc = b_1_in;
			2'b11: calc = init_in;
			default calc = 18'd0;
		endcase
	end
	
	always @(posedge clock)
	begin
		if (calc_go)
		begin
			case (op)
				4'b0000: begin // x + 1
					calc_out = {(calc[17:10] + 1), calc[9:0]};
				end
				4'b0001: begin // x - 1
					calc_out = {(calc[17:10] - 1), calc[9:0]};
				end
				4'b0010: begin // y + 1
					calc_out[17:10] = calc[17:10];
					calc_out[9:0] = {(calc[9:3] + 1), calc[2:0]};
				end
				4'b0011: begin // y - 1
					calc_out[17:10] = calc[17:10];
					calc_out[9:0] = {(calc[9:3] - 1), calc[2:0]};
				end
				4'b0100: begin // y + 2
					calc_out[17:10] = calc[17:10];
					calc_out[9:0] = {(calc[9:3] + 2), calc[2:0]};
				end
				4'b0101: begin // y - 2
				   calc_out[17:10] = calc[17:10];
					calc_out[9:0] = {(calc[9:3] - 2), calc[2:0]};
				end
				4'b0110: begin // erase
					calc_out = {calc[17:3], 3'b000};
				end
				4'b0111: begin // restore player color
					calc_out = {calc[17:3], 3'b001};
				end
				4'b1000: begin // restore boulder color
					calc_out = {calc[17:3], 3'b100};
				end
			endcase
		end
	end
				
endmodule
	