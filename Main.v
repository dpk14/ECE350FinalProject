module Main(clk, jump);

    input clk, jump;

    // definitions

    localparam MHz = 1000000;
    localparam SYSTEM_FREQ = 100*MHz; // System clock frequency

    localparam GAME_FRAME_RT = 60;

    wire frame_rate_clk;

    clock_divider frame_rate_clock_divider(.divclk(frame_rate_clk), .divclkfreq(GAME_FRAME_RT),
                                           .sysclkfreq(clk), .sysclkfreq(SYSTEM_FREQ));


    // TODO: Find way to externalize CPU regs and have them as outputs here to be read by VGAController and AudioController
    CPU CPU(.clock(clk), .reset(1'b0), .key_interrupt(key_interrupt));

    wire key_interrupt;

    InputController input_controller(.key_interrupt(key_interrupt), .jump_key(jump),
                                    .frame_rt_clk(frame_rate_clk), .sysclk(clk),
                                    .reset(1'b0));










endmodule