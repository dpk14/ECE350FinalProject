module pipe_reg_parser(pipe_x_reg, pipe_y_reg, pipe_left_edge, pipe_space_center_y, pipe_space_height);
    input [31:0] pipe_x_reg, pipe_y_reg;
    output [9:0] pipe_left_edge;
    output [8:0] pipe_space_center_y, pipe_space_height;

    assign pipe_left_edge = pipe_x_reg;
    assign pipe_space_center_y = pipe_y_reg[15:8];
    assign pipe_space_height = pipe_y_reg[7:0];

endmodule