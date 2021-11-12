module rs2_parser(rs2, instruction);
    input [31:0] instruction;
    output [4:0] rs2;

    wire bne_f_d_opcode, blt_f_d_opcode, store_f_d_opcode, jr_f_d_opcode, bex_f_d_opcode, setx_f_d_opcode;

        bne is_bne(.is_type(bne_f_d_opcode), .instruction(instruction));
        blt is_blt(.is_type(blt_f_d_opcode), .instruction(instruction));
        store is_store(.is_type(store_f_d_opcode), .instruction(instruction));
        jr is_jr(.is_type(jr_f_d_opcode), .instruction(instruction));

    // if cases (SW, jr $rd, blt, bne), read from rd as opposed to writing from it (so $rd -> rs2)
    assign rs2 = bne_f_d_opcode || blt_f_d_opcode || store_f_d_opcode || jr_f_d_opcode ?
                                instruction[26:22] : // read from rd as opposed to writing from it (so $rd -> rs2)
                                instruction[16:12]; // else $rt -> rs2
endmodule