module syncgood(input logic clk,
    input logic d, 
    input logic q); 

    logic n1; 
    always_ff @(posedge clk)
    begin 
        // assignment happens concurrently (right for sequential logic)
        n1 <= d; // nonblocking 
        q <= n1; // nonblocking 
    end

endmodule