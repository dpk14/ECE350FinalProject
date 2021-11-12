module decode(   // Control signals
          clock,                          // I: The master clock
          reset,                          // I: A reset signal

          // F/D latch
          f_d_pc_input, f_d_instructions_input,
          f_d_pc_output, f_d_instructions_output,

          // Stall Handling
          m_w_instructions_output,
          x_m_instructions_output,
          d_x_instructions_output,
          mult_operation_underway,
          div_operation_underway,
          should_stall,

          // Jump handling
          should_jump,

          // Register File
          ctrl_writeReg, ctrl_readRegA, ctrl_readRegB, ctrl_writeEnable,
          data_readRegA, data_readRegB, data_writeReg,

          operand_A_output,
          operand_B_output
      	);

      	// Ctrl Inputs

      	input clock, reset;

      	// Stall/Jump handling

        input [31:0] m_w_instructions_output,
                x_m_instructions_output,
                d_x_instructions_output;
        output should_stall;
        input should_jump, div_operation_underway, mult_operation_underway;



      	// F/D Latch

        input [31:0] f_d_pc_input, f_d_instructions_input;
        output [31:0] f_d_pc_output, f_d_instructions_output;

        wire [31:0] f_d_instructions_output_pre_mux;

            reg_32 f_d_pc_reg(.out(f_d_pc_output), .in(f_d_pc_input), .clk(clock), .clr(reset), .in_enable(!should_stall), .out_enable(1'b1));
            reg_32 f_d_instruction_reg(.out(f_d_instructions_output_pre_mux), .in(should_jump ? 31'b0 : f_d_instructions_input), .clk(clock), .clr(reset), .in_enable(!should_stall), .out_enable(1'b1));



        // Register File

        input [31:0] data_readRegA, data_readRegB, data_writeReg;
        output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
        output ctrl_writeEnable;

        output [31:0] operand_A_output, operand_B_output;

            rs1_parser rs1_f_d_parser(.rs1(ctrl_readRegA), .instruction(f_d_instructions_output_pre_mux));
            rs2_parser rs2_f_d_parser(.rs2(ctrl_readRegB), .instruction(f_d_instructions_output_pre_mux));

            rd_parser rd_m_w_parser(.rd(ctrl_writeReg), .instruction(m_w_instructions_output));

            // instructions where register is written to are r_type, addi, lw, jal, and setx

            wire r_type_m_w_opcode, addi_m_w_opcode, load_m_w_opcode, jal_m_w_opcode, setx_m_w_opcode,
                mult_m_w_opcode, div_m_w_opcode;

                r_type m_w_is_r_type(.is_type(r_type_m_w_opcode), .instruction(m_w_instructions_output));
                addi m_w_is_addi_type(.is_type(addi_m_w_opcode), .instruction(m_w_instructions_output));
                load m_w_is_load_type(.is_type(load_m_w_opcode), .instruction(m_w_instructions_output));
                jal m_w_is_jal_type(.is_type(jal_m_w_opcode), .instruction(m_w_instructions_output));
                setx m_w_is_setx_type(.is_type(setx_m_w_opcode), .instruction(m_w_instructions_output));

                mult m_w_is_mult_type(.is_type(mult_m_w_opcode), .instruction(m_w_instructions_output));
                div m_w_is_div_type(.is_type(div_m_w_opcode), .instruction(m_w_instructions_output));

                assign ctrl_writeEnable = r_type_m_w_opcode || addi_m_w_opcode || load_m_w_opcode || jal_m_w_opcode || setx_m_w_opcode ||
                                          mult_m_w_opcode || div_m_w_opcode;

                assign operand_A_output = data_readRegA;
                assign operand_B_output = data_readRegB;


        // Stall handling

        wire [4:0] rd_d_x;
        wire load_d_x_opcode, d_x_instruc_has_dest, mult_d_x_opcode, div_d_x_opcode,
            store_f_d_opcode, mult_f_d_opcode, div_f_d_opcode;

            load d_x_is_load(.is_type(load_d_x_opcode), .instruction(d_x_instructions_output));
            store f_d_is_load(.is_type(store_f_d_opcode), .instruction(f_d_instructions_output_pre_mux));

            rd_parser rd_d_x_parser(.rd(rd_d_x), .instruction(d_x_instructions_output));
            instruction_has_destination d_x_has_dest(.instruction_has_destination(d_x_instruc_has_dest), .instruction(d_x_instructions_output));

            wire memory_conflict;

            assign memory_conflict = (load_d_x_opcode) && // D/X.IR.OP == LOAD
                                         (
                                            (&(~(ctrl_readRegA ^ rd_d_x)) && d_x_instruc_has_dest) || // F/D.IR.RS1 == D/X.IR.RD
                                             (
                                               (&(~(ctrl_readRegB ^ rd_d_x)) && d_x_instruc_has_dest) && // F/D.IR.RS2 == D/X.IR.RD
                                               (!store_f_d_opcode) // F/D.IR.OP == STORE
                                             )
                                         );

            assign should_stall = memory_conflict || mult_operation_underway || div_operation_underway;


            assign f_d_instructions_output = should_stall ? 31'b0 : f_d_instructions_output_pre_mux; // 31'b0 is nop

endmodule
