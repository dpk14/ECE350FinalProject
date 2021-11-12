module div(is_type, instruction);
    input [31:0] instruction;
    output is_type;

    // alu opcode 00111
    wire is_r_type;

    r_type is_r_type_opcode(.is_type(is_r_type), .instruction(instruction));

    assign is_type = is_r_type && &(~instruction[6:5]) && &instruction[4:2];
endmodule