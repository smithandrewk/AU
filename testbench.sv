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
	AU_32b arith (.a(a),.b(b),.ALUop(ALUop),.clk(clk), .rst_n(rst_n),.s(s),.hi(hi),.lo(lo),.zero(zero));
	
	//Simulates clock for testbench
	always begin
		clk = 0; #1; //May need to adjust delay for longer clock cycle
		clk = 1; #1;
	end
	

	logic [31:0] temp;
	logic temp_cout;
	integer i , j, count;
	//Initial block runs at the beginning of simulation
	initial 
		//Apply the input values here, then check results
		//Mult and div take 32 clock cycles each, so probably delay 33*clock cycle for safety?
		//Check module 4 slide 41 for testbench structure
	begin
	// CHECK ADDITION
	$display("CHECKING ADDITION");
	a = 0;
	b = 0;
	ALUop = 2'b00;
	count = 0;
	for (i = 0; i <3; i= i+1)
	begin
		b = 32'h0;
		for (j = 0; j < 3; j=j+1)
		begin
		#2;
		b = b + 1;
		temp = a + b;
		#2;
		//if (!(s == temp))
		assert (s == temp)
		$display("This is correct");
		else begin
			count = count + 1;
			$display("Error number %d",count);
			count = count + 1;
		end
		end
		a = a + 1;
	end
	//CHECK SUB
	$display("CHECKING SUBTRACTION");
	a = 32'h0;
	b = 32'h0;
	ALUop = 2'b01;
	count = 0;
	for (i = 0; i <3; i= i+1)
	begin
		b = 32'h0;
		a = i;
		for (j = 0; j < 3; j=j+1)
		begin
		#2;
		b = j;
		{temp_cout,temp} = a - b;
		#2;
		//if (!(s == temp))
		assert(s==temp)
			$display("This is correct");
		else begin
			count = count + 1;
			$display("Error number %d",count);
			count = count + 1;
		end   // else 
		end
	// a = a + 1;
	end
	#10;
	//CHECK MULT
	$display("CHECKING MULTIPLICATION");
	a = 3;
	b = 7;
	ALUop = 2'b10;
	rst_n = 0;
	#3;
	rst_n = 1;
	temp = a*b;
	#100
	assert ({hi,lo} == temp)
	$display("This is correct%d",{hi,lo});
	else
	$display("Nope");
	a = 10;
	b = 10;
	ALUop = 2'b10;
	rst_n = 0;
	#3;
	rst_n = 1;
	temp = a*b;
	#100
	assert ({hi,lo} == temp)
	$display("This is correct%d",{hi,lo});
	else
	$display("Nope");
		a = 7;
	b = 21;
	ALUop = 2'b10;
	rst_n = 0;
	#3;
	rst_n = 1;
	temp = a*b;
	#100
	assert ({hi,lo} == temp)
	$display("This is correct%d",{hi,lo});
	else
	$display("Nope");
	//CHECK DIV
	$display("CHECKING DIV");
	a = 10;
	b = 5;
	ALUop = 2'b11;
	rst_n = 0;
	#3;
	rst_n = 1;
	temp = a/b;
	#100
	assert ({hi,lo} == temp)
	$display("This is correct%d",{hi,lo});
	else
	$display("Nope");
	a = 10;
	b = 10;
	ALUop = 2'b11;
	rst_n = 0;
	#3;
	rst_n = 1;
	temp = a/b;
	#100
	assert ({hi,lo} == temp)
	$display("This is correct%d",{hi,lo});
	else
	$display("Nope");
	a = 100;
	b = 5;
	ALUop = 2'b11;
	rst_n = 0;
	#3;
	rst_n = 1;
	temp = a/b;
	#100
	assert ({hi,lo} == temp)
	$display("This is correct%d",{hi,lo});
	else
	$display("Nope");
	end
	endmodule