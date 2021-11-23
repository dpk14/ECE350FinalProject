module image #( parameter WIDTH = 640, HEIGHT = 480,
                          IMG_FILE = "background_image.mem",
                          CLR_FILE = "background_colors.mem") (
    input clk,
    input [31:0] imgAddress,
	output[BITS_PER_COLOR-1:0] colorData // 12-bit color data at current pixel
    );

    // Lab Memory Files Location
    localparam FILES_PATH = "";

    wire[PALETTE_ADDRESS_WIDTH-1:0] colorAddr; 	 // Color address for the color palette

    localparam
        PIXEL_COUNT = WIDTH*HEIGHT, 	             // Number of pixels on the screen
        PIXEL_ADDRESS_WIDTH = $clog2(PIXEL_COUNT) + 1,           // Use built in log2 command
        BITS_PER_COLOR = 12, 	  								 // Nexys A7 uses 12 bits/color
        PALETTE_COLOR_COUNT = 256, 								 // Number of Colors available
        PALETTE_ADDRESS_WIDTH = $clog2(PALETTE_COLOR_COUNT) + 1; // Use built in log2 Command

	IMG_RAM #(
		.DEPTH(PIXEL_COUNT), 				     // Set RAM depth to contain every pixel
		.DATA_WIDTH(PALETTE_ADDRESS_WIDTH),      // Set data width according to the color palette
		.ADDRESS_WIDTH(PIXEL_ADDRESS_WIDTH),     // Set address with according to the pixel count
		.MEMFILE({FILES_PATH, IMG_FILE})) // Memory initialization
	ImageData(
		.clk(clk), 						 // Falling edge of the 100 MHz clk
		.addr(imgAddress[PIXEL_ADDRESS_WIDTH-1:0]),					 // Image data address
		.dataOut(colorAddr),				 // Color palette address
		.wEn(1'b0)); 						 // We're always reading


	IMG_RAM #(
		.DEPTH(PALETTE_COLOR_COUNT), 		       // Set depth to contain every color
		.DATA_WIDTH(BITS_PER_COLOR), 		       // Set data width according to the bits per color
		.ADDRESS_WIDTH(PALETTE_ADDRESS_WIDTH),     // Set address width according to the color count
		.MEMFILE({FILES_PATH, CLR_FILE}))  // Memory initialization
	ColorPalette(
		.clk(clk), 							   	   // Rising edge of the 100 MHz clk
		.addr(colorAddr),					       // Address from the ImageData RAM
		.dataOut(colorData),				       // Color at current pixel
		.wEn(1'b0)); 						       // We're always reading


endmodule