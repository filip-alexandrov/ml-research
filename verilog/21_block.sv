module syncbad(input logic clk, 
    output logic d, 
    output logic q); 

    logic n1; 
    
    // for synchronous sequential logic
    always_ff @(posedge clk)
    begin 
        // assignment occurs in the order it appears in the file 
        // produces single flipflop (n1 not visible by the outside)
        n1 = d; // blocking 
        q = n1; // blocking 
    end
endmodule