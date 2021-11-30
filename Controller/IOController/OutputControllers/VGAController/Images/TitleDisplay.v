module TitleDisplay #(parameter SCREEN_WIDTH = 640, SCREEN_HEIGHT = 480, BITS_PER_COLOR = 12,
                               TITLE_WIDTH = 249, TITLE_HEIGHT = 246)
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
                    .imgAddress(x - TITLE_WIDTH + TITLE_WIDTH*(y-TITLE_HEIGHT)),
                    .colorData(titleData));

    assign inside_title = y >= (SCREEN_HEIGHT - TITLE_HEIGHT) / 2 &&
                          y <= (SCREEN_HEIGHT + TITLE_HEIGHT) / 2 &&
                          x >= (SCREEN_WIDTH - TITLE_WIDTH) / 2 &&
                          x <= (SCREEN_WIDTH + TITLE_WIDTH) / 2;


endmodule