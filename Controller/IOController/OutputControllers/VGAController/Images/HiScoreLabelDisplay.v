module HiScoreLabelDisplay  #(parameter SCREEN_WIDTH = 640, SCREEN_HEIGHT = 480, BITS_PER_COLOR = 12,
                                        LABEL_WIDTH = 249, LABEL_HEIGHT = 246, LABEL_TOP_OFFSET = 60)
                      (clk,
                      x, y,

                       // outputs
                       inside_label,
                       labelData);

       input clk;
       input[9:0] x;
       input[8:0] y;

       output inside_label;
       output [BITS_PER_COLOR-1:0] labelData;

       image #(.WIDTH(LABEL_WIDTH), .HEIGHT(LABEL_HEIGHT),
                       .IMG_FILE("scoretext_image.mem"),
                       .CLR_FILE("scoretext_colors.mem"))
               hiscoreLabel(.clk(clk),
                       .imgAddress(x - ((SCREEN_WIDTH - LABEL_WIDTH) / 2) + LABEL_WIDTH*(y-LABEL_TOP_OFFSET)),
                       .colorData(labelData));

       assign inside_label = y >= LABEL_TOP_OFFSET &&
                             y <= LABEL_TOP_OFFSET + LABEL_HEIGHT &&
                             x >= (SCREEN_WIDTH - LABEL_WIDTH) / 2 &&
                             x <= (SCREEN_WIDTH + LABEL_WIDTH) / 2;


   endmodule