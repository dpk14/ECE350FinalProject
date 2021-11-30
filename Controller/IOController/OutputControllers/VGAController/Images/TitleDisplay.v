module TitleDisplay #(parameter SCREEN_WIDTH = 640, SCREEN_HEIGHT = 480, BITS_PER_COLOR = 12,
                               TITLE_WIDTH = 249, TITLE_HEIGHT = 95, TITLE_TOP_OFFSET = 60)
                   (clk,
                   x, y,

                    // outputs
                    inside_title,
                    titleData);

    input clk;
    input[9:0] x;
    input[8:0] y;

    output inside_title;
    output [BITS_PER_COLOR-1:0] titleData;

    image #(.WIDTH(TITLE_WIDTH), .HEIGHT(TITLE_HEIGHT),
                    .IMG_FILE("title_image.mem"),
                    .CLR_FILE("title_colors.mem"))
            splash(.clk(clk),
                    .imgAddress(x - ((SCREEN_WIDTH - TITLE_WIDTH) / 2) + TITLE_WIDTH*(y-TITLE_TOP_OFFSET)),
                    .colorData(titleData));

    assign inside_title = y >= TITLE_TOP_OFFSET &&
                          y <= TITLE_TOP_OFFSET + TITLE_HEIGHT &&
                          x >= (SCREEN_WIDTH - TITLE_WIDTH) / 2 &&
                          x <= (SCREEN_WIDTH + TITLE_WIDTH) / 2;


endmodule