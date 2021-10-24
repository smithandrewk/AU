module mult_32b_unsigned (input logic [31:0] a,b, // operands
	input logic clk, rst_n, enabled,
	output logic [31:0] hi, // The left half of the product/remainder register for multiply/Divide
	output logic [31:0] lo // The right half of the product/remainder register for multiply/Divide
);

	integer i = 0;
	logic [63:0] product;
	
	always @(posedge clk) begin
		if (~rst_n) begin
			//Initialization: muliplier placed in right half of product register
			i <= 0;
			product <= {32'd0, b};
			hi <= 32'd0;
			lo <= 32'd0;
		end
		else begin
			//If this module is enabled, then
			if (enabled) begin
				//This condition causes the operations to run 32 times
				//Implements a clock based for loop
				if (i < 32) begin
					//If product[0] = 1
					if (product[0]) begin
						//Add Mcand to left half of product
						//Place the result in the left half of the product register
						product[63:32] = a + product[63:32];
					end
					//Shift product register right 1 bit
					product = product >> 1;
					i = i + 1;
				end
				else if (i == 32) begin
					//Loop is complete, product contains result
					hi = product[63:32];
					lo = product[31:0];
				end
			end
		end
	end
	
	/*
	always_comb begin
		//If this module is enabled, then
		if (enabled) begin
			//Initialization: muliplier placed in right half of product register
			product[31:0] = b;
			//Loop through the operations 32 times
			for (i = 0; i < 32; i++) begin
				//If product[0] = 1
				if (product[0]) begin
					//Add Mcand to left half of product
					//Place the result in the left half of the product register
					product[63:32] = a + product[31:0];
				end
				//Shift product register right 1 bit
				product = product >> 1;
			end
			hi = product[63:32];
			lo = product[31:0];
		end
	end	
	*/
endmodule