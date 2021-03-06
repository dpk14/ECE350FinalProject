module BirdDisplay #(parameter BIRD_LEFT_EDGE = 90, BIRD_WIDTH = 35, BIRD_HEIGHT = 35,
                               BITS_PER_COLOR = 12)
                   (clk,
                   x, y,
                   bird_top_edge,

                    // outputs
                    inside_bird,
                    colorData);

    input clk;
    input[31:0] bird_top_edge;
    input[9:0] x;
    input[8:0] y;

    output inside_bird;
    output [BITS_PER_COLOR-1:0] colorData;

    wire [BITS_PER_COLOR-1:0] pipeColorData, pipeCapColorData;
    wire [9:0] x_left_edge;
    wire [8:0] y_gap_center, y_gap_height;

    // bird
    image #(.WIDTH(BIRD_WIDTH), .HEIGHT(BIRD_HEIGHT),
            .IMG_FILE("bird_image.mem"),
            .CLR_FILE("bird_colors.mem"))
    birdImage(.clk(clk),
                .imgAddress(x - BIRD_LEFT_EDGE + BIRD_WIDTH*(y - bird_top_edge)),
                .colorData(colorData));

    assign inside_bird = y >= bird_top_edge &&
                         y <= bird_top_edge + BIRD_HEIGHT &&
                         x >= BIRD_LEFT_EDGE &&
                         x <= BIRD_LEFT_EDGE + BIRD_WIDTH;

endmodule