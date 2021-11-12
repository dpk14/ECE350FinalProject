module writeback(
    // Control signals
    clock,                          // I: The master clock
    reset,                          // I: A reset signal

    // X/M latch
    m_w_pc_input,
    m_w_instructions_input, m_w_instructions_output,
    m_w_operand_O_input,
    m_w_operand_D_input,

    multdiv_resultRDY,
    multdiv_output,
    pw_instructions_output,

    // General
    data_output
	);

    // Control signals

    input clock, reset, multdiv_resultRDY;

    // M/W latch

    input [31:0] m_w_pc_input, m_w_instructions_input, m_w_operand_O_input, m_w_operand_D_input, multdiv_output, pw_instructions_output;
    output [31:0] m_w_instructions_output;
    wire [31:0] m_w_instructions_intermediate_output, m_w_pc_output, m_w_operand_O_output, m_w_operand_D_output;

        reg_32 m_w_pc_reg(.out(m_w_pc_output), .in(m_w_pc_input), .clk(clock), .clr(reset), .in_enable(1'b1), .out_enable(1'b1));
        reg_32 m_w_instruction_reg(.out(m_w_instructions_intermediate_output), .in(m_w_instructions_input), .clk(clock), .clr(reset), .in_enable(1'b1), .out_enable(1'b1));
        reg_32 m_w_operand_O_reg(.out(m_w_operand_O_output), .in(m_w_operand_O_input), .clk(clock), .clr(reset), .in_enable(1'b1), .out_enable(1'b1));
        reg_32 m_w_operand_D_reg(.out(m_w_operand_D_output), .in(m_w_operand_D_input), .clk(clock), .clr(reset), .in_enable(1'b1), .out_enable(1'b1));

        assign m_w_instructions_output = multdiv_resultRDY ? pw_instructions_output : m_w_instructions_intermediate_output;

    // General

    output [31:0] data_output;

    wire load_m_w_opcode, jal_m_w_opcode;

        load m_w_is_load(.is_type(load_m_w_opcode), .instruction(m_w_instructions_output));
        jal m_w_is_jal_type(.is_type(jal_m_w_opcode), .instruction(m_w_instructions_output));

        assign data_output = load_m_w_opcode ? m_w_operand_D_output : // if LOAD, write back operand D (the result loaded from memory)
                             jal_m_w_opcode ? m_w_pc_output : // if jal command, you're writing back the pc into $r31
                             multdiv_resultRDY ? multdiv_output :
                             m_w_operand_O_output; // otherwise just write back O

endmodule