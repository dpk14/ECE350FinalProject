module Main(input clk,
            input jump,

            // VGA
            output hSync, 		// H Sync Signal
            output vSync, 		// Veritcal Sync Signal
            output[3:0] VGA_R,  // Red Signal Bits
            output[3:0] VGA_G,  // Green Signal Bits
            output[3:0] VGA_B,  // Blue Signal Bits
            inout ps2_clk,
            inout ps2_data);

    // definitions

    localparam MHz = 1000000;
    localparam SYSTEM_FREQ = 100*MHz; // System clock frequency

    localparam GAME_FRAME_RT = 64'd60; // 60 fps

    wire frame_rate_clk, processor_clk;

    clock_divider frame_rate_clock_divider(.divclk(frame_rate_clk), .divclkfreq(GAME_FRAME_RT),
                                           .sysclk(clk), .sysclkfreq(SYSTEM_FREQ));

    clock_divider processor_clock_divider(.divclk(processor_clk), .divclkfreq(SYSTEM_FREQ / 2),
                                           .sysclk(clk), .sysclkfreq(SYSTEM_FREQ));

    wire [31:0] interrupt_instruction;

    // Read-Only Registers
    wire [31:0] pipe1, pipe2, pipe3, pipe4,
                bird_top_left,
                current_score, high_score;

    CPU CPU(.clock(processor_clk), .reset(1'b0),
            .interrupt_instruction(interrupt_instruction),

            .reg_out1(pipe1), .reg_out2(pipe2), .reg_out3(pipe3), .reg_out4(pipe4),
            .reg_out5(bird_top_left),
            .reg_out26(current_score), .reg_out27(high_score));


    InputController input_controller(.interrupt_instrucion(interrupt_instruction), .jump_key(jump),
                                    .frame_rt_clk(frame_rate_clk), .proc_clk(processor_clk),
                                    .reset(1'b0));


endmodule