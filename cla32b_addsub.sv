module cla32b_addsub (input logic [31:0] a,b,
	input logic cin, ctrl, enabled,
	output logic [31:0] s,
	output logic cout
);

	//Wire connects module component cout to the next cin
	wire [6:0] w;
	logic [31:0] result;
	//8 4-bit components create a 32-bit carry-lookahead adder
	//Ctrl signal enables addition and subtraction
	add_sub_4b comp1 (a[3:0], b[3:0], ctrl, ctrl, result[3:0], w[0]);
	add_sub_4b comp2 (a[7:4], b[7:4], w[0], ctrl, result[7:4], w[1]);
	add_sub_4b comp3 (a[11:8], b[11:8], w[1], ctrl, result[11:8], w[2]);
	add_sub_4b comp4 (a[15:12], b[15:12], w[2], ctrl, result[15:12], w[3]);
	add_sub_4b comp5 (a[19:16], b[19:16], w[3], ctrl, result[19:16], w[4]);
	add_sub_4b comp6 (a[23:20], b[23:20], w[4], ctrl, result[23:20], w[5]);
	add_sub_4b comp7 (a[27:24], b[27:24], w[5], ctrl, result[27:24], w[6]);
	add_sub_4b comp8 (a[31:28], b[31:28], w[6], ctrl, result[31:28], cout);
	
	always @(posedge clk) begin
		if (~rst_n) begin
			w <= 6'd0;
			result <= 32'd0;
		end
		else begin
			//Only pass result through if the module is enabled
			if (enabled) begin
				s <= result;
			end
		end
	
	end
	
	
	
	/*
	always_comb begin
		if (enabled) begin
			s <= result;
		end
	end
	*/
	
endmodule