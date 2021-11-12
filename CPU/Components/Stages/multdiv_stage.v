module multdiv_stage(
    p_w_instructions_input,
    p_w_instructions_output,

	data_operandA, data_operandB,
	ctrl_MULT, ctrl_DIV,
	clock, reset,
	data_result, data_resultRDY,
	mult_overflow, div_error,
	mult_operation_underway, div_operation_underway);

    input [31:0] data_operandA, data_operandB, p_w_instructions_input;
    input ctrl_MULT, ctrl_DIV, clock, reset;

    output [31:0] data_result;
    output data_resultRDY, mult_overflow, div_error,
            mult_operation_underway, div_operation_underway;

    wire d_x_is_mult, d_x_is_div, p_w_is_mult, p_w_is_div, data_exception;
    output [31:0] p_w_instructions_output;

    reg_32 p_w_instruction_reg(.out(p_w_instructions_output), .in(data_resultRDY || d_x_is_div || d_x_is_mult || div_error || mult_overflow ?
                                                                    p_w_instructions_input : p_w_instructions_output),
                                .clk(clock), .clr(reset), .in_enable(1'b1), .out_enable(1'b1));


    my_multdiv multdiv(.data_operandA(data_operandA), .data_operandB(data_operandB),
                        .ctrl_MULT(ctrl_MULT), .ctrl_DIV(ctrl_DIV), .clock(clock),
                        .data_result(data_result), .data_resultRDY(data_resultRDY),
                        .data_exception(data_exception));

    mult incoming_mult(.is_type(d_x_is_mult), .instruction(p_w_instructions_input));
    div incoming_div(.is_type(d_x_is_div), .instruction(p_w_instructions_input));

    mult mult_underw(.is_type(p_w_is_mult), .instruction(p_w_instructions_output));
    div div_underw(.is_type(p_w_is_div), .instruction(p_w_instructions_output));

    assign mult_operation_underway = d_x_is_mult || p_w_is_mult;
    assign div_operation_underway = d_x_is_div || p_w_is_div;

    assign mult_overflow = data_exception && p_w_is_mult;
    assign div_error = data_exception && p_w_is_div;

endmodule