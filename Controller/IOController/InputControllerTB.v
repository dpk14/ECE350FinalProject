`timescale 1ns/100ps
module InputControllerTB;

    // module inputs
    reg clock = 0;
    reg jump = 1;

    // output
    wire frame_rate_clk, key_interrupt;

    // definitions

    localparam MHz = 1000000;
    localparam SYSTEM_FREQ = 100*MHz; // System clock frequency

    localparam GAME_FRAME_RT = 10*MHz;

    InputController input_controller(.key_interrupt(key_interrupt), .jump_key(jump),
                                    .frame_rt_clk(frame_rate_clk), .sysclk(clock),
                                    .reset(1'b0));

    clock_divider frame_rate_clock_divider(.divclk(frame_rate_clk), .divclkfreq(GAME_FRAME_RT),
                                           .sysclk(clock), .sysclkfreq(SYSTEM_FREQ));

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