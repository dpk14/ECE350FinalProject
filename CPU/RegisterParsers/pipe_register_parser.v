module pipe_reg_parser(pipe_reg, pipe_left_edge, pipe_space_center_y, pipe_space_height);
    input [31:0] pipe_reg;
    output [9:0] pipe_left_edge;
    output [8:0] pipe_space_center_y, pipe_space_height;

    assign pipe_left_edge = pipe_reg[31:21];
    assign pipe_space_center_y = pipe_reg[20:11];
    assign pipe_space_height = pipe_reg[10:1];

endmodule