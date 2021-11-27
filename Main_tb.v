`timescale 1ns / 1ps
/**
 *
 * READ THIS DESCRIPTION:
 *
 * This is the Wrapper module that will serve as the header file combining your processor,
 * RegFile and Memory elements together.
 *
 * This file will be used to test your processor for functionality.
 * We have provided a sibling file, Wrapper_tb.v so that you can test your processor's functionality.
 *
 * We will be using our own separate Wrapper_tb.v to test your code.
 * You are allowed to make changes to the Wrapper files
 * for your own individual testing, but we expect your final processor.v
 * and memory modules to work with the Wrapper interface as provided.
 *
 * Refer to Lab 5 documents for detailed instructions on how to interface
 * with the memory elements. Each imem and dmem modules will take 12-bit
 * addresses and will allow for storing of 32-bit values at each address.
 * Each memory module should receive a single clock. At which edges, is
 * purely a design choice (and thereby up to you).
 *
 * You must set the parameter when compiling to use the memory file of
 * the test you created using the assembler and load the appropriate
 * verification file.
 *
 * For example, you would add sample as your parameter after assembling sample.s
 * using the command
 *
 * 	 iverilog -o proc -c FileList.txt -s Wrapper_tb -PWrapper_tb.FILE=\"sample\"
 *
 * Note the backslashes (\) preceding the quotes. These are required.
 *
 **/

module Main_tb;

//    localparam FILE = "game";
//
//	localparam DEFAULT_CYCLES = 255;
//
//    localparam DIR = "CPU/Assembly/";
//    localparam MEM_DIR = "";
//    localparam OUT_DIR = "Testing/";
//    localparam VERIF_DIR = "Testing/";
//
//    reg clk, reset;
//    wire jump, hSync, vSync, ps2_data, ps2_clk, rwe;
//
//    wire[31:0] rData, regA;
//    wire[4:0] rd, rs1;
//
//    wire[3:0] VGA_R, VGA_G, VGA_B;
//
//    	// Wires for Test Harness
//    	wire[4:0] rs1_test, rs1_in;
//    	reg testMode = 0;
//    	reg[7:0] num_cycles = DEFAULT_CYCLES;
//    	reg[15*8:0] exp_text;
//    	reg null;
//
//    	// Connect the reg to test to the for loop
//    	assign rs1_test = reg_to_test;
//
//    	// Hijack the RS1 value for testing
//    	assign rs1_in = testMode ? rs1_test : rs1;
//
//    	// Expected Value from File
//    	reg signed [31:0] exp_result;
//
//    	// Where to store file error codes
//    	integer expFile, diffFile, actFile, expScan;
//
//    	// Do Verification
//    	reg verify = 1;
//
//    	// Metadata
//    	integer errors = 0,
//    			cycles = 0,
//    			reg_to_test = 0;
//
//
//    localparam MHz = 1000000;
//    localparam SYSTEM_FREQ = 100*MHz; // System clock frequency
//    localparam PROC_FREQ = 50*MHz;
//
//    localparam GAME_FRAME_RT = 64'd60; // 60 fps
//
//    wire frame_rate_clk, processor_clk;
//
//    clock_divider frame_rate_clock_divider(.divclk(frame_rate_clk), .divclkfreq(GAME_FRAME_RT),
//                                           .sysclk(clk), .sysclkfreq(SYSTEM_FREQ));
//
//    clock_divider processor_clock_divider(.divclk(processor_clk), .divclkfreq(PROC_FREQ),
//                                           .sysclk(clk), .sysclkfreq(SYSTEM_FREQ));
//
//    wire [31:0] interrupt_instruction;
//
//    // Read-Only Registers
//    wire [31:0] pipe1, pipe2, pipe3, pipe4,
//                bird_top_left,
//                current_score, high_score;
//
//    CPU CPU(.clock(processor_clk), .reset(reset),
//            .interrupt_instruction(interrupt_instruction),
//
//            .reg_out1(pipe1), .reg_out2(pipe2), .reg_out3(pipe3), .reg_out4(pipe4),
//            .reg_out5(bird_top_left),
//            .reg_out26(current_score), .reg_out27(high_score),
//
//            .rData(rData), .regA(regA), .rd(rd), .rs1(rs1), .rwe(rwe)
//            );
//
//
//    InputController input_controller(.interrupt_instrucion(interrupt_instruction), .jump_key(jump),
//                                    .frame_rt_clk(frame_rate_clk), .proc_clk(processor_clk),
//                                    .reset(1'b0));
//
//    VGAController vga_controller(.pipe1(pipe1), .pipe2(pipe2), .pipe3(pipe3), .pipe4(pipe4),
//                                 .bird_top_left(bird_top_left),
//                                 .current_score(current_score), .high_score(high_score),
//
//                                 .hSync(hSync), .vSync(vSync),
//                                 .VGA_B(VGA_B), .VGA_G(VGA_G), .VGA_R(VGA_R),
//
//                                 .ps2_clk(ps2_clk), .ps2_data(ps2_data),
//
//                                .clk(clk), .reset(1'b0), .jump(jump));
//
//	// Create the clock
//	always
//		#5 clk = ~clk;
//
//	//////////////////
//	// Test Harness //
//	//////////////////
//
//	initial begin
//		// Check if the parameter exists
//
//		$display({"Loading ", FILE, ".mem\n"});
//
//		// Read the expected file
//		expFile = $fopen({DIR, VERIF_DIR, FILE, "_exp.txt"}, "r");
//
//			// Check for any errors in opening the file
//		if(!expFile) begin
//			$display("Couldn't read the expected file.",
//				"\nMake sure there is a %0s_exp.txt file in the \"%0s\" directory.", FILE, {DIR ,VERIF_DIR});
//			$display("Continuing for %0d cycles without checking for correctness,\n", DEFAULT_CYCLES);
//			verify = 0;
//		end
//
//		// Output file name
//		$dumpfile({DIR, OUT_DIR, FILE, ".vcd"});
//		// Module to capture and what level, 0 means all wires
//		$dumpvars(0, Main_tb);
//
//		$display();
//
//		// Create the files to store the output
//		actFile = $fopen({DIR, OUT_DIR, FILE, "_actual.txt"},   "w");
//
//		if (verify) begin
//			diffFile = $fopen({DIR, OUT_DIR, FILE, "_diff.txt"},  "w");
//
//			// Get the number of cycles from the file
//			expScan = $fscanf(expFile, "num cycles:%d",
//				num_cycles);
//
//			// Check that the number of cycles was read
//			if(expScan != 1) begin
//				$display("Error reading the %0s file.", {FILE, "_exp.txt"});
//				$display("Make sure that file starts with \n\tnum cycles:NUM_CYCLES");;
//				$display("Where NUM_CYCLES is a positive integer\n");
//			end
//		end
//
//		// Clear the Processor at the beginning
//		reset = 1;
//		#1
//		reset = 0;
//
//		// Run for the number of cycles specified
//		for (cycles = 0; cycles < num_cycles; cycles = cycles + 1) begin
//
//			// Every rising edge, write to the actual file
//			@(posedge processor_clk);
//			if (rwe && rd != 0) begin
//				$fdisplay(actFile, "Cycle %3d: Wrote %0d into register %0d", cycles, rData, rd);
//			end
//		end
//
//		$fdisplay(actFile, "============== Testing Mode ==============");
//
//		if (verify)
//			$display("\t================== Checking Registers ==================");
//
//		// Activate the test harness
//		testMode = 1;
//
//		// Check the values in the regfile
//		for (reg_to_test = 0; reg_to_test < 32; reg_to_test = reg_to_test + 1) begin
//
//			if (verify) begin
//				// Obtain the register value
//				expScan =  $fscanf(expFile, "%s", exp_text);
//				expScan = $sscanf(exp_text, "r%d=%d", null, exp_result);
//
//				// Check for errors when reading
//				if (expScan != 2) begin
//					$display("Error reading value for register %0d.", reg_to_test);
//					$display("Please make sure the value is in the format");
//					$display("\tr%0d=EXPECTED_VALUE", reg_to_test);
//
//					// Close the Files
//					$fclose(expFile);
//					$fclose(actFile);
//					$fclose(diffFile);
//
//					#100;
//					$finish;
//				end
//			end
//
//			// Allow the regfile output value to stabilize
//			#1;
//
//			// Write the register value to the actual file
//			$fdisplay(actFile, "Reg %2d: %11d", rs1_test, regA);
//
//			// Compare the Values
//			if (verify) begin
//				if (exp_result !== regA) begin
//					$fdisplay(diffFile, "Reg: %2d Expected: %11d Actual: %11d",
//						rs1_test, $signed(exp_result), $signed(regA));
//					$display("\tFAILED Reg: %2d Expected: %11d Actual: %11d",
//						rs1_test, $signed(exp_result), $signed(regA));
//					errors = errors + 1;
//				end else begin
//					$display("\tPASSED Reg: %2d", rs1_test);
//				end
//			end
//		end
//
//		// Close the Files
//		$fclose(expFile);
//		$fclose(actFile);
//
//		if (verify)
//			$fclose(diffFile);
//
//		// Display the tests and errors
//		if (verify)
//			$display("\nFinished %0d cycle%c with %0d error%c", cycles, "s"*(cycles != 1), errors, "s"*(errors != 1));
//		else
//			$display("Finished %0d cycle%c", cycles, "s"*(cycles != 1));
//
//		#100;
//		$finish;
//	end
endmodule
