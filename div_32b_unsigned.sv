module div_32b_unsigned (input logic [31:0] a,b, // operands
	input logic clk, rst_n, enabled,
	output logic [31:0] hi, // The left half of the product/remainder register for multiply/Divide
	output logic [31:0] lo // The right half of the product/remainder register for multiply/Divide
);
	//Dividend is A
	//Divisor is B
	integer i = 0;
	logic [63:0] remainder;
	
	always @(posedge clk) begin
		if (~rst_n) begin
			//Initialization:
			i <= 0;
			//Dividend in right half of remainder (quotient)
			//Left half of remainder initialized to 0
			//Shift remainder register left 1 bit (this is the first step after initialization but isn't repeated)
			remainder <= {31'd0, a, 1'b0};
			hi <= 32'd0;
			lo <= 32'd0;
		end
		else begin
			//If this module is enabled, then
			if (enabled) begin
				//This condition causes the operations to run 32 times
				//Implements a clock based for loop
				if (i < 32) begin
					//If left half of remainder is >= 0
					//If left half is >= 0, remainder_left is >= b
					if (remainder[63:32] >= b) begin
						//Knowing that the left half of remainder is >= b,
						//Subtract the divisor from the left half of the remainder register and place the result there
						remainder[63:32] = remainder[63:32] - b;
						//Shift remainder register to the left and set the new rightmost bit to 1
						remainder = remainder << 1;
						remainder[0] = 1'b1;
					end
					//If left half of remainder is < 0
					//If left half is < 0, remainder_left is < b
					else begin
						//***Original value is not restored because a check is performed before subtraction to prevent negative numbers being stored and needing to be restored.
						//Restore original value by adding divisor to left half of remainder register
						//remainder[63:32] = remainder[63:32] + b;
						//Also, shift remainder register left and set new rightmost bit to 0
						remainder = remainder << 1;
						remainder[0] = 0;
					end
					i = i + 1;
				end
				else if (i == 32) begin
					//Shift left half of remainder right 1 bit
					remainder[63:32] = remainder[63:32] >> 1;
					//Loop is complete, remainder contains result
					hi = remainder[63:32]; //Remainder
					lo = remainder[31:0]; //Quotient
				end
			end
		end
	end
	
	
	
	/*
	always_comb begin
		//If this module is enabled, then
		if (enabled) begin
			//Initialization:
			//Dividend in right half of remainder (quotient)
			//Left half of remainder initialized to 0
			remainder = {32'b0, a};
			//Shift remainder register left 1 bit
			remainder = remainder << 1;
			//Loop through the operations 32 times
			for (i = 0; i < 32; i++) begin
				//If left half of remainder is >= 0
				if (remainder[63:32] >= 0) begin
					//Shift remainder register to the left and set the new rightmost bit to 1
					remainder = remainder << 1;
					remainder[0] = 1'b1;
				end
				//If left half of remainder is < 0
				else begin
					//Restore original value by adding divisor to left half of remainder register
					remainder[63:32] = remainder[63:32] + b;
					//Also, shift remainder register left and set new rightmost bit to 0
					remainder = remainder << 1;
					remainder[0] = 0;
				end
			end
			//Shift left half of remainder right 1 bit
			remainder[63:32] = remainder[63:32] >> 1;
			hi = remainder[63:32];
			lo = remainder[31:0];
		end
	end	
	*/
endmodule