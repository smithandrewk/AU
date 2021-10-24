module add_sub_4b (
	input logic [3:0] a,b, // operands 
	input logic cin, // carry_in 
	input logic ctrl, // ADD(ctrl=0) and SUB(ctrl=1) 
	output logic [3:0] s, // The result of ADD/SUB 
	output logic cout // carry_out 
); 

	logic [3:0] p, g, comp_b, carry;

	//Negate B if ctrl is 1:
	//Complement B (use b XOR 1 (removes need for if))
	//Add 1 (add ctrl)
	assign comp_b = {b[3] ^ ctrl, b[2] ^ ctrl, b[1] ^ ctrl, b[0] ^ ctrl};

	assign p = a | comp_b; //Bitwise OR
	assign g = a & comp_b; //Bitwise AND

	//Carry look ahead
	assign carry[0] = cin; //C0 (assigned so a single line of bitwise xor can be used later)
	assign carry[1] = g[0] | (p[0] & cin); //C1
	assign carry[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & cin); //C2
	assign carry[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & cin); //C3
	
	assign cout = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]) | (p[3] & p[2] & p[1] & p[0] & cin); //C4

	//4 1-bit full adders
	//Because the carry bits are calculated with the look ahead, bitwise xor can be used with the entire 4-bit values
	assign s = a ^ comp_b ^ carry;

endmodule