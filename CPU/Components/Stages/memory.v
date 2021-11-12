module memory(
    // Control signals
    clock,                          // I: The master clock
    reset,                          // I: A reset signal

    // X/M latch
    x_m_pc_input, x_m_pc_output,
    x_m_instructions_input, x_m_instructions_output,
    x_m_operand_O_input, x_m_operand_O_output, // x_m_op_O output is output here too bc it is used to mux alu input
    x_m_operand_B_input,
    multdiv_underway,

    // Dmem
    address_dmem,                   // O: The address of the data to get or put from/to dmem
    data,                           // O: The data to write to dmem
    wren,                           // O: Write enable for dmem

    // General
    operand_O_output,

    // Hazard handling
    writeback_stage_output, m_w_instructions_output,
	);

    // Control signals
    input clock, reset, multdiv_underway;

    // X/M latch
    input [31:0] x_m_pc_input, x_m_instructions_input, x_m_operand_O_input, x_m_operand_B_input;
    output [31:0] x_m_pc_output, x_m_instructions_output, x_m_operand_O_output;

    // Dmem
    output [31:0] address_dmem, data;
    output wren;

    // General
    output [31:0] operand_O_output;

    // Hazard handling
    input [31:0] writeback_stage_output, m_w_instructions_output;


    wire [31:0] x_m_operand_B_output;

    // X/M latch

    reg_32 x_m_pc_reg(.out(x_m_pc_output), .in(x_m_pc_input), .clk(clock), .clr(reset), .in_enable(1'b1), .out_enable(1'b1));
    reg_32 x_m_instruction_reg(.out(x_m_instructions_output), .in(multdiv_underway ? 31'b0 : x_m_instructions_input), .clk(clock), .clr(reset), .in_enable(1'b1), .out_enable(1'b1));
    reg_32 x_m_operand_O_reg(.out(x_m_operand_O_output), .in(x_m_operand_O_input), .clk(clock), .clr(reset), .in_enable(1'b1), .out_enable(1'b1));
    reg_32 x_m_operand_B_reg(.out(x_m_operand_B_output), .in(x_m_operand_B_input), .clk(clock), .clr(reset), .in_enable(1'b1), .out_enable(1'b1));

    // assignments

    assign operand_O_output = x_m_operand_O_output;
    assign address_dmem = x_m_operand_O_output;

        // only write to memory on store opcode

        wire store_x_m_opcode;

        store is_store_x_m(.is_type(store_x_m_opcode), .instruction(x_m_instructions_output));

        assign wren = store_x_m_opcode;

    // hazards

        wire [4:0] rd_x_m, rd_m_w;
        wire m_w_instruc_has_dest;

        rd_parser rd_x_m_parser(.rd(rd_x_m), .instruction(x_m_instructions_output));
        rd_parser rd_m_w_parser(.rd(rd_m_w), .instruction(m_w_instructions_output));
        instruction_has_destination m_w_has_dest(.instruction_has_destination(m_w_instruc_has_dest), .instruction(m_w_instructions_output));

       // if X/M.IR.RD == M/W.IR.RD (if you've just changed the value you're trying to save to memory), get that value from writeback
        assign data = &(~(rd_x_m ^ rd_m_w)) && m_w_instruc_has_dest ? writeback_stage_output : x_m_operand_B_output;


endmodule