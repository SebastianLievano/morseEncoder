module morseEncoder(ClockIn, Resetn, Start, Letter, DotDashOut);
	input ClockIn, Resetn, Start;
	input [4:0]Letter;
	output DotDashOut;

	wire ClockOut;
	wire [13:0] pattern;

	rateDivider timer(ClockIn, Resetn, ClockOut);
	findPattern letterReader(Letter, Start, pattern);

	shiftRegister outputter(pattern, ClockOut, Start, DotDashOut); 
endmodule

module rateDivider(ClockIn, Resetn, ClockOut);
	input ClockIn, Resetn;
	output ClockOut;

	reg[7:0] counter;
	reg[7:0] d = 8'b11111001;
	wire parLoad;

	always@(posedge ClockIn, negedge Resetn)
	begin
		if(Resetn == 1'b0)
			counter <= 0;
		else if(parLoad == 1'b1)
			counter <= d;
		else if(parLoad == 1'b0)
			counter <= counter - 1;
	end
	
	assign ClockOut = (counter == 8'b0)? 1'b1:1'b0;
	assign parLoad = ClockOut;

endmodule

module findPattern(Letter, Start, pattern);
	input [4:0]Letter;
	input Start;
	output reg [13:0]pattern;
	always@(Start) begin
		case(Letter)
			5'b00000: pattern <= 14'b10111000000000;  //A = .-
			5'b00001: pattern <= 14'b11101010100000; //B = - . . .
			5'b00010: pattern <= 14'b11101011101000; //C = -.-.
			5'b00011: pattern <= 14'b11101010000000; //D = -..
			5'b00100: pattern <= 14'b10000000000000; //E = .
			5'b00101: pattern <= 14'b10101110100000; //F = ..-.
			5'b00110: pattern <= 14'b11101110100000; //G = --.
			5'b00111: pattern <= 14'b10101010000000; //H = ....
            5'b01000: pattern <= 14'b10100000000000;//I = ..
            5'b01001: pattern <= 14'b10111011101110; //J = .---
            5'b01010: pattern <= 14'b11101011100000; //K = -.-
            5'b01011: pattern <= 14'b10111010100000; //L = .-..
            5'b01100: pattern <= 14'b11101110000000; //M = --
            5'b01101: pattern <= 14'b11101000000000; //N = -.
            5'b01110: pattern <= 14'b11101110111000; //O = ---
            5'b01111: pattern <= 14'b10111011101000; //P = .--.
            5'b10000: pattern <= 14'b11101110101110; //Q = --.-
            5'b10001: pattern <= 14'b10111010000000; //R = .-.
            5'b10010: pattern <= 14'b10101000000000; //S = ...
            5'b10011: pattern <= 14'b11100000000000; //T = -
            5'b10100: pattern <= 14'b10101110000000; //U = ..-
            5'b10101: pattern <= 14'b10101011100000; //V = ...-
            5'b10110: pattern <= 14'b10111011100000; //W = .--
            5'b10111: pattern <= 14'b11101010111000; //X = -..-
            5'b11000: pattern <= 14'b11101011101110; //Y = -.--
            5'b11001: pattern <= 14'b11101110101000; //Z = --..
	endcase
	end
endmodule

module shiftRegister(pattern, clock, Start, DotDashOut);
	input [13:0]pattern;
	input clock, Start;
	output reg DotDashOut;
	reg [13:0]holdingPattern;

	always@(Start)begin
		holdingPattern <= pattern;
		DotDashOut <= holdingPattern[13];
	end
	
	always@(posedge clock)
	begin
		DotDashOut = holdingPattern[13];
		holdingPattern = holdingPattern << 1;
		holdingPattern[0] = DotDashOut;
	end

endmodule
