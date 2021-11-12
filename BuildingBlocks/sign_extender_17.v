module sign_extender_17(in, out);

    input [16:0] in;
    output [31:0] out;

    wire [31:0] zeros, ones;
    assign zeros = 32'b0;
    assign ones = ~zeros;

    assign out[16:0] = in[16:0];
    assign out[31:17] = in[16] ? ones[31:17] : zeros[31:17];

endmodule