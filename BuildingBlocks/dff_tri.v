module dff_tri(out, d, clk, clr, in_enable, out_enable);
    input d, clk, clr, in_enable, out_enable;

    output out;

    wire q;

    dffe_ref dffe(.d(d), .clk(clk), .clr(clr), .en(in_enable), .q(q));
    assign out = out_enable ? q : 1'bz;
endmodule