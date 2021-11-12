module addi(is_type, instruction);
    input [31:0] instruction;
    output is_type;

    //00101
    assign is_type = &(~instruction[31:30]) && instruction[29] && !instruction[28] && instruction[27];
endmodule