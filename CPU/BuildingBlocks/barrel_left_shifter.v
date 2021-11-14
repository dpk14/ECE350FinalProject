module barrel_left_shifter(out, data_operand, ctrl_shiftamt);

    input [31:0] data_operand;
    input [4:0] ctrl_shiftamt;

    output [31:0] out;

    wire [31:0] out1, out2, out3, out4;

    assign out4[31:16] = ctrl_shiftamt[4] ? data_operand[15:0] : data_operand[31:16];
    assign out4[15:0] = ctrl_shiftamt[4] ? 16'b0 : data_operand[15:0];

    assign out3[31:8] = ctrl_shiftamt[3] ? out4[23:0] : out4[31:8];
    assign out3[7:0] = ctrl_shiftamt[3] ? 8'b0 : out4[7:0];

    assign out2[31:4] = ctrl_shiftamt[2] ? out3[27:0] : out3[31:4];
    assign out2[3:0] = ctrl_shiftamt[2] ? 4'b0 : out3[3:0];

    assign out1[31:2] = ctrl_shiftamt[1] ? out2[29:0] : out2[31:2];
    assign out1[1:0] = ctrl_shiftamt[1] ? 2'b0 : out2[1:0];

    assign out[31:1] = ctrl_shiftamt[0] ? out1[30:0] : out1[31:1];
    assign out[0] = ctrl_shiftamt[0] ? 1'b0 : out1[0];

endmodule