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
    localparam PROC_FREQ = 50*MHz;

    localparam GAME_FRAME_RT = 64'd60; // 60 fps

    wire frame_rate_clk, processor_clk;

    clock_divider frame_rate_clock_divider(.divclk(frame_rate_clk), .divclkfreq(GAME_FRAME_RT),
                                           .sysclk(clk), .sysclkfreq(SYSTEM_FREQ));

    clock_divider processor_clock_divider(.divclk(processor_clk), .divclkfreq(PROC_FREQ),
                                           .sysclk(clk), .sysclkfreq(SYSTEM_FREQ));

    wire [31:0] interrupt_instruction;

    // Read-Only Registers
    wire [31:0] pipe1x, pipe2x, pipe3x, pipe4x,
                pipe1bottomtop, pipe2bottomtop, pipe3bottomtop, pipe4bottomtop,
                pipe1yspace, pipe2yspace, pipe3yspace, pipe4yspace,
                bird_top_left,
                current_score, high_score;

    CPU CPU(.clock(processor_clk), .reset(1'b0),
            .interrupt_instruction(interrupt_instruction),

            .reg_out1(pipe1x), .reg_out2(pipe1bottomtop), .reg_out3(pipe1yspace),
            .reg_out4(pipe2x), .reg_out5(pipe2bottomtop), .reg_out6(pipe2yspace),
            .reg_out7(pipe3x), .reg_out8(pipe3bottomtop), .reg_out9(pipe3yspace),
            .reg_out10(pipe4x), .reg_out11(pipe4bottomtop), .reg_out12(pipe4yspace),

            .reg_out13(bird_top_left),

            .reg_out26(current_score), .reg_out27(high_score));


    InputController input_controller(.interrupt_instrucion(interrupt_instruction), .jump_key(jump),
                                    .frame_rt_clk(frame_rate_clk), .proc_clk(processor_clk),
                                    .reset(1'b0));

    VGAController vga_controller(.pipe1x(pipe1x), .pipe2x(pipe2x), .pipe3x(pipe3x), .pipe4x(pipe4x),
                                 .pipe1bottomtop(pipe1bottomtop), .pipe2bottomtop(pipe2bottomtop), .pipe3bottomtop(pipe3bottomtop), .pipe4bottomtop(pipe4bottomtop),
                                 .pipe1yspace(pipe1yspace), .pipe2yspace(pipe2yspace), .pipe3yspace(pipe3yspace), .pipe4yspace(pipe4yspace),

                                 .bird_top_left(bird_top_left),
                                 .current_score(current_score), .high_score(high_score),

                                 .hSync(hSync), .vSync(vSync),
                                 .VGA_B(VGA_B), .VGA_G(VGA_G), .VGA_R(VGA_R),

                                 .ps2_clk(ps2_clk), .ps2_data(ps2_data),

                                 .clk(clk), .reset(1'b0), .jump(jump));

endmodule