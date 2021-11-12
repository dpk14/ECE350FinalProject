/**
 * READ THIS DESCRIPTION!
 *
 * This is your processor module that will contain the bulk of your code submission. You are to implement
 * a 5-stage pipelined processor in this module, accounting for hazards and implementing bypasses as
 * necessary.
 *
 * Ultimately, your processor will be tested by a master skeleton, so the
 * testbench can see which controls signal you active when. Therefore, there needs to be a way to
 * "inject" imem, dmem, and regfile interfaces from some external controller module. The skeleton
 * file, Wrapper.v, acts as a small wrapper around your processor for this purpose. Refer to Wrapper.v
 * for more details.
 *
 * As a result, this module will NOT contain the RegFile nor the memory modules. Study the inputs 
 * very carefully - the RegFile-related I/Os are merely signals to be sent to the RegFile instantiated
 * in your Wrapper module. This is the same for your memory elements. 
 *
 *
 */
module processor(
    // Control signals
    clock,                          // I: The master clock
    reset,                          // I: A reset signal

    // Imem
    address_imem,                   // O: The address of the data to get from imem
    q_imem,                         // I: The data from imem

    // Dmem
    address_dmem,                   // O: The address of the data to get or put from/to dmem
    data,                           // O: The data to write to dmem
    wren,                           // O: Write enable for dmem
    q_dmem,                         // I: The data from dmem

    // Regfile
    ctrl_writeEnable,               // O: Write enable for RegFile
    ctrl_writeReg,                  // O: Register to write to in RegFile
    ctrl_readRegA,                  // O: Register to read from port A of RegFile
    ctrl_readRegB,                  // O: Register to read from port B of RegFile
    data_writeReg,                  // O: Data to write to for RegFile
    data_readRegA,                  // I: Data from port A of RegFile
    data_readRegB                   // I: Data from port B of RegFile
	 
	);

	// Control signals
	input clock, reset;
	
	// Imem
    output [31:0] address_imem;
	input [31:0] q_imem;

	// Dmem
	output [31:0] address_dmem, data;
	output wren;
	input [31:0] q_dmem;

	// Regfile
	output ctrl_writeEnable;
	output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	output [31:0] data_writeReg;
	input [31:0] data_readRegA, data_readRegB;

	/* YOUR CODE STARTS HERE */

	// fetch

	wire should_jump;
	wire should_stall;

	wire [31:0] jump_to, incremented_pc, f_d_instructions_output, d_x_instructions_output;

	fetch fetcher(.address_imem(address_imem), .incremented_pc(incremented_pc),

	              .should_jump(should_jump), .jump_to(jump_to),
	              .should_stall_decode(should_stall),
	              .d_x_instructions_output(d_x_instructions_output),
	              .f_d_instructions_output(f_d_instructions_output),

	              .clock(!clock), .reset(reset));


    // decode

    wire [31:0] f_d_pc_output,
                x_m_instructions_output,
                m_w_instructions_output;
    wire div_operation_underway, mult_operation_underway;

    wire [31:0] operand_A_output_decode_stage, operand_B_output_decode_stage;


    decode decoder(.f_d_pc_output(f_d_pc_output), .f_d_instructions_output(f_d_instructions_output),
                   .f_d_pc_input(incremented_pc), .f_d_instructions_input(q_imem),

                   .ctrl_readRegA(ctrl_readRegA), .ctrl_readRegB(ctrl_readRegB), .ctrl_writeReg(ctrl_writeReg),
                   .data_readRegA(data_readRegA), .data_readRegB(data_readRegB), .data_writeReg(data_writeReg),
                   .ctrl_writeEnable(ctrl_writeEnable),

                   .m_w_instructions_output(m_w_instructions_output),
                   .x_m_instructions_output(x_m_instructions_output),
                   .d_x_instructions_output(d_x_instructions_output),
                   .mult_operation_underway(mult_operation_underway),
                   .div_operation_underway(div_operation_underway),
                   .should_stall(should_stall),

                   .operand_A_output(operand_A_output_decode_stage), .operand_B_output(operand_B_output_decode_stage),

                   .should_jump(should_jump),

                    .clock(!clock), .reset(reset));

    // execute

    wire [31:0] d_x_pc_output, execute_operand_O_output, execute_operand_B_output, execute_operand_A_output,
                x_m_operand_O_output;

    wire ctrl_DIV, ctrl_MULT, div_exception, mul_exception;

    execute executer(.d_x_pc_input(f_d_pc_output), .d_x_pc_output(d_x_pc_output),
                    .d_x_instructions_input(f_d_instructions_output), .decode_stage_instructions_output(d_x_instructions_output),
                    .d_x_operand_A_input(operand_A_output_decode_stage), .d_x_operand_B_input(operand_B_output_decode_stage),

                    .operand_O_output(execute_operand_O_output), .operand_B_output(execute_operand_B_output),
                    .jump_to(jump_to), .should_jump(should_jump),

                    .x_m_instructions_output(x_m_instructions_output), .x_m_operand_O_output(x_m_operand_O_output),
                    .m_w_instructions_output(m_w_instructions_output),
                    .data_writeback(data_writeReg),

                    .ctrlDIV(ctrl_DIV), .ctrlMULT(ctrl_MULT), .operand_A_output(execute_operand_A_output),
                    .div_exception(div_exception), .mult_exception(mul_exception),

                    .clock(!clock), .reset(reset));

        // Mult / Div

        wire data_resultRDY;
        wire [31:0] multdiv_result, p_w_instructions_output;

        multdiv_stage multdiv_stage(.p_w_instructions_input(d_x_instructions_output),
                                    .p_w_instructions_output(p_w_instructions_output),

                                    .data_operandA(execute_operand_A_output), .data_operandB(execute_operand_B_output),
                                    .data_result(multdiv_result), .data_resultRDY(data_resultRDY),
                                    .div_error(div_exception), .mult_overflow(mul_exception),

                                    .ctrl_MULT(ctrl_MULT), .ctrl_DIV(ctrl_DIV),
                                    .div_operation_underway(div_operation_underway), .mult_operation_underway(mult_operation_underway),

                                    .clock(!clock), .reset(reset));


    // memory

    wire [31:0] x_m_pc_output, memory_operand_O_output, memory_operand_D_output;

    memory memory_stage(.x_m_pc_input(d_x_pc_output), .x_m_pc_output(x_m_pc_output),
                        .x_m_instructions_input(d_x_instructions_output), .x_m_instructions_output(x_m_instructions_output),
                        .x_m_operand_O_input(execute_operand_O_output), .x_m_operand_B_input(execute_operand_B_output),
                        .x_m_operand_O_output(x_m_operand_O_output),

                        .address_dmem(address_dmem), .data(data), .wren(wren),

                        .operand_O_output(memory_operand_O_output), .multdiv_underway(ctrl_DIV || ctrl_MULT),

                        .writeback_stage_output(data_writeReg), .m_w_instructions_output(m_w_instructions_output),

                        .clock(!clock), .reset(reset));

    // writeback

    wire [31:0] writeback_stage_output, writeback_stage_operand_D;

    writeback writebacker(.m_w_pc_input(x_m_pc_output),
                        .m_w_instructions_input(x_m_instructions_output), .m_w_instructions_output(m_w_instructions_output),
                        .m_w_operand_O_input(memory_operand_O_output), .m_w_operand_D_input(q_dmem),

                        .data_output(data_writeReg),

                        .multdiv_resultRDY(data_resultRDY), .multdiv_output(multdiv_result),
                        .pw_instructions_output(p_w_instructions_output),

                        .clock(!clock), .reset(reset));

    /* END CODE */

endmodule
