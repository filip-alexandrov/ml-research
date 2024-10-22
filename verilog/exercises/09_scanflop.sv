module scanflop(input logic clk, test, sin, 
    input logic [3:0] d, 
    output logic [3:0] q, 
    output logic sout); 

    always_ff @( posedge clk )
        if(test) 
            // if test is active, d is loaded into q
            q <= d; 
        else
            // otherwise, sin is loaded into q and bits are shifted
            q <= {q[2:0], sin}; 
        
    assign sout = q[3]; 

endmodule