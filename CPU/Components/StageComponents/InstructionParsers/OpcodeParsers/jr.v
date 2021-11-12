module jr(is_type, instruction);
    input [31:0] instruction;
    output is_type;

    // 00100
    assign is_type = &(~instruction[31:30]) && instruction[29] && &(~instruction[28:27]);
endmodule