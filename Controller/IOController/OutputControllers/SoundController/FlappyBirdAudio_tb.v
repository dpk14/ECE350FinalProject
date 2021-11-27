`timescale  1 ns/ 100 ps



module FlappyBirdAudio_tb;

output       micClk; 	// Mic clock 
output       chSel; 		// Channel select; 0 for rising edge, 1 for falling edge
output       audioOut;	// PWM signal to the audio jack	
output       audioEn; // Audio Enable

input [3:0] switches; 
input clk; 
input micData; 

assign switchs=3'b0; 
assign micData=1'b0; 

integer i; 
integer j; 


FlappyBirdAudio audio(
    clk,		// System Clock Input 100 Mhz
    micData,	// Microphone Output
    switches,	// Tone control switches
    micClk, 	// Mic clock 
    chSel,		// Channel select; 0 for rising edge, 1 for falling edge
    audioOut,	// PWM signal to the audio jack	
    audioEn);	// Audio Enable

    initial begin 
        for (i=0; i<1000000000000000; i=i+1) begin
            for (j=0; j<=1; j=j+1) begin

                assign clk=j; 
            end 

        end 
        $finish;
    end 

    initial begin
    
    $dumpfile("sound.vcd");
    $dumpvars(0, FlappyBirdAudio_tb);

    end

endmodule