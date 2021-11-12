module clock_divider(
    input        sysclk, 		// System Clock Input 100 Mhz
    input        sysclkfreq,
    input        divclkfreq,
    output       divclk);

    input [31:0] sysclkfreq, divclkfreq;
    input sysclk;

    output divclk;

    wire[31:0] CounterLimit;
    reg divided_clk = 0;
    reg[31:0] counter = 0;
    
    assign CounterLimit = (sysclkfreq / (2 * divclkfreq)) - 1;
    
    always @(posedge sysclk) begin
       if(counter < CounterLimit)
           counter <= counter + 1;
       else begin
           counter <= 0;    
           divided_clk <= ~divided_clk;
       end
    end

    assign divclk = divided_clk;
    
endmodule