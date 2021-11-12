module bitwise_and(out, data_operandA, data_operandB);

    input [31:0] data_operandA, data_operandB;

    output [31:0] out;

    and AND0(out[0], data_operandA[0], data_operandB[0]);
    and AND1(out[1], data_operandA[1], data_operandB[1]);
    and AND2(out[2], data_operandA[2], data_operandB[2]);
    and AND3(out[3], data_operandA[3], data_operandB[3]);
    and AND4(out[4], data_operandA[4], data_operandB[4]);
    and AND5(out[5], data_operandA[5], data_operandB[5]);
    and AND6(out[6], data_operandA[6], data_operandB[6]);
    and AND7(out[7], data_operandA[7], data_operandB[7]);
    and AND8(out[8], data_operandA[8], data_operandB[8]);
    and AND9(out[9], data_operandA[9], data_operandB[9]);
    and AND10(out[10], data_operandA[10], data_operandB[10]);
    and AND11(out[11], data_operandA[11], data_operandB[11]);
    and AND12(out[12], data_operandA[12], data_operandB[12]);
    and AND13(out[13], data_operandA[13], data_operandB[13]);
    and AND14(out[14], data_operandA[14], data_operandB[14]);
    and AND15(out[15], data_operandA[15], data_operandB[15]);
    and AND16(out[16], data_operandA[16], data_operandB[16]);
    and AND17(out[17], data_operandA[17], data_operandB[17]);
    and AND18(out[18], data_operandA[18], data_operandB[18]);
    and AND19(out[19], data_operandA[19], data_operandB[19]);
    and AND20(out[20], data_operandA[20], data_operandB[20]);
    and AND21(out[21], data_operandA[21], data_operandB[21]);
    and AND22(out[22], data_operandA[22], data_operandB[22]);
    and AND23(out[23], data_operandA[23], data_operandB[23]);
    and AND24(out[24], data_operandA[24], data_operandB[24]);
    and AND25(out[25], data_operandA[25], data_operandB[25]);
    and AND26(out[26], data_operandA[26], data_operandB[26]);
    and AND27(out[27], data_operandA[27], data_operandB[27]);
    and AND28(out[28], data_operandA[28], data_operandB[28]);
    and AND29(out[29], data_operandA[29], data_operandB[29]);
    and AND30(out[30], data_operandA[30], data_operandB[30]);
    and AND31(out[31], data_operandA[31], data_operandB[31]);

endmodule