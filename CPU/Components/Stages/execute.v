module execute(
    // Control signals
    clock,                          // I: The master clock
    reset,                          // I: A reset signal

    // D/X latch
    d_x_pc_input, d_x_pc_output,
    d_x_instructions_input, decode_stage_instructions_output,
    d_x_operand_A_input,
    d_x_operand_B_input,

    // Other stage info
    x_m_instructions_output, x_m_operand_O_output,
    m_w_instructions_output,
    data_writeback,

    // Mul/Div
    ctrlMULT, ctrlDIV,
    mult_exception,
    div_exception,

    // Stage output
    operand_O_output,
    operand_B_output,
    operand_A_output,
    jump_to,
    should_jump
	);

	// Control signals

	input clock, reset;
	output should_jump;

	// AlU Logic

	output [31:0] operand_O_output, operand_B_output, operand_A_output;


	// D/X latch

    input [31:0] d_x_pc_input, d_x_instructions_input, d_x_operand_A_input, d_x_operand_B_input;
    output [31:0] d_x_pc_output, decode_stage_instructions_output;

	wire [31:0] d_x_operand_A_output, d_x_operand_B_output, d_x_instructions_output;

    reg_32 d_x_pc_reg(.out(d_x_pc_output), .in(d_x_pc_input), .clk(clock), .clr(reset), .in_enable(1'b1), .out_enable(1'b1));
    reg_32 d_x_instruction_reg(.out(d_x_instructions_output), .in(should_jump ? 31'b0 : d_x_instructions_input), .clk(clock), .clr(reset), .in_enable(1'b1), .out_enable(1'b1));
    reg_32 operand_A_reg(.out(d_x_operand_A_output), .in(should_jump ? 31'b0 : d_x_operand_A_input), .clk(clock), .clr(reset), .in_enable(1'b1), .out_enable(1'b1));
    reg_32 operand_B_reg(.out(d_x_operand_B_output), .in(should_jump ? 31'b0 : d_x_operand_B_input), .clk(clock), .clr(reset), .in_enable(1'b1), .out_enable(1'b1));


    // Hazard handling

    input [31:0] x_m_instructions_output, x_m_operand_O_output,
                 m_w_instructions_output,
                 data_writeback;

    wire [31:0] alu_in_A, alu_in_B;
    wire [4:0] rs1_d_x, rs2_d_x,
               rd_x_m,
               rd_m_w;
    wire x_m_instruc_has_dest, m_w_instruc_has_dest, is_sw, is_lw;

        rs1_parser rs1_d_x_parser(.rs1(rs1_d_x), .instruction(d_x_instructions_output));
        rs2_parser rs2_d_x_parser(.rs2(rs2_d_x), .instruction(d_x_instructions_output));

        rd_parser rd_x_m_parser(.rd(rd_x_m), .instruction(x_m_instructions_output));
        instruction_has_destination x_m_has_dest(.instruction_has_destination(x_m_instruc_has_dest), .instruction(x_m_instructions_output));

        rd_parser rd_m_w_parser(.rd(rd_m_w), .instruction(m_w_instructions_output));
        instruction_has_destination m_w_has_dest(.instruction_has_destination(m_w_instruc_has_dest), .instruction(m_w_instructions_output));

        // ALUinA
        assign alu_in_A = &(~(rs1_d_x ^ rd_x_m)) && x_m_instruc_has_dest ? x_m_operand_O_output : // if D/X.IR.RS1 == X/M.IR.RD
                          &(~(rs1_d_x ^ rd_m_w)) && m_w_instruc_has_dest ? data_writeback :  // if D/X.IR.RS1 == M/W.IR.RD
                          d_x_operand_A_output;

       assign operand_A_output = alu_in_A;

        // ALUinB
            assign operand_B_output = &(~(rs2_d_x ^ rd_x_m)) && x_m_instruc_has_dest ? x_m_operand_O_output : // if D/X.IR.RS2 == X/M.IR.RD
                                      &(~(rs2_d_x ^ rd_m_w)) && m_w_instruc_has_dest ? data_writeback :  // if D/X.IR.RS2 == M/W.IR.RD
                                      d_x_operand_B_output;

            // addi, lw, and sw are the only commands that use the immediate instead of operand B for computation in the main alu

            store is_sw_opcode(.is_type(is_sw), .instruction(d_x_instructions_output));
            load is_lw_opcode(.is_type(is_lw), .instruction(d_x_instructions_output));

            assign alu_in_B = is_addi || is_lw || is_sw ? sign_extended_immediate : operand_B_output;




    // ALU logic

        wire [31:0] sign_extended_immediate, alu_output;

        sign_extender_17 sx_immediate(.out(sign_extended_immediate), .in(d_x_instructions_output[16:0]));

        wire isNotEqual, isLessThan, aluOverflow;
        wire r_type_d_x_opcode, bne_d_x_opcode, blt_d_x_opcode, jal_d_x_opcode, jr_d_x_opcode, j_d_x_opcode, bex_d_x_opcode;

            r_type d_x_is_r_type(.is_type(r_type_d_x_opcode), .instruction(d_x_instructions_output));
            bne d_x_is_bne(.is_type(bne_d_x_opcode), .instruction(d_x_instructions_output));
            blt d_x_is_blt(.is_type(blt_d_x_opcode), .instruction(d_x_instructions_output));
            jal d_x_is_jal(.is_type(jal_d_x_opcode), .instruction(d_x_instructions_output));
            jr d_x_is_jr(.is_type(jr_d_x_opcode), .instruction(d_x_instructions_output));
            j d_x_is_j(.is_type(j_d_x_opcode), .instruction(d_x_instructions_output));
            bex d_x_is_bex(.is_type(bex_d_x_opcode), .instruction(d_x_instructions_output));

            my_alu alu(.data_operandA(alu_in_A), .data_operandB(bex_d_x_opcode ? 31'b0 : alu_in_B), // must compare to 0 for bex case
                        .data_result(alu_output),
                        .ctrl_ALUopcode(r_type_d_x_opcode ? d_x_instructions_output[6:2] // take alu opcode in r_type case
                                        : bne_d_x_opcode || blt_d_x_opcode || bex_d_x_opcode ? 5'b1 // subtract in branch case
                                        : 5'b0), // else use addition
                        .ctrl_shiftamt(r_type_d_x_opcode ? d_x_instructions_output[11:7] : 5'b0),
                        .isNotEqual(isNotEqual), .isLessThan(isLessThan), .overflow(aluOverflow));

            wire setx_output_opcode;

            setx output_instruction_is_setx(.is_type(setx_output_opcode), .instruction(decode_stage_instructions_output));

            // for setx case, must extract target from instruction and override it as operand O so that the processor saves that value into $rstatus
            assign operand_O_output = setx_output_opcode ? sign_extended_target :
                                      alu_output;



    // Mult/div logic

        output ctrlMULT, ctrlDIV;

        div is_div(.is_type(ctrlDIV), .instruction(d_x_instructions_output));
        mult is_mul(.is_type(ctrlMULT), .instruction(d_x_instructions_output));


    // Jump logic
        output [31:0] jump_to;

        wire should_jump_to_sum, should_jump_to_target, should_jump_to_reg;
        wire [31:0] target, sign_extended_target, pc_immediate_sum;

            assign should_jump_to_sum = (bne_d_x_opcode && isNotEqual) ||
                                        (blt_d_x_opcode && isNotEqual && !isLessThan);

            assign should_jump_to_target = j_d_x_opcode || jal_d_x_opcode ||
                                           (bex_d_x_opcode && isNotEqual); // jump to target in case of $rstatus - 0 != 0
            assign should_jump_to_reg = jr_d_x_opcode;
            assign should_jump = should_jump_to_sum || should_jump_to_target || should_jump_to_reg;

                my_alu pc_adder(.data_operandA(d_x_pc_output), .data_operandB(sign_extended_immediate),
                            .data_result(pc_immediate_sum), .ctrl_ALUopcode(5'b0),
                            .ctrl_shiftamt(5'b0));

                sign_extender_27 sx_target(.out(sign_extended_target), .in(decode_stage_instructions_output[26:0]));


                assign jump_to = should_jump_to_sum ? pc_immediate_sum :
                                 should_jump_to_target ? sign_extended_target :
                                 should_jump_to_reg ? operand_B_output :
                                 d_x_pc_output;

    // Exception handling

    wire [26:0] r_status;
    wire [31:0] setx_instruction;

    wire is_sub, is_addi, is_add;

    input mult_exception, div_exception;

        sub is_sub_opcode(.is_type(is_sub), .instruction(d_x_instructions_output));
        add is_add_opcode(.is_type(is_add), .instruction(d_x_instructions_output));
        addi is_addi_opcode(.is_type(is_addi), .instruction(d_x_instructions_output));

            assign r_status = aluOverflow ?
                                    is_add ? 27'b1 :
                                    is_addi ? 27'd2 :
                                    is_sub ? 27'd3 :
                                    27'b0 :
                               mult_exception ? 27'd4 :
                               div_exception ? 27'd5 :
                                27'b0;

            assign setx_instruction[26:0] = r_status;
            assign setx_instruction[31:27] = 5'd21;

            assign decode_stage_instructions_output = aluOverflow || mult_exception || div_exception ? setx_instruction : d_x_instructions_output;


endmodule