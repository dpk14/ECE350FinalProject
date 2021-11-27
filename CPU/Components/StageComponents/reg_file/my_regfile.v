module my_regfile (
	clock,
	ctrl_writeEnable, ctrl_reset, ctrl_writeReg,
	ctrl_readRegA, ctrl_readRegB, data_writeReg,
	data_readRegA, data_readRegB,
	reg_out0, reg_out1, reg_out2, reg_out3, reg_out4, reg_out5, reg_out6, reg_out7, reg_out8, reg_out9, reg_out10,
    reg_out11, reg_out12, reg_out13, reg_out14, reg_out15, reg_out16, reg_out17, reg_out18, reg_out19, reg_out20,
    reg_out21, reg_out22, reg_out23, reg_out24, reg_out25, reg_out26, reg_out27, reg_out28, reg_out29, reg_out30, reg_out31
);

	input clock, ctrl_writeEnable, ctrl_reset;
	input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	input [31:0] data_writeReg;

	output [31:0] data_readRegA, data_readRegB;

	wire [31:0] decoder_out;

	output [31:0] reg_out0, reg_out1, reg_out2, reg_out3, reg_out4, reg_out5, reg_out6, reg_out7, reg_out8, reg_out9, reg_out10,
	reg_out11, reg_out12, reg_out13, reg_out14, reg_out15, reg_out16, reg_out17, reg_out18, reg_out19, reg_out20,
	reg_out21, reg_out22, reg_out23, reg_out24, reg_out25, reg_out26, reg_out27, reg_out28, reg_out29, reg_out30, reg_out31;

	decoder32 decoder(.out(decoder_out), .select(ctrl_writeReg), .enable(ctrl_writeEnable));

    assign reg_out0 = 32'b0;
	reg_32 reg1(.out(reg_out1), .in(data_writeReg), .clk(clock), .clr(ctrl_reset), .in_enable(decoder_out[1]), .out_enable(1'b1));
	reg_32 reg2(.out(reg_out2), .in(data_writeReg), .clk(clock), .clr(ctrl_reset), .in_enable(decoder_out[2]), .out_enable(1'b1));
	reg_32 reg3(.out(reg_out3), .in(data_writeReg), .clk(clock), .clr(ctrl_reset), .in_enable(decoder_out[3]), .out_enable(1'b1));
	reg_32 reg4(.out(reg_out4), .in(data_writeReg), .clk(clock), .clr(ctrl_reset), .in_enable(decoder_out[4]), .out_enable(1'b1));
	reg_32 reg5(.out(reg_out5), .in(data_writeReg), .clk(clock), .clr(ctrl_reset), .in_enable(decoder_out[5]), .out_enable(1'b1));
	reg_32 reg6(.out(reg_out6), .in(data_writeReg), .clk(clock), .clr(ctrl_reset), .in_enable(decoder_out[6]), .out_enable(1'b1));
	reg_32 reg7(.out(reg_out7), .in(data_writeReg), .clk(clock), .clr(ctrl_reset), .in_enable(decoder_out[7]), .out_enable(1'b1));
	reg_32 reg8(.out(reg_out8), .in(data_writeReg), .clk(clock), .clr(ctrl_reset), .in_enable(decoder_out[8]), .out_enable(1'b1));
	reg_32 reg9(.out(reg_out9), .in(data_writeReg), .clk(clock), .clr(ctrl_reset), .in_enable(decoder_out[9]), .out_enable(1'b1));
	reg_32 reg10(.out(reg_out10), .in(data_writeReg), .clk(clock), .clr(ctrl_reset), .in_enable(decoder_out[10]), .out_enable(1'b1));
	reg_32 reg11(.out(reg_out11), .in(data_writeReg), .clk(clock), .clr(ctrl_reset), .in_enable(decoder_out[11]), .out_enable(1'b1));
	reg_32 reg12(.out(reg_out12), .in(data_writeReg), .clk(clock), .clr(ctrl_reset), .in_enable(decoder_out[12]), .out_enable(1'b1));
	reg_32 reg13(.out(reg_out13), .in(data_writeReg), .clk(clock), .clr(ctrl_reset), .in_enable(decoder_out[13]), .out_enable(1'b1));
	reg_32 reg14(.out(reg_out14), .in(data_writeReg), .clk(clock), .clr(ctrl_reset), .in_enable(decoder_out[14]), .out_enable(1'b1));
	reg_32 reg15(.out(reg_out15), .in(data_writeReg), .clk(clock), .clr(ctrl_reset), .in_enable(decoder_out[15]), .out_enable(1'b1));
	reg_32 reg16(.out(reg_out16), .in(data_writeReg), .clk(clock), .clr(ctrl_reset), .in_enable(decoder_out[16]), .out_enable(1'b1));
	reg_32 reg17(.out(reg_out17), .in(data_writeReg), .clk(clock), .clr(ctrl_reset), .in_enable(decoder_out[17]), .out_enable(1'b1));
	reg_32 reg18(.out(reg_out18), .in(data_writeReg), .clk(clock), .clr(ctrl_reset), .in_enable(decoder_out[18]), .out_enable(1'b1));
	reg_32 reg19(.out(reg_out19), .in(data_writeReg), .clk(clock), .clr(ctrl_reset), .in_enable(decoder_out[19]), .out_enable(1'b1));
	reg_32 reg20(.out(reg_out20), .in(data_writeReg), .clk(clock), .clr(ctrl_reset), .in_enable(decoder_out[20]), .out_enable(1'b1));
	reg_32 reg21(.out(reg_out21), .in(data_writeReg), .clk(clock), .clr(ctrl_reset), .in_enable(decoder_out[21]), .out_enable(1'b1));
	reg_32 reg22(.out(reg_out22), .in(data_writeReg), .clk(clock), .clr(ctrl_reset), .in_enable(decoder_out[22]), .out_enable(1'b1));
	reg_32 reg23(.out(reg_out23), .in(data_writeReg), .clk(clock), .clr(ctrl_reset), .in_enable(decoder_out[23]), .out_enable(1'b1));
	reg_32 reg24(.out(reg_out24), .in(data_writeReg), .clk(clock), .clr(ctrl_reset), .in_enable(decoder_out[24]), .out_enable(1'b1));
	reg_32 reg25(.out(reg_out25), .in(data_writeReg), .clk(clock), .clr(ctrl_reset), .in_enable(decoder_out[25]), .out_enable(1'b1));
	reg_32 reg26(.out(reg_out26), .in(data_writeReg), .clk(clock), .clr(ctrl_reset), .in_enable(decoder_out[26]), .out_enable(1'b1));
	reg_32 reg27(.out(reg_out27), .in(data_writeReg), .clk(clock), .clr(ctrl_reset), .in_enable(decoder_out[27]), .out_enable(1'b1));
	reg_32 reg28(.out(reg_out28), .in(data_writeReg), .clk(clock), .clr(ctrl_reset), .in_enable(decoder_out[28]), .out_enable(1'b1));
	reg_32 reg29(.out(reg_out29), .in(data_writeReg), .clk(clock), .clr(ctrl_reset), .in_enable(decoder_out[29]), .out_enable(1'b1));
	reg_32 reg30(.out(reg_out30), .in(data_writeReg), .clk(clock), .clr(ctrl_reset), .in_enable(decoder_out[30]), .out_enable(1'b1));
	reg_32 reg31(.out(reg_out31), .in(data_writeReg), .clk(clock), .clr(ctrl_reset), .in_enable(decoder_out[31]), .out_enable(1'b1));

	tri_state_mux outMuxA(.out(data_readRegA), .select(ctrl_readRegA),
        .in0(reg_out0), .in1(reg_out1), .in2(reg_out2), .in3(reg_out3), .in4(reg_out4), .in5(reg_out5), .in6(reg_out6),
        .in7(reg_out7), .in8(reg_out8), .in9(reg_out9), .in10(reg_out10), .in11(reg_out11), .in12(reg_out12), .in13(reg_out13),
        .in14(reg_out14), .in15(reg_out15), .in16(reg_out16), .in17(reg_out17), .in18(reg_out18), .in19(reg_out19),
        .in20(reg_out20), .in21(reg_out21), .in22(reg_out22), .in23(reg_out23), .in24(reg_out24), .in25(reg_out25),
        .in26(reg_out26), .in27(reg_out27), .in28(reg_out28), .in29(reg_out29), .in30(reg_out30), .in31(reg_out31));

    tri_state_mux outMuxB(.out(data_readRegB), .select(ctrl_readRegB),
        .in0(reg_out0), .in1(reg_out1), .in2(reg_out2), .in3(reg_out3), .in4(reg_out4), .in5(reg_out5), .in6(reg_out6),
        .in7(reg_out7), .in8(reg_out8), .in9(reg_out9), .in10(reg_out10), .in11(reg_out11), .in12(reg_out12), .in13(reg_out13),
        .in14(reg_out14), .in15(reg_out15), .in16(reg_out16), .in17(reg_out17), .in18(reg_out18), .in19(reg_out19),
        .in20(reg_out20), .in21(reg_out21), .in22(reg_out22), .in23(reg_out23), .in24(reg_out24), .in25(reg_out25),
        .in26(reg_out26), .in27(reg_out27), .in28(reg_out28), .in29(reg_out29), .in30(reg_out30), .in31(reg_out31));

endmodule
