module j(is_type, instruction);
    input [31:0] instruction;
    output is_type;

    // 00001
    assign is_type = &(~instruction[31:28]) && instruction[27];
endmodule