module carry_lookahead_8bit(s, gout, pout, data_operandA, data_operandB, c0);

    input [7:0] data_operandA, data_operandB;
    input c0;

    output [7:0] s;
    output gout, pout;

    // carry

    wire g0, p0, pc0,
        c1, g1, p1, pc1,
        c2, g2, p2, pc2,
        c3, g3, p3, pc3,
        c4, g4, p4, pc4,
        c5, g5, p5, pc5,
        c6, g6, p6, pc6,
        c7, g7, p7, pc7;

    and G0(g0, data_operandA[0], data_operandB[0]);
    or P0(p0, data_operandA[0], data_operandB[0]);
    and PC0(pc0, c0, p0);
    or C1(c1, g0, pc0);

    and G1(g1, data_operandA[1], data_operandB[1]);
    or P1(p1, data_operandA[1], data_operandB[1]);
    and PC1(pc1, c1, p1);
    or C2(c2, g1, pc1);

    and G2(g2, data_operandA[2], data_operandB[2]);
    or P2(p2, data_operandA[2], data_operandB[2]);
    and PC2(pc2, c2, p2);
    or C3(c3, g2, pc2);

    and G3(g3, data_operandA[3], data_operandB[3]);
    or P3(p3, data_operandA[3], data_operandB[3]);
    and PC3(pc3, c3, p3);
    or C4(c4, g3, pc3);

    and G4(g4, data_operandA[4], data_operandB[4]);
    or P4(p4, data_operandA[4], data_operandB[4]);
    and PC4(pc4, c4, p4);
    or C5(c5, g4, pc4);

    and G5(g5, data_operandA[5], data_operandB[5]);
    or P5(p5, data_operandA[5], data_operandB[5]);
    and PC5(pc5, c5, p5);
    or C6(c6, g5, pc5);

    and G6(g6, data_operandA[6], data_operandB[6]);
    or P6(p6, data_operandA[6], data_operandB[6]);
    and PC6(pc6, c6, p6);
    or C7(c7, g6, pc6);

    and G7(g7, data_operandA[7], data_operandB[7]);
    or P7(p7, data_operandA[7], data_operandB[7]);

    // sum

    xor SUM0(s[0], data_operandA[0], data_operandB[0], c0);
    xor SUM1(s[1], data_operandA[1], data_operandB[1], c1);
    xor SUM2(s[2], data_operandA[2], data_operandB[2], c2);
    xor SUM3(s[3], data_operandA[3], data_operandB[3], c3);
    xor SUM4(s[4], data_operandA[4], data_operandB[4], c4);
    xor SUM5(s[5], data_operandA[5], data_operandB[5], c5);
    xor SUM6(s[6], data_operandA[6], data_operandB[6], c6);
    xor SUM7(s[7], data_operandA[7], data_operandB[7], c7);

    // propogate & generate functions

    wire p7_thru_g6_and,
         p7_thru_g5_and,
         p7_thru_g4_and,
         p7_thru_g3_and,
         p7_thru_g2_and,
         p7_thru_g1_and,
         p7_thru_g0_and;

    and p7THRUg6AND(p7_thru_g6_and, p7, g6);
    and p7THRUg5AND(p7_thru_g5_and, p7, p6, g5);
    and p7THRUg4AND(p7_thru_g4_and, p7, p5, p6, g4);
    and p7THRUg3AND(p7_thru_g3_and, p7, p4, p5, p6, g3);
    and p7THRUg2AND(p7_thru_g2_and, p7, p3, p4, p5, p6, g2);
    and p7THRUg1AND(p7_thru_g1_and, p7, p2, p3, p4, p5, p6, g1);
    and p7THRUg0AND(p7_thru_g0_and, p7, p1, p2, p3, p4, p5, p6, g0);

    and pOUT(pout, p7, p6, p5, p4, p3, p2, p1, p0);
    or gOUT(gout, g7, p7_thru_g6_and, p7_thru_g5_and, p7_thru_g4_and, p7_thru_g3_and, p7_thru_g2_and, p7_thru_g1_and, p7_thru_g0_and);

endmodule