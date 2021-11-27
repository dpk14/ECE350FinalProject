module FlappyBirdAudio(
    input        clk, 		// System Clock Input 100 Mhz
    input        micData,	// Microphone Output
    input[3:0]   switches,	// Tone control switches
    output       micClk, 	// Mic clock 
    output       chSel,		// Channel select; 0 for rising edge, 1 for falling edge
    output       audioOut,	// PWM signal to the audio jack	
    output       audioEn);	// Audio Enable

	assign audioEn=1; 
	localparam MHz = 1000000;
	localparam SYSTEM_FREQ = 100*MHz; // System clock frequency
    localparam bpm = 80;

	assign chSel   = 1'b0;  // Collect Mic Data on the rising edge 
	assign audioEn = 1'b1;  // Enable Audio Output

	// Initialize the frequency array. FREQs[0] = 261
	reg[10:0] FREQs[0:16];
	initial begin
		$readmemh("FREQs.mem", FREQs);
	end

    reg[10:0] notes[0:31];
    initial begin
		$readmemh("flappy_bird_notes.mem", notes);
	end

    reg[10:0] note_len[0:31];
    initial begin
		$readmemh("flappy_bird_note_length.mem", note_len);
	end

	wire [10:0] PICKED_FREQ; 
	wire [6:0] duty_cycle; 
	wire [31:0] CounterLimit; 
	reg reset; 
	
    reg [10:0] note_num=0; 
	assign PICKED_FREQ=FREQs[notes[note_num]];
	//$display ("Frequency is: %d", PICKED_FREQ); 
	
	reg clk_note=0;
	reg [31:0] counter=0;
	assign CounterLimit=SYSTEM_FREQ/(2*PICKED_FREQ)-1; 
	always @(posedge clk) begin
		if (counter<CounterLimit)
			counter<=counter+1;
		else begin
			counter<=0;
			clk_note<=~clk_note; 
		end
	end

    
    reg [31:0] counter_note=0;  
    wire [31:0] CounterLimitNote; 
    assign CounterLimitNote=(1/note_len[note_num])*(1/SYSTEM_FREQ); 
	always @(posedge clk) begin
		if (counter_note<CounterLimitNote)
			counter_note<=counter_note+1;
		else begin
			counter_note<=0;
			note_num<=note_num+1;
		end
		if (note_num>7)
			note_num<=0;
	end

	assign duty_cycle=clk_note? 10'd75 : 10'd25;
	PWMSerializer serializer(clk, 1'b0, duty_cycle, audioOut); 
	


	//module PWMSerializer #(
    //parameter 
    // The following parameters are in MHz
    //PULSE_FREQ = 1,         // How often to check if the pulse should end
    //SYS_FREQ   = 100       // Base FPGA Clock; Nexys A7 uses a 100 Mhz Clock
    //)(
    //input clk,              // System Clock
    //input reset,            // Reset the counter
    //input[6:0] duty_cycle,       // Duty Cycle of the Wave, between 0 and 99
    //output reg signal = 0   // Output PWM signal
    //);

	

endmodule