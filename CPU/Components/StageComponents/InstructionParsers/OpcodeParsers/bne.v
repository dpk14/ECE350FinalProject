module bne(is_type, instruction);
    input [31:0] instruction;
    output is_type;

    // 00010
    assign is_type = &(~instruction[31:29]) && instruction[28] && !instruction[27];
endmodule