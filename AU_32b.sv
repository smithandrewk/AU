module AU_32b (input logic [31:0] a,b, // operands
	input logic [1:0] ALUop, // ADD(ALUop=00), SUB(ALUop =01), Mult (ALUop =10), divide (ALUop =11)
	input logic clk, // clock signal
	input logic rst_n, //active-low reset signal used for initialization
	output logic [31:0] s, // The result of add/sub
	output logic [31:0] hi, // The left half of the product/remainder register for multiply/Divide
	output logic [31:0] lo, // The right half of the product/remainder register for multiply/Divide
	output logic zero // The zero flag
);
	
	//Define enable logic
	//Define ctrl logic
	
	//Defines the function modules
	//Add parameters
	cla32b_addsub addsub ();
	mult_32b_unsigned mult ();
	div_32b_unsigned div ();

	/*Check ALUop: probably always_comb because this is combinational logic
		If ALUop matches, enable the corresponding module
		For add/sub, update ctrl with correct value (0 for add, 1 for sub)
			This can be easily done through the following:
				Check ALUop[1]: 
					0 = add/sub, ALUop[0] -> ctrl, enable add/sub
					1 = mult/div, check ALUop[0] to decide which to enable
	*/
	
	//Check output value for zero to flip zero flag (True if result is 0)

	//Write tests in the testbench file

endmodule