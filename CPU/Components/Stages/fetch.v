module fetch(
    // Control signals
    clock,                          // I: The master clock
    reset,                          // I: A reset signal

    // Imem
    address_imem,                   // O: The address of the data to get from imem
    incremented_pc,

    // Jump handling
    should_jump,
    jump_to,

    // Stall handling
    should_stall_decode,
    f_d_instructions_output,
    d_x_instructions_output,

    // I/0
    key_interrupt
	);

	// Control signals
	input clock, reset;

	// Imem
    output [31:0] address_imem, incremented_pc;

	// Jump handling
	input should_jump;
	input [31:0] jump_to;

	// Stall handling
	input should_stall_decode;
	input [31:0] f_d_instructions_output, d_x_instructions_output;

	// I/0
	input key_interrupt;

	wire [31:0] current_pc, new_pc, decremented_pc;

	wire isNotEqual, isLessThan, overflow;
	wire should_stall;


	reg_32 program_counter_reg(.out(current_pc), .in(should_stall_decode || key_interrupt ? current_pc : new_pc), .clk(clock), .clr(reset),
	                           .in_enable(1'b1), .out_enable(1'b1));

    my_alu pc_incrementer(.data_operandA(current_pc), .data_operandB(32'b1), .data_result(incremented_pc),
                          .ctrl_ALUopcode(5'b0), .ctrl_shiftamt(5'b0),
                          .isNotEqual(isNotEqual), .isLessThan(isLessThan), .overflow(overflow));


    wire should_stall_fetch, mult_f_d_opcode, div_f_d_opcode, mult_d_x_opcode, div_d_x_opcode;

    // also must stall if the instruction in this decode stage is a mult/div
    mult f_d_is_mult_type(.is_type(mult_f_d_opcode), .instruction(f_d_instructions_output));
    div f_d_is_div_type(.is_type(div_f_d_opcode), .instruction(f_d_instructions_output));

    // also must stall if the instruction in fetch stage is a mult/div
    mult d_x_is_mult_type(.is_type(mult_d_x_opcode), .instruction(d_x_instructions_output));
    div d_x_is_div_type(.is_type(div_d_x_opcode), .instruction(d_x_instructions_output));

    assign should_stall_fetch = mult_f_d_opcode || div_f_d_opcode || mult_d_x_opcode || div_d_x_opcode;
    assign should_stall = should_stall_fetch || should_stall_decode || key_interrupt;

    assign new_pc = should_jump ? jump_to : incremented_pc;
    assign address_imem = current_pc;

endmodule
