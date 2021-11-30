`timescale 1 ns/ 100 ps
module VGAController(
	input clk, 			// 100 MHz System Clock
	input reset, 		// Reset Signal

	// Game inputs

	input jump,

	// Register Contents

	input[31:0] pipe1x,
	input[31:0] pipe2x,
    input[31:0] pipe3x,
    input[31:0] pipe4x,

    input[31:0] pipe1bottomtop,
    input[31:0] pipe2bottomtop,
    input[31:0] pipe3bottomtop,
    input[31:0] pipe4bottomtop,

    input[31:0] pipe1yspace,
    input[31:0] pipe2yspace,
    input[31:0] pipe3yspace,
    input[31:0] pipe4yspace,

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

        PIPE_WIDTH = 57,
        PIPE_CAP_HEIGHT = 0,     // 39

		BIRD_WIDTH = 47,
		BIRD_HEIGHT = 33,
		BIRD_LEFT_EDGE = 60,

		NUM_IMG_WIDTH = 378,
		NUM_HEIGHT = 45,
		SCORE_OFFSET_GAME = 40,
	    SCORE_OFFSET_SPLASH = TITLE_TOP_OFFSET*3 + TITLE_HEIGHT + NUM_HEIGHT,
	    SCORE_TEXT_WIDTH = 201,
	    SCORE_TEXT_HEIGHT = 43,

		TITLE_WIDTH = 370,
		TITLE_HEIGHT = 95,
		TITLE_TOP_OFFSET = 50;

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
                             pipe1_colorData, pipe2_colorData, pipe3_colorData, pipe4_colorData,
                             birdColorData,
                             scoreData, titleData, scoreLabelData;

    wire inside_pipe1, inside_pipe2, inside_pipe3, inside_pipe4,
         inside_bird,
         inside_score, inside_score_label,
         inside_title;


        // game background
        image #(.WIDTH(SCREEN_WIDTH), .HEIGHT(SCREEN_HEIGHT),
                .IMG_FILE("background_image.mem"),
                .CLR_FILE("background_colors.mem"))
        background(.clk(clk),
                    .imgAddress(x + SCREEN_WIDTH*y),
                    .colorData(backgroundColorData));

        TitleDisplay #(.BITS_PER_COLOR(BITS_PER_COLOR), .SCREEN_WIDTH(SCREEN_WIDTH), .SCREEN_HEIGHT(SCREEN_HEIGHT),
                       .TITLE_WIDTH(TITLE_WIDTH), .TITLE_HEIGHT(TITLE_HEIGHT), .TITLE_TOP_OFFSET(TITLE_TOP_OFFSET))
             titleDisplay(.inside_title(inside_title), .titleData(titleData),
                                 .clk(clk), .x(x), .y(y));

        HiScoreLabelDisplay #(.BITS_PER_COLOR(BITS_PER_COLOR), .SCREEN_WIDTH(SCREEN_WIDTH), .SCREEN_HEIGHT(SCREEN_HEIGHT),
                       .LABEL_WIDTH(SCORE_TEXT_WIDTH), .LABEL_HEIGHT(SCORE_TEXT_HEIGHT), .LABEL_TOP_OFFSET(TITLE_TOP_OFFSET*2 + TITLE_HEIGHT))
             hiscoreLabelDisplay(.inside_label(inside_score_label), .labelData(scoreLabelData),
                                 .clk(clk), .x(x), .y(y));

        // bird
        BirdDisplay #(.BITS_PER_COLOR(BITS_PER_COLOR),
                      .BIRD_LEFT_EDGE(BIRD_LEFT_EDGE), .BIRD_WIDTH(BIRD_WIDTH), .BIRD_HEIGHT(BIRD_HEIGHT))
            birdDisplay(.inside_bird(inside_bird), .colorData(birdColorData),
                                .clk(clk), .x(x), .y(y), .bird_top_edge(bird_top_left));


        // display for each of pipes

        PipeDisplay #(.SCREEN_HEIGHT(SCREEN_HEIGHT),
                      .PIPE_WIDTH(PIPE_WIDTH), .PIPE_CAP_HEIGHT(PIPE_CAP_HEIGHT), .BITS_PER_COLOR(BITS_PER_COLOR))
            pipe1Display(.inside_pipe(inside_pipe1), .colorData(pipe1_colorData),
                         .clk(clk), .x(x), .y(y),
                         .x_left_edge(pipe1x), .y_bottom_pipe_top(pipe1bottomtop), .y_gap_height(pipe1yspace));
       PipeDisplay #(.SCREEN_HEIGHT(SCREEN_HEIGHT),
                      .PIPE_WIDTH(PIPE_WIDTH), .PIPE_CAP_HEIGHT(PIPE_CAP_HEIGHT), .BITS_PER_COLOR(BITS_PER_COLOR))
            pipe2Display(.inside_pipe(inside_pipe2), .colorData(pipe2_colorData),
                         .clk(clk), .x(x), .y(y),
                         .x_left_edge(pipe2x), .y_bottom_pipe_top(pipe2bottomtop), .y_gap_height(pipe2yspace));
        PipeDisplay #(.SCREEN_HEIGHT(SCREEN_HEIGHT),
                      .PIPE_WIDTH(PIPE_WIDTH), .PIPE_CAP_HEIGHT(PIPE_CAP_HEIGHT), .BITS_PER_COLOR(BITS_PER_COLOR))
            pipe3Display(.inside_pipe(inside_pipe3), .colorData(pipe3_colorData),
                         .clk(clk), .x(x), .y(y),
                         .x_left_edge(pipe3x), .y_bottom_pipe_top(pipe3bottomtop), .y_gap_height(pipe3yspace));
        PipeDisplay#(.SCREEN_HEIGHT(SCREEN_HEIGHT),
                     .PIPE_WIDTH(PIPE_WIDTH), .PIPE_CAP_HEIGHT(PIPE_CAP_HEIGHT), .BITS_PER_COLOR(BITS_PER_COLOR))
            pipe4Display(.inside_pipe(inside_pipe4), .colorData(pipe4_colorData),
                         .clk(clk), .x(x), .y(y),
                         .x_left_edge(pipe4x), .y_bottom_pipe_top(pipe4bottomtop), .y_gap_height(pipe4yspace));

    ScoreDisplay #(.NUM_IMG_WIDTH(NUM_IMG_WIDTH), .NUM_HEIGHT(NUM_HEIGHT),
                    .SCREEN_WIDTH(SCREEN_WIDTH), .BITS_PER_COLOR(BITS_PER_COLOR))
        scoreDisplay(.inside_score(inside_score), .scoreData(scoreData),
                     .SCORE_OFFSET(game_underway ? SCORE_OFFSET_GAME : SCORE_OFFSET_SPLASH),
                     .score(!game_underway ? high_score : current_score),
                     .clk(clk), .x(x), .y(y));

	// Quickly assign the output colors to their channels using concatenation

	wire game_underway = pipe1bottomtop != 32'b0 || pipe2bottomtop != 32'b0 || pipe3bottomtop != 32'b0 || pipe4bottomtop != 32'b0 ||
	                     pipe1yspace != 32'b0 || pipe2yspace != 32'b0 || pipe3yspace != 32'b0 || pipe4yspace != 32'b0 ||
	                     pipe1x != 32'b0 || pipe2x != 32'b0 || pipe3x != 32'b0 || pipe4x != 32'b0 ||
                         bird_top_left != 32'b0 || current_score != 32'b0;

	assign {VGA_R, VGA_G, VGA_B} = inside_score ? scoreData :
	                               !game_underway ? (inside_title ? titleData :
	                                                 inside_score_label ? scoreLabelData :
	                                                 backgroundColorData) :
	                               inside_pipe1 ? pipe1_colorData :
	                               inside_pipe2 ? pipe2_colorData :
	                               inside_pipe3 ? pipe3_colorData :
	                               inside_pipe4 ? pipe4_colorData :
	                               inside_bird ? birdColorData :
	                               backgroundColorData;

endmodule