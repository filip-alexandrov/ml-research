// onramp block 
module pandg(input logic [30:0] a, b,
    output logic [30:0] p, g); 

    assign p = a | b; 
    assign g = a & b; 

endmodule

// intermittent blocks
module blackbox(input logic [15:0] pleft, pright, gleft, gright, 
    output logic [15:0] pnext, gnext); 

    // elementwise for all inputs / outputs
    assign pnext = pleft & pright; 
    assign gnext = pleft & gleft | gright; 

endmodule

// offramp block
module sum(input logic [31:0] g, a, b,
    output logic [31:0] s); 
    
    assign s = a ^ b ^ g; 

endmodule

