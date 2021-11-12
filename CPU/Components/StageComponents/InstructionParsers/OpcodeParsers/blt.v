module blt(is_type, instruction);
    input [31:0] instruction;
    output is_type;

    // 00110
    assign is_type = &(~instruction[31:30]) && &instruction[29:28] && !instruction[27];
endmodule