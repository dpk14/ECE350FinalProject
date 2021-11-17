module BirdDisplay #(parameter SCREEN_WIDTH = 640, SCREEN_HEIGHT = 480,
                              BIRD_LEFT_EDGE = 90, BIRD_WIDTH = 35, BIRD_HEIGHT = 35,
                              BITS_PER_COLOR = 12)
                   (clk,
                   x, y,
                   bird_reg,

                    // outputs
                    inside_bird,
                    colorData);

    input clk;
    input[31:0] bird_reg;
    input[9:0] x;
    input[8:0] y;

    output inside_bird;
    output [BITS_PER_COLOR-1:0] colorData;

    // parsing
    wire bird_top_edge = bird_reg;

    wire [BITS_PER_COLOR-1:0] pipeColorData, pipeCapColorData;
    wire [9:0] x_left_edge;
    wire [8:0] y_gap_center, y_gap_height;

    // bird
    image #(.WIDTH(SCREEN_WIDTH), .HEIGHT(SCREEN_HEIGHT),
            .IMG_FILE("backgroundImage.mem"),
            .CLR_FILE("backgroundColors.mem"))
    birdImage(.clk(clk),
                .imgAddress(x - BIRD_LEFT_EDGE + 640*(y - bird_top_edge)),
                .colorData(colorData));

    assign inside_bird = y >= bird_top_edge &&
                         y <= bird_top_edge + BIRD_HEIGHT &&
                         x >= BIRD_LEFT_EDGE &&
                         x >= BIRD_LEFT_EDGE + BIRD_WIDTH;

endmodule