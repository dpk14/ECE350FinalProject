module two_level_carry_lookahead(s, c32, data_operandA, data_operandB, c0);

    input [31:0] data_operandA, data_operandB;
    input c0;

    output [31:0] s;
    output c32;

    wire c8, c16, c24,
         pc0, pc1, pc2, pc3,
         g0, g1, g2, g3,
         p0, p1, p2, p3;

    // carry

    carry_lookahead_8bit adderBlock0(.s(s[7:0]),.gout(g0),.pout(p0),.data_operandA(data_operandA[7:0]),.data_operandB(data_operandB[7:0]),.c0(c0));
    and PC0(pc0, p0, c0);
    or C8(c8, g0, pc0);

    carry_lookahead_8bit adderBlock1(.s(s[15:8]),.gout(g1),.pout(p1),.data_operandA(data_operandA[15:8]),.data_operandB(data_operandB[15:8]),.c0(c8));
    and PC1(pc1, p1, c8);
    or C16(c16, g1, pc1);

    carry_lookahead_8bit adderBlock2(.s(s[23:16]),.gout(g2),.pout(p2),.data_operandA(data_operandA[23:16]),.data_operandB(data_operandB[23:16]),.c0(c16));
    and PC2(pc2, p2, c16);
    or C24(c24, g2, pc2);

    carry_lookahead_8bit adderBlock3(.s(s[31:24]),.gout(g3),.pout(p3),.data_operandA(data_operandA[31:24]),.data_operandB(data_operandB[31:24]),.c0(c24));
    and PC3(pc3, p3, c24);
    or C32(c32, g3, pc3);

endmodule