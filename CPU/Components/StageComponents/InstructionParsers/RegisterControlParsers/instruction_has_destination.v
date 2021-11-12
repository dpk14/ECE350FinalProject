module instruction_has_destination(instruction_has_destination, instruction);
    input [31:0] instruction;
    output instruction_has_destination;

    wire jal_opcode, bne_opcode, blt_opcode, store_opcode, jr_opcode, bex_opcode, j_opcode;

    wire [4:0] rd;

    bne is_bne(.is_type(bne_opcode), .instruction(instruction));
    blt is_blt(.is_type(blt_opcode), .instruction(instruction));
    store is_store(.is_type(store_opcode), .instruction(instruction));
    jr is_jr(.is_type(jr_opcode), .instruction(instruction));
    bex is_bex(.is_type(bex_opcode), .instruction(instruction));
    j is_j(.is_type(j_opcode), .instruction(instruction));

    rd_parser rd_parser(.rd(rd), .instruction(instruction));

    assign instruction_has_destination = !store_opcode && !j_opcode && !bne_opcode && !jr_opcode && !blt_opcode && !bex_opcode && !(&(~rd)); // also ignore case where rd = 0
endmodule