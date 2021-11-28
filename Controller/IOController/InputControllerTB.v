`timescale 1ns/100ps
module InputControllerTB;

    // module inputs
    reg clock = 0;
    reg jump = 1;

    // output
    wire frame_rate_clk, proc_clk;

    wire [31:0] interrupt_instruction;

    // definitions

    localparam MHz = 1000000;

    localparam SYSTEM_FREQ = 100*MHz; // System clock frequency
    localparam PROC_FREQ = 50*MHz; // System clock frequency

    localparam GAME_FRAME_RT = 10*MHz;

    InputController input_controller(.interrupt_instrucion(interrupt_instruction), .jump_key(jump),
                                    .frame_rt_clk(frame_rate_clk), .proc_clk(clock),
                                    .reset(1'b0));

    clock_divider proc_clock_divider(.divclk(proc_clk), .divclkfreq(PROC_FREQ),
                                           .sysclk(clock), .sysclkfreq(SYSTEM_FREQ));

    clock_divider frame_rate_clock_divider(.divclk(frame_rate_clk), .divclkfreq(GAME_FRAME_RT),
                                           .sysclk(proc_clk), .sysclkfreq(PROC_FREQ));


	integer i = 0;

	initial begin

        @(posedge clock);

        begin
            for (i = 0; i < 10000000; i = i + 1) begin

            end

            @(posedge clock);
		end

        $dumpfile("InputControllerTB.vcd");
        // Module to capture and what level, 0 means all wires
        $dumpvars(0, InputControllerTB);

		#1000;
		$finish;
	end

    always
    	#10 clock = !clock;

endmodule