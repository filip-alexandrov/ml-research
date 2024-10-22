module flopr(input logic clk, 
    input logic reset, 
    input logic [3:0] d, 
    output logic [3:0] q); 

    // reset (event) in the sensitivity list
    // evaluates the block on 2 events
    always_ff @(posedge clk, posedge reset)
        if(reset) q <= 4'b0; 
        else q <= d; 

endmodule