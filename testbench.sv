module testbench ();
	
	//Defines variables to pass to AU module
	
	//Input
	logic [31:0] a,b; // operands
	logic [1:0] ALUop; // ADD(ALUop=00), SUB(ALUop =01), Mult (ALUop =10), divide (ALUop =11)
	logic clk; // clock signal
	logic rst_n; //active-low reset signal used for initialization
	
	//Output
	logic [31:0] s; // The result of add/sub
	logic [31:0] hi; // The left half of the product/remainder register for multiply/Divide
	logic [31:0] lo; // The right half of the product/remainder register for multiply/Divide
	logic zero; // The zero flag
	
	//Define the AU module
	//Add parameters
	AU_32b arith ();
	
	//Simulates clock for testbench
	always begin
		clk = 0; #10; //May need to adjust delay for longer clock cycle
		clk = 1; #10;
	end
	
	//Initial block runs at the beginning of simulation
	initial begin
		//Apply the input values here, then check results
		//Mult and div take 32 clock cycles each, so probably delay 33*clock cycle for safety?
		//Check module 4 slide 41 for testbench structure
	
	end

endmodule
