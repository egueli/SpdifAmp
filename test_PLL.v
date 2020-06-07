
`timescale 1ns / 10ps 


module tb_phasedetector();

	parameter PHASE_BITS = 24;
	parameter real SYSTEM_CLOCK = 50000000;
	parameter SYSTEM_HALF_PERIOD_NS = 1e9 / (SYSTEM_CLOCK * 2);
	parameter real MAX_PHASE = 2.0 ** PHASE_BITS;
	parameter real RATIO = SYSTEM_CLOCK / MAX_PHASE;
	parameter real INPUT_FREQUENCY = 44100 * 2 * 32;
	parameter INPUT_HALF_PERIOD_NS = 1e9 / (INPUT_FREQUENCY * 2);
	parameter real INITIAL_FREQUENCY = 3000000;

reg clk_50;
reg i_ce;
reg i_input;

PLL #(
	.PHASE_BITS(PHASE_BITS),
	.LGCOEFF(5),
	.INITIAL_STEP(INITIAL_FREQUENCY / RATIO)
	)
U1(
	.i_clk(clk_50),
	.i_ce(i_ce),
	.i_input(i_input)
);

// Main 50MHz clock
initial
begin
	clk_50 = 0;
end
always
	#SYSTEM_HALF_PERIOD_NS clk_50 = ~clk_50;


// Internal oscillator
initial i_ce = 1;

// External signal
initial
begin
	i_input = 0;
end
always
	#INPUT_HALF_PERIOD_NS i_input = ~i_input;

endmodule
