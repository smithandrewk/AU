module AU_32b (input logic [31:0] a,b, // operands
	input logic [1:0] ALUop, // ADD(ALUop=00), SUB(ALUop =01), Mult (ALUop =10), divide (ALUop =11)
	input logic clk, // clock signal
	input logic rst_n, //active-low reset signal used for initialization
	output logic [31:0] s, // The result of add/sub
	output logic [31:0] hi, // The left half of the product/remainder register for multiply/Divide
	output logic [31:0] lo, // The right half of the product/remainder register for multiply/Divide
	output logic zero // The zero flag
);
	
	logic enabled_mult = 0;
	logic enabled_div = 0;
	logic enabled_add_sub = 0;
	always @(*)
	begin
	case(ALUop)
		2'b00 : enabled_add_sub = 1'b1; // ADD
		2'b01 : enabled_add_sub = 1'b1; // SUB
		2'b10 : enabled_mult = 1'b1; // Mult
		2'b11 : enabled_div = 1'b1; // Div
	endcase
	end
	logic[31:0]hi_mult, lo_mult, hi_div, lo_div;
	//Defines the function modules
	// ctrl = ALUop[0]
	cla32b_addsub addsub (.a(a),.b(b),.clk(clk), .rst_n(rst_n), .cin(1'b0),.ctrl(ALUop[0]),.enabled(enabled_add_sub),.s(s),.cout(cout));
	mult_32b_unsigned mult (.a(a),.b(b),.clk(clk),.rst_n(rst_n),.enabled(enabled_mult),.hi(hi_mult),.lo(lo_mult));
	div_32b_unsigned div (.a(a),.b(b),.clk(clk),.rst_n(rst_n),.enabled(enabled_div),.hi(hi_div),.lo(lo_div));
	always @(*)
	begin
	case(ALUop)
		2'b10 : begin hi=hi_mult; lo=lo_mult; end// Mult
		2'b11 : begin hi=hi_div; lo=lo_div; end// Div
	endcase
	end
	/*Check ALUop: probably always_comb because this is combinational logic
		If ALUop matches, enable the corresponding module
		For add/sub, update ctrl with correct value (0 for add, 1 for sub)
			This can be easily done through the following:
				Check ALUop[1]: 
					0 = add/sub, ALUop[0] -> ctrl, enable add/sub
					1 = mult/div, check ALUop[0] to decide which to enable
	*/
	
	//Check output value for zero to flip zero flag (True if result is 0)
	always @(*)
	begin
	case(ALUop)
		2'b00 : begin if (s==0) zero = 1'b1; end // ADD
		2'b01 : begin if (s==0) zero = 1'b1; end // SUB
		2'b10 : begin if (hi==0 && lo ==0) zero = 1'b1; end // Mult
		2'b11 : begin if (hi==0 && lo ==0) zero = 1'b1; end // Div
	endcase
	end
endmodule