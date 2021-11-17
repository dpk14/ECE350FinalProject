`timescale 1ns / 1ps
/**
 *
 * READ THIS DESCRIPTION:
 *
 * This is the Wrapper module that will serve as the header file combining your processor,
 * RegFile and Memory elements together.
 *
 * This file will be used to generate the bitstream to upload to the FPGA.
 * We have provided a sibling file, Wrapper_tb.v so that you can test your processor's functionality.
 *
 * We will be using our own separate Wrapper_tb.v to test your code. You are allowed to make changes to the Wrapper files
 * for your own individual testing, but we expect your final processor.v and memory modules to work with the
 * provided Wrapper interface.
 *
 * Refer to Lab 5 documents for detailed instructions on how to interface
 * with the memory elements. Each imem and dmem modules will take 12-bit
 * addresses and will allow for storing of 32-bit values at each address.
 * Each memory module should receive a single clock. At which edges, is
 * purely a design choice (and thereby up to you).
 *
 * You must change line 36 to add the memory file of the test you created using the assembler
 * For example, you would add sample inside of the quotes on line 38 after assembling sample.s
 *
 **/

module CPU (clock, reset,

            // I/0
            interrupt_instruction,

            // Read-Only Registers
            reg_out0, reg_out1, reg_out2, reg_out3, reg_out4, reg_out5, reg_out6, reg_out7, reg_out8, reg_out9, reg_out10,
            reg_out11, reg_out12, reg_out13, reg_out14, reg_out15, reg_out16, reg_out17, reg_out18, reg_out19, reg_out20,
            reg_out21, reg_out22, reg_out23, reg_out24, reg_out25, reg_out26, reg_out27, reg_out28, reg_out29, reg_out30, reg_out31
            );

	input clock, reset;
	input [31:0] interrupt_instruction;


	output [31:0] reg_out0, reg_out1, reg_out2, reg_out3, reg_out4, reg_out5, reg_out6, reg_out7, reg_out8, reg_out9, reg_out10,
    	reg_out11, reg_out12, reg_out13, reg_out14, reg_out15, reg_out16, reg_out17, reg_out18, reg_out19, reg_out20,
    	reg_out21, reg_out22, reg_out23, reg_out24, reg_out25, reg_out26, reg_out27, reg_out28, reg_out29, reg_out30, reg_out31;

	wire rwe, mwe;
	wire[4:0] rd, rs1, rs2;
	wire[31:0] instAddr, instData,
		rData, regA, regB,
		memAddr, memDataIn, memDataOut;


	// ADD YOUR MEMORY FILE HERE
	localparam INSTR_FILE = "/Assembly/game.s";

	// Main Processing Unit
	processor CPU(.clock(clock), .reset(reset),

		// ROM
		.address_imem(instAddr), .q_imem(instData),

		// Regfile
		.ctrl_writeEnable(rwe),     .ctrl_writeReg(rd),
		.ctrl_readRegA(rs1),     .ctrl_readRegB(rs2),
		.data_writeReg(rData), .data_readRegA(regA), .data_readRegB(regB),

		// RAM
		.wren(mwe), .address_dmem(memAddr),
		.data(memDataIn), .q_dmem(memDataOut),

		// I/0
		.interrupt_instruction(interrupt_instruction)
		);

	// Instruction Memory (ROM)
	ROM #(.MEMFILE({INSTR_FILE, ".mem"}))
	InstMem(.clk(clock),
		.addr(instAddr[11:0]),
		.dataOut(instData));

	// Register File
	my_regfile RegisterFile(.clock(clock),
		.ctrl_writeEnable(rwe), .ctrl_reset(reset),
		.ctrl_writeReg(rd),
		.ctrl_readRegA(rs1), .ctrl_readRegB(rs2),
		.data_writeReg(rData), .data_readRegA(regA), .data_readRegB(regB));

	// Processor Memory (RAM)
	RAM ProcMem(.clk(clock),
		.wEn(mwe),
		.addr(memAddr[11:0]),
		.dataIn(memDataIn),
		.dataOut(memDataOut));

endmodule