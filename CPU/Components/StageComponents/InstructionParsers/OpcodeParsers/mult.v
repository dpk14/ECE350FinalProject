module mult(is_type, instruction);
    input [31:0] instruction;
    output is_type;

    // alu opcode 00110
    wire is_r_type;

    r_type is_r_type_opcode(.is_type(is_r_type), .instruction(instruction));

    assign is_type = is_r_type && &(~instruction[6:5]) && &instruction[4:3] && !instruction[2];
endmodule