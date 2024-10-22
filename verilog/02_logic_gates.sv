module gates(input logic [3:0] a, b,
    output logic [3:0] y1, y2, y3, y4, y5); 

/* five different two-input logic gates
acting on 4-bit busses, act elementwise */

assign y1 = a & b; // and
assign y2 = a | b; // or
assign y3 = a ^ b; // xor 
assign y4 = ~(a & b); // nand, inversion takes precedence
assign y5 = ~(a | b); // nor

endmodule
