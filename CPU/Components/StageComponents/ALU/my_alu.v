module my_alu(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow);
        
    input [31:0] data_operandA, data_operandB;
    input [4:0] ctrl_ALUopcode, ctrl_shiftamt;

    output [31:0] data_result;
    output isNotEqual, isLessThan, overflow;

    // misc
    wire [31:0] bitwiseAnd, bitwiseOr, bitwiseNotB;

    // adder
    wire [31:0] sum, difference;
    wire c32_add, c32_subtract, operand_signs_match, overflow_intermediate, operand_b_sign;

    // shifters
    wire [31:0] left_shifted, right_shifted;

    bitwise_and bitwiseAndGate(bitwiseAnd, data_operandA, data_operandB);
    bitwise_or bitwiseOrGate(bitwiseOr, data_operandA, data_operandB);
    bitwise_not bitwiseNotBGate(bitwiseNotB, data_operandB);

    two_level_carry_lookahead adder(sum, c32_add, data_operandA, data_operandB, 1'b0);
    two_level_carry_lookahead subtracter(difference, c32_subtract, data_operandA, bitwiseNotB, 1'b1);

    barrel_left_shifter sll(left_shifted, data_operandA, ctrl_shiftamt);
    barrel_right_shifter sra(right_shifted, data_operandA, ctrl_shiftamt);

    // outputs

    mux_8 selecter(data_result, ctrl_ALUopcode[2:0], sum, difference, bitwiseAnd, bitwiseOr, left_shifted, right_shifted, 32'b0, 32'b0);

    // if most significant bit of difference is 1, then difference is negative, which means A < B
    assign isLessThan = difference[31];

    // isNotEqual
    or compareAllBits(isNotEqual, difference[31], difference[30], difference[29], difference[28], difference[27], difference[26],
    difference[25], difference[24], difference[23], difference[22], difference[21], difference[20], difference[19], difference[18],
    difference[17], difference[16], difference[15], difference[14], difference[13], difference[12], difference[11], difference[10],
    difference[9], difference[8], difference[7], difference[6], difference[5], difference[4], difference[3], difference[2], difference[1], difference[0]);

    // overflow
    assign operand_b_sign = ctrl_ALUopcode == 5'b1 ? bitwiseNotB[31] : data_operandB[31];
    xnor OPERAND_SIGNS_MATCH(operand_signs_match, data_operandA[31], operand_b_sign);
    xor OPERANDS_MATCH_AND_DIFFER_FROM_RES(overflow_intermediate, data_operandA[31], data_result[31]);
    assign overflow = operand_signs_match ? overflow_intermediate : 1'b0;

endmodule