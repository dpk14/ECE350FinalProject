module load(is_type, instruction);
    input [31:0] instruction;
    output is_type;

    // 01000
    assign is_type = !instruction[31] && instruction[30] && &(~instruction[29:27]);
endmodule