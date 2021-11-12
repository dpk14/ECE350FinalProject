module barrel_right_shifter(out, data_operand, ctrl_shiftamt);

    input [31:0] data_operand;
    input [4:0] ctrl_shiftamt;

    output [31:0] out;

    wire [31:0] out1, out2, out3, out4, stringOf1s;

    bitwise_not reverse0(stringOf1s, 32'b0);

    assign out4[15:0] = ctrl_shiftamt[4] ? data_operand[31:16] : data_operand[15:0];
    assign out4[31:16] = ctrl_shiftamt[4] ? data_operand[31] ? stringOf1s[15:0] : 16'b0 : data_operand[31:16];

    assign out3[23:0] = ctrl_shiftamt[3] ? out4[31:8] : out4[23:0];
    assign out3[31:24] = ctrl_shiftamt[3] ? out4[31] ? stringOf1s[7:0] : 8'b0 : out4[31:24];

    assign out2[27:0] = ctrl_shiftamt[2] ? out3[31:4] : out3[27:0];
    assign out2[31:28] = ctrl_shiftamt[2] ? out3[31] ? stringOf1s[4:0] : 4'b0 : out3[31:28];

    assign out1[29:0] = ctrl_shiftamt[1] ? out2[31:2] : out2[29:0];
    assign out1[31:30] = ctrl_shiftamt[1] ? out2[31] ? stringOf1s[2:0] : 2'b0 : out2[31:30];

    assign out[30:0] = ctrl_shiftamt[0] ? out1[31:1] : out1[30:0];
    assign out[31] = out1[31];

endmodule