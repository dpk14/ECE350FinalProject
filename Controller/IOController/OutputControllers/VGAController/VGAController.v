`timescale 1 ns/ 100 ps
module VGAController(
	input clk, 			// 100 MHz System Clock
	input reset, 		// Reset Signal

	// Game inputs

	input jump,

	// Register Contents

	input[31:0] pipe1,
	input[31:0] pipe2,
    input[31:0] pipe3,
    input[31:0] pipe4,

    input[31:0] bird_top_left,
    input[31:0] current_score,
    input[31:0] high_score,

	output hSync, 		// H Sync Signal
	output vSync, 		// Veritcal Sync Signal
	output[3:0] VGA_R,  // Red Signal Bits
	output[3:0] VGA_G,  // Green Signal Bits
	output[3:0] VGA_B,  // Blue Signal Bits
	inout ps2_clk,
	inout ps2_data);

    localparam MHz = 1000000;
    localparam SYSTEM_FREQ = 100*MHz; // System clock frequency


	// Clock divider 100 MHz -> 25 MHz
	wire clk25; // 25MHz clock

    clock_divider processor_clock_divider(.divclk(clk25), .divclkfreq(SYSTEM_FREQ / 4),
                                           .sysclk(clk), .sysclkfreq(SYSTEM_FREQ));

	// VGA Timing Generation for a Standard VGA Screen
	localparam
		SCREEN_WIDTH = 640,  // Standard VGA Width
		SCREEN_HEIGHT = 480, // Standard VGA Height
		BITS_PER_COLOR = 12, // Nexys A7 uses 12 bits/color

		BIRD_WIDTH = 35,
		BIRD_HEIGHT = 35,
		BIRD_LEFT_EDGE = 90;

	wire active, screenEnd;
	wire[9:0] x;
	wire[8:0] y;

	VGATimingGenerator #(
		.HEIGHT(SCREEN_HEIGHT), // Use the standard VGA Values
		.WIDTH(SCREEN_WIDTH))
	Display(
		.clk25(clk25),  	   // 25MHz Pixel Clock
		.reset(reset),		   // Reset Signal
		.screenEnd(screenEnd), // High for one cycle when between two frames
		.active(active),	   // High when drawing pixels
		.hSync(hSync),  	   // Set Generated H Signal
		.vSync(vSync),		   // Set Generated V Signal
		.x(x), 				   // X Coordinate (from left)
		.y(y)); 			   // Y Coordinate (from top)


    // Images:

    wire[BITS_PER_COLOR-1:0] backgroundColorData,   // 12-bit color data at current pixel
                             splashScreenColorData,
                             pipe1_colorData, pipe2_colorData, pipe3_colorData, pipe4_colorData,
                             birdColorData;

    wire inside_pipe1, inside_pipe2, inside_pipe3, inside_pipe4,
         inside_bird;


        // game background
        image #(.WIDTH(SCREEN_WIDTH), .HEIGHT(SCREEN_HEIGHT),
                .IMG_FILE("backgroundImage.mem"),
                .CLR_FILE("backgroundColors.mem"))
        background(.clk(clk),
                    .imgAddress(x + 640*y),
                    .colorData(backgroundColorData));

        // splash screen background
        image #(.WIDTH(SCREEN_WIDTH), .HEIGHT(SCREEN_HEIGHT),
                .IMG_FILE("splashScreenImage.mem"),
                .CLR_FILE("splashScreenColors.mem"))
        background(.clk(clk),
                    .imgAddress(x + 640*y),
                    .colorData(splashScreenColorData));

        // bird
        BirdDisplay #(.SCREEN_WIDTH(SCREEN_WIDTH), .SCREEN_HEIGHT(SCREEN_HEIGHT), .BITS_PER_COLOR(BITS_PER_COLOR),
                      .BIRD_LEFT_EDGE(BIRD_LEFT_EDGE), .BIRD_WIDTH(BIRD_WIDTH), .BIRD_HEIGHT(BIRD_HEIGHT))
            birdDisplay(.inside_bird(inside_bird), .colorData(birdColorData),
                                .clk(clk), .x(x), .y(y), .bird_reg(bird_top_left));


        // display for each of pipes

        PipeDisplay #(.SCREEN_WIDTH(SCREEN_WIDTH), .SCREEN_HEIGHT(SCREEN_HEIGHT), .BITS_PER_COLOR(BITS_PER_COLOR),
                      .PIPE_WIDTH(PIPE_WIDTH), .PIPE_CAP_HEIGHT(PIPE_CAP_HEIGHT), .BITS_PER_COLOR(BITS_PER_COLOR))
            pipe1Display(.inside_pipe(inside_pipe1), .colorData(pipe1_colorData),
                                    .clk(clk), .x(x), .y(y), .pipe_reg(pipe1));
        PipeDisplay #(.SCREEN_WIDTH(SCREEN_WIDTH), .SCREEN_HEIGHT(SCREEN_HEIGHT), .BITS_PER_COLOR(BITS_PER_COLOR),
                      .PIPE_WIDTH(PIPE_WIDTH), .PIPE_CAP_HEIGHT(PIPE_CAP_HEIGHT), .BITS_PER_COLOR(BITS_PER_COLOR))
            pipe2Display(.inside_pipe(inside_pipe2), .colorData(pipe2_colorData),
                                .clk(clk), .x(x), .y(y), .pipe_reg(pipe2));
        PipeDisplay #(.SCREEN_WIDTH(SCREEN_WIDTH), .SCREEN_HEIGHT(SCREEN_HEIGHT), .BITS_PER_COLOR(BITS_PER_COLOR),
                      .PIPE_WIDTH(PIPE_WIDTH), .PIPE_CAP_HEIGHT(PIPE_CAP_HEIGHT), .BITS_PER_COLOR(BITS_PER_COLOR))
            pipe3Display(.inside_pipe(inside_pipe3), .colorData(pipe3_colorData),
                                .clk(clk), .x(x), .y(y), .pipe_reg(pipe3));
        PipeDisplay#(.SCREEN_WIDTH(SCREEN_WIDTH), .SCREEN_HEIGHT(SCREEN_HEIGHT), .BITS_PER_COLOR(BITS_PER_COLOR),
                     .PIPE_WIDTH(PIPE_WIDTH), .PIPE_CAP_HEIGHT(PIPE_CAP_HEIGHT), .BITS_PER_COLOR(BITS_PER_COLOR))
            pipe4Display(.inside_pipe(inside_pipe4), .colorData(pipe4_colorData),
                                .clk(clk), .x(x), .y(y), .pipe_reg(pipe4));


	// Quickly assign the output colors to their channels using concatenation

	wire game_underway = pipe1 != 32'b0 || pipe2 != 32'b0 || pipe3 != 32'b0 || pipe4 != 32'b0 ||
                         bird_top_left != 32'b0 || current_score != 32'b0;

	assign {VGA_R, VGA_G, VGA_B} =  !active ? 12'b0 :
	                                !game_underway ? splashScreenColorData :
	                                inside_pipe1 ? pipe1_colorData :
	                                inside_pipe2 ? pipe2_colorData :
	                                inside_pipe3 ? pipe3_colorData :
	                                inside_pipe4 ? pipe4_colorData :
	                                inside_bird ? birdColorData :
	                                backgroundColorData;

endmodule