module sub(is_type, instruction);
    input [31:0] instruction;
    output is_type;

    //op code 00000 and alu opcode 00001

    wire is_r_type;

    r_type is_r_type_opcode(.is_type(is_r_type), .instruction(instruction));

    assign is_type = is_r_type && &(~instruction[6:3] && instruction[2]);
endmodule