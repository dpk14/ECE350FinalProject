module rs1_parser(rs1, instruction);
    input [31:0] instruction;
    output [4:0] rs1;

    wire bex_opcode;

    bex is_bex(.is_type(bex_opcode), .instruction(instruction));

    assign rs1 = bex_opcode ? 5'd30 : // if bex type, read from $r30
                instruction[21:17]; // else read from rs range
endmodule