module	PLL(i_clk, i_ce, i_input, o_phase, o_err);
	parameter PHASE_BITS = 24;
	parameter [0:0] OPT_TRACK_FREQUENCY = 1'b1;
	parameter LGCOEFF = 5;
	localparam MSB = PHASE_BITS-1;
	parameter [(MSB-1):0] INITIAL_STEP;

	//
	input wire i_clk;
	//
	input wire i_ce;
	input wire i_input;
	output wire [MSB:0] o_phase;
	output reg [1:0] o_err;
	
	reg [MSB:0] ctr;
	reg [(MSB-1):0] r_step;
	reg agreed_output;
	reg lead;
	reg phase_err;
	reg [MSB:0] phase_correction;
	reg [MSB:0] freq_correction;
	
	// oscillator
	initial ctr = 0;
	always @(posedge i_clk)
		if (i_ce)
			if (!phase_err)
				ctr <= ctr + r_step;
			else if (lead)
				ctr <= ctr + r_step - phase_correction;
			else
				ctr <= ctr + r_step + phase_correction;
				
	// frequency loading
	initial r_step = { 1'b0, INITIAL_STEP };
	always @(posedge i_clk)
		if ((OPT_TRACK_FREQUENCY)&&(phase_err))
		begin
			if (lead)
				r_step <= r_step - freq_correction;
			else
				r_step <= r_step + freq_correction;
		end
			
	initial agreed_output = 0;
	always @(posedge i_clk)
	if (i_ce)
	begin
		if ((i_input)&&(ctr[MSB]))
			agreed_output <= 1'b1;
		else if ((!i_input)&&(!ctr[MSB]))
			agreed_output <= 1'b0;
	end
	
	always @(*)
		if (agreed_output)
			// We were last high.  Lead is true now
			// if the counter goes low before the input
			lead = (!ctr[MSB])&&(i_input);
		else
			// The last time we agreed, both the counter
			// and the input were low.   This will be
			// true if the counter goes high before the input
			lead = (ctr[MSB])&&(!i_input);
	
	always @(*)
		// Any disagreement between the high order counter bit and the input
		// is a phase error that we will need to correct
		phase_err = ctr[MSB] != i_input;
	
	initial o_err = 2'h0;
	always @(posedge i_clk)
	if (i_ce)
		o_err <= (!phase_err) ? 2'b00 : ((lead) ? 2'b11 : 2'b01);
	
	// Phase tracking
	initial	phase_correction = 0;
	always @(posedge i_clk)
		phase_correction <= {1'b1,{(MSB){1'b0}}} >> LGCOEFF;
	
	assign o_phase = ctr;
	
	// Frequency tracking
	initial freq_correction = 0;
	always @(posedge i_clk)
		freq_correction <= { 3'b001, {(MSB-2){1'b0}} } >> (2*LGCOEFF);
		
endmodule