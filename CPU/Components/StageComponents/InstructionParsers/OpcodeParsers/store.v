module store(is_type, instruction);
    input [31:0] instruction;
    output is_type;

    // 00111
    assign is_type = &(~instruction[31:30]) && &instruction[29:27];
endmodule