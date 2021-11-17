// puts a 1 indicator inside reg $29 (indicates the jump button has just been pressed)

module frame_rdy_instructionbuilder(instruction);

    output [31:0] instruction;

    // opcode = 00101 (addi)
    assign instruction[31:27] = 5'd5;

    // rd = 29
    assign instruction[26:22] = 5'd28;

    // rs = 0
    assign instruction[21:17] = 5'b0;

    // 17 bit immediate = 1
    assign instruction[16:0] = 17'b1;

endmodule