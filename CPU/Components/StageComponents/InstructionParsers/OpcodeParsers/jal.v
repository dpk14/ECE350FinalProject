module jal(is_type, instruction);
    input [31:0] instruction;
    output is_type;

    // 00011
    assign is_type = &(~instruction[31:29]) && &instruction[28:27];
endmodule