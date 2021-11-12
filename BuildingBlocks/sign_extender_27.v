module sign_extender_27(in, out);

    input [26:0] in;
    output [31:0] out;

    wire [31:0] zeros, ones;
    assign zeros = 32'b0;
    assign ones = ~zeros;

    assign out[26:0] = in[26:0];
    assign out[31:27] = in[26] ? ones[31:27] : zeros[31:27];

endmodule