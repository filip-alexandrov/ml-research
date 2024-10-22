// not to be used, just for demo purpose
// if synthesis tool produces a latch from comb. logic error message will be printed
module latch(input logic clk, 
    input logic [3:0] d, 
    output logic [3:0] q); 

    always_latch
        if(clk) q <= d; 

endmodule