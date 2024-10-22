`timescale 1ns/1ps
// each unit = 1ns, simulaiton precision = 1ps

module example(input logic a, b, c, 
    output logic y); 

    // internal nodes and a bar, etc.
    logic ab, bb, cb, n1, n2, n3; 

    // nand delay 1ns
    assign #1 {ab, bb, cb} = ~{a, b, c}; 

    // and delay 2ns
    assign #2 n1 = ab & bb & cb; 
    assign #2 n2 = a & bb & cb; 
    assign #2 n3 = a & bb & c; 

    // or delay 4ns
    assign #4 y = n1 | n2 | n3; 

endmodule
