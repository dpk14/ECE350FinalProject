module r_type(is_type, instruction);
    input [31:0] instruction;
    output is_type;

    assign is_type = &(~instruction[31:27]);
endmodule