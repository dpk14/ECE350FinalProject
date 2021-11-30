module clock_divider(
    sysclk, 		// System Clock Input 100 Mhz
    sysclkfreq,
    divclkfreq,
    divclk);

    input [63:0] sysclkfreq;
    input [63:0] divclkfreq;
    input sysclk;

    output divclk;

    wire[64:0] CounterLimit;
    reg divided_clk = 0;
    reg[64:0] counter = 0;
    
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