module JumpController(frame_rt_clk, proc_clk, reset, can_jump);

    input frame_rt_clk, proc_clk, reset;
    output can_jump; 

    // reads from different registers at frame rate, compares contents

    wire[31:0] CounterLimit;
    reg[31:0] counter = 0;
    reg jump_reg=0; 
    assign can_jump=jump_reg; 

    //localparam MHz = 5;
    //localparam PROC_FREQ = 20*MHz;
    //localparam BUTTON_RT = 10; // 60 fps
    localparam EmpiricalParam= 10; 
   
    assign CounterLimit = EmpiricalParam-3;

    always @(posedge proc_clk or posedge reset) begin
        if(reset) begin
            counter <= 0;
        end
        else begin 
            if (counter < CounterLimit) begin
                counter <= counter + 1;
                if (counter<3) 
                    jump_reg<=1;
                else begin 
                    jump_reg<=0; 
                end 
            end 
            else begin
                    counter <= 0;
            end 
        end
    end 

endmodule
