module rd_parser(rd, instruction);
    input [31:0] instruction;
    output [4:0] rd;

    wire jal_opcode, setx_opcode;

    jal jal_type(.is_type(jal_opcode), .instruction(instruction));
    setx setx_type(.is_type(setx_opcode), .instruction(instruction));

    assign rd = jal_opcode ? 5'd31 : // if jal type, write into $r31
               setx_opcode ? 5'd30 : // if setx type, write into $r30
               instruction[26:22];
endmodule