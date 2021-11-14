module InputController(key_interrupt, jump_key, frame_rt_clk, sysclk, reset);

    input frame_rt_clk, sysclk, reset, jump_key;
    output key_interrupt;

    // reads from different registers at frame rate, compares contents

    reg key_interrupt_reg = 0;

    always @(posedge frame_rt_clk or posedge reset) begin
        if(reset) begin
            key_interrupt_reg <= 0;
        end else begin
            if (jump_key) begin
                key_interrupt_reg <= 1;
            end
        end
    end

    // turns off key_interrupt_reg as soon as possible (1 sys clock cycle after the frame rate rises)
    // so that only one interrupt instruction is sent to CPU

    always @(negedge sysclk) begin
        if (key_interrupt_reg) begin
            key_interrupt_reg <= 0;
        end
    end

    assign key_interrupt = key_interrupt_reg;

endmodule