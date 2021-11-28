module PipeDisplay #(parameter SCREEN_HEIGHT = 480,
                              PIPE_WIDTH = 70,  PIPE_CAP_HEIGHT = 10,
                              BITS_PER_COLOR = 12)
                   (clk,
                   x, y,
                   x_left_edge, y_bottom_pipe_top, y_gap_height,

                    // outputs
                    inside_pipe,
                    colorData);

    input clk;
    input[31:0] x_left_edge, y_bottom_pipe_top, y_gap_height;
    input[9:0] x;
    input[8:0] y;

    output inside_pipe;
    output [BITS_PER_COLOR-1:0] colorData;


    wire [BITS_PER_COLOR-1:0] pipeColorData, pipeCapColorData;

//    // extracts pipe information from register output
//    pipe_reg_parser pipe_reg_parser(.pipe_x_reg(pipe_regx), .pipe_y_reg(pipe_regy),
//                                   .pipe_left_edge(x_left_edge),
//                                   .pipe_space_center_y(y_gap_center), .pipe_space_height(y_gap_height));

    // an image of a pipe going from top to bottom. Actual pipe images are cropped from this based on height
    image #(.WIDTH(PIPE_WIDTH), .HEIGHT(SCREEN_HEIGHT),
            .IMG_FILE("pipe_shaft_image.mem"),
            .CLR_FILE("pipe_shaft_colors.mem"))
    pipeImage(.clk(clk),
               .imgAddress(inside_bottom_shaft ? // inside_bottom_shaft
                           x - x_left_edge + (PIPE_WIDTH*(y - y_bottom_pipe_top - PIPE_CAP_HEIGHT)) :
                           x - x_left_edge + PIPE_WIDTH*y), // inside_top_shaft
               .colorData(pipeColorData));

//    // an image of the cap of a pipe
//    image #(.WIDTH(PIPE_WIDTH), .HEIGHT(PIPE_CAP_HEIGHT),
//            .IMG_FILE("pipe_cap_image.mem"),
//            .CLR_FILE("pipe_cap_colors.mem"))
//    pipeCapImage(.clk(clk),
//                 .imgAddress(inside_bottom_cap ? // inside_bottom_shaft
//                                            x - x_left_edge + PIPE_WIDTH*(y - y_bottom_pipe_top) :
//                                            x - x_left_edge + PIPE_WIDTH*(y - y_top_pipe_bottom - PIPE_CAP_HEIGHT)), // inside_top_shaft
//                 .colorData(pipeCapColorData));


    // what part of the pipe to display
    wire [9:0] x_right_edge = x_left_edge + PIPE_WIDTH;
    wire [8:0] y_top_pipe_bottom = y_bottom_pipe_top - y_gap_height;

    wire inside_pipe_x = x >= x_left_edge &&
                      x <= x_right_edge &&
                      y_gap_height != 32'b0 && y_bottom_pipe_top != 32'b0; // if pipe reg is all 0, means there's no pipe, so can't be inside it

    wire inside_top_shaft = inside_pipe_x && y <= y_top_pipe_bottom - PIPE_CAP_HEIGHT;
    wire inside_bottom_shaft = inside_pipe_x && y >= y_bottom_pipe_top + PIPE_CAP_HEIGHT;

    wire inside_top_cap = y <= y_top_pipe_bottom && y >= y_top_pipe_bottom - PIPE_CAP_HEIGHT;
    wire inside_bottom_cap = y >= y_bottom_pipe_top && y <= y_bottom_pipe_top + PIPE_CAP_HEIGHT;

    // output

    assign inside_pipe = inside_top_shaft || inside_bottom_shaft || inside_top_cap || inside_bottom_cap;
    assign colorData = inside_top_cap || inside_bottom_cap ? pipeCapColorData : pipeColorData;


endmodule
