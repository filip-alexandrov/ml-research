module flopr(input logic clk, 
    input logic reset, 
    input logic [3:0] d, 
    output logic [3:0] q); 

    always_ff @(posedge clk)
        if(reset) q <= 4'b0; 
        else q <= d; 

endmodule