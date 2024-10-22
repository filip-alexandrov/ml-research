module flop(input logic clk, 
    input logic [3:0] d, 
    input logic [3:0] q); 

    // 4 bit register
    // at positive (rising) edge: q gets d
    always_ff @( posedge clk )
        q <= d; 

endmodule