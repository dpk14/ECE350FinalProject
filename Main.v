module Main(clk, jump);

    input clk, jump;

    // definitions

    localparam MHz = 1000000;
    localparam SYSTEM_FREQ = 100*MHz; // System clock frequency

    localparam GAME_FRAME_RT = 60;

    wire frame_rate_clock;

    clock_divider frame_rate_clock_divider(.divclk(frame_rate_clock), .divclkfreq(GAME_FRAME_RT),
                                           .sysclkfreq(clk), .sysclkfreq(SYSTEM_FREQ));


    CPU CPU(.clock(clk), .reset(1'b0));   // TODO: Give it inputs for interrupt, output array of regs to be read by Game Loop and OutputControllers










endmodule