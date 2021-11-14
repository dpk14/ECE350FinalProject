
module reg_32(out, in, clk, clr, in_enable, out_enable);
    input [31:0] in;
    input clk, clr, in_enable, out_enable;

    output [31:0] out;

    wire q;

    dff_tri dff_tri0(.out(out[0]),.d(in[0]), .clk(clk),.clr(clr),.in_enable(in_enable), .out_enable(out_enable));
    dff_tri dff_tri1(.out(out[1]),.d(in[1]), .clk(clk),.clr(clr),.in_enable(in_enable), .out_enable(out_enable));
    dff_tri dff_tri2(.out(out[2]),.d(in[2]), .clk(clk),.clr(clr),.in_enable(in_enable), .out_enable(out_enable));
    dff_tri dff_tri3(.out(out[3]),.d(in[3]), .clk(clk),.clr(clr),.in_enable(in_enable), .out_enable(out_enable));
    dff_tri dff_tri4(.out(out[4]),.d(in[4]), .clk(clk),.clr(clr),.in_enable(in_enable), .out_enable(out_enable));
    dff_tri dff_tri5(.out(out[5]),.d(in[5]), .clk(clk),.clr(clr),.in_enable(in_enable), .out_enable(out_enable));
    dff_tri dff_tri6(.out(out[6]),.d(in[6]), .clk(clk),.clr(clr),.in_enable(in_enable), .out_enable(out_enable));
    dff_tri dff_tri7(.out(out[7]),.d(in[7]), .clk(clk),.clr(clr),.in_enable(in_enable), .out_enable(out_enable));
    dff_tri dff_tri8(.out(out[8]),.d(in[8]), .clk(clk),.clr(clr),.in_enable(in_enable), .out_enable(out_enable));
    dff_tri dff_tri9(.out(out[9]),.d(in[9]), .clk(clk),.clr(clr),.in_enable(in_enable), .out_enable(out_enable));
    dff_tri dff_tri10(.out(out[10]),.d(in[10]), .clk(clk),.clr(clr),.in_enable(in_enable), .out_enable(out_enable));
    dff_tri dff_tri11(.out(out[11]),.d(in[11]), .clk(clk),.clr(clr),.in_enable(in_enable), .out_enable(out_enable));
    dff_tri dff_tri12(.out(out[12]),.d(in[12]), .clk(clk),.clr(clr),.in_enable(in_enable), .out_enable(out_enable));
    dff_tri dff_tri13(.out(out[13]),.d(in[13]), .clk(clk),.clr(clr),.in_enable(in_enable), .out_enable(out_enable));
    dff_tri dff_tri14(.out(out[14]),.d(in[14]), .clk(clk),.clr(clr),.in_enable(in_enable), .out_enable(out_enable));
    dff_tri dff_tri15(.out(out[15]),.d(in[15]), .clk(clk),.clr(clr),.in_enable(in_enable), .out_enable(out_enable));
    dff_tri dff_tri16(.out(out[16]),.d(in[16]), .clk(clk),.clr(clr),.in_enable(in_enable), .out_enable(out_enable));
    dff_tri dff_tri17(.out(out[17]),.d(in[17]), .clk(clk),.clr(clr),.in_enable(in_enable), .out_enable(out_enable));
    dff_tri dff_tri18(.out(out[18]),.d(in[18]), .clk(clk),.clr(clr),.in_enable(in_enable), .out_enable(out_enable));
    dff_tri dff_tri19(.out(out[19]),.d(in[19]), .clk(clk),.clr(clr),.in_enable(in_enable), .out_enable(out_enable));
    dff_tri dff_tri20(.out(out[20]),.d(in[20]), .clk(clk),.clr(clr),.in_enable(in_enable), .out_enable(out_enable));
    dff_tri dff_tri21(.out(out[21]),.d(in[21]), .clk(clk),.clr(clr),.in_enable(in_enable), .out_enable(out_enable));
    dff_tri dff_tri22(.out(out[22]),.d(in[22]), .clk(clk),.clr(clr),.in_enable(in_enable), .out_enable(out_enable));
    dff_tri dff_tri23(.out(out[23]),.d(in[23]), .clk(clk),.clr(clr),.in_enable(in_enable), .out_enable(out_enable));
    dff_tri dff_tri24(.out(out[24]),.d(in[24]), .clk(clk),.clr(clr),.in_enable(in_enable), .out_enable(out_enable));
    dff_tri dff_tri25(.out(out[25]),.d(in[25]), .clk(clk),.clr(clr),.in_enable(in_enable), .out_enable(out_enable));
    dff_tri dff_tri26(.out(out[26]),.d(in[26]), .clk(clk),.clr(clr),.in_enable(in_enable), .out_enable(out_enable));
    dff_tri dff_tri27(.out(out[27]),.d(in[27]), .clk(clk),.clr(clr),.in_enable(in_enable), .out_enable(out_enable));
    dff_tri dff_tri28(.out(out[28]),.d(in[28]), .clk(clk),.clr(clr),.in_enable(in_enable), .out_enable(out_enable));
    dff_tri dff_tri29(.out(out[29]),.d(in[29]), .clk(clk),.clr(clr),.in_enable(in_enable), .out_enable(out_enable));
    dff_tri dff_tri30(.out(out[30]),.d(in[30]), .clk(clk),.clr(clr),.in_enable(in_enable), .out_enable(out_enable));
    dff_tri dff_tri31(.out(out[31]),.d(in[31]), .clk(clk),.clr(clr),.in_enable(in_enable), .out_enable(out_enable));

endmodule