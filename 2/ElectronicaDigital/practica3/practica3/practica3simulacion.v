`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:48:29 10/16/2010
// Design Name:   entidad
// Module Name:   C:/Universidad/2/ElectronicaDigital/practica3/practica3/practica3simulacion.v
// Project Name:  practica3
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: entidad
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module practica3simulacion;

	// Inputs
	reg mclk;
	reg [3:0] btn;
	reg [7:0] swt;

	// Outputs
	wire [7:0] led;
	wire [3:0] an;
	wire [7:0] ssg;

	// Instantiate the Unit Under Test (UUT)
	entidad uut (
		.mclk(mclk), 
		.btn(btn), 
		.swt(swt), 
		.led(led), 
		.an(an), 
		.ssg(ssg)
	);

	initial begin
		// Initialize Inputs
		mclk = 0;
		btn = 0;
		swt = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

