module decoder32(out, select, enable);
    input [4:0] select;
    input enable;
    output [31:0] out;

    wire [31:0] one32, zero32;

    assign zero32 = 32'b0;
    assign one32[31:1] = zero32[31:1];
    assign one32[0] = 1'b1;

    barrel_left_shifter left_shift(.out(out), .data_operand(enable ? one32 : zero32), .ctrl_shiftamt(select));
endmodule