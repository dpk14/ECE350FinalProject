module InputController(interrupt_instrucion, jump_key, frame_rt_clk, proc_clk, reset);

    input frame_rt_clk, proc_clk, reset, jump_key;
    output [31:0] interrupt_instrucion;

    // reads from different registers at frame rate, compares contents

    wire[31:0] CounterLimit;
    reg[31:0] counter = 0;

    localparam MHz = 1000000;
    localparam PROC_FREQ = 50*MHz;

    localparam GAME_FRAME_RT = 60; // 60 fps
   
    assign CounterLimit = (PROC_FREQ / GAME_FRAME_RT) - 1;
   
    reg key_interrupt_reg, next_frame_rdy = 0;

    always @(posedge proc_clk or posedge reset) begin
        if(reset) begin
            key_interrupt_reg <= 0;
        end else begin
            // turn off key_interrupt and next_frame_rdy signal as soon as the counter resets so that interrupt signal only sent for 1 proc cycle
            if (counter < CounterLimit) begin
                if (key_interrupt_reg || next_frame_rdy) begin
                    key_interrupt_reg <= 0;
                    next_frame_rdy <= 0;
                end
                counter <= counter + 1;
            end else begin
                next_frame_rdy <= 1;
                counter <= 0;
                if (jump_key) begin
                    key_interrupt_reg <= 1;
                end
            end
        end
    end

    JumpController jumper(frame_rt_clk, proc_clk, reset, can_jump);
    wire can_jump; 

    wire [31:0] input_instruction, frame_rdy_instruction;

    jump_key_input_instructionbuilder jump_inst_builder(.instruction(input_instruction));
    frame_rdy_instructionbuilder frame_rdy_inst_builder(.instruction(frame_rdy_instruction));

    wire allow_interrupt; 
    assign allow_interrupt= ((key_interrupt_reg != 1'b0) && can_jump); 

    assign interrupt_instrucion = ((key_interrupt_reg != 1'b0) && can_jump) ? input_instruction :
                                  next_frame_rdy != 1'b0 ? frame_rdy_instruction :
                                  32'b0;


endmodule
