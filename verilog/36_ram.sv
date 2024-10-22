module ram 
    #(parameter N = 6, M = 32) // N = width, M = depth
    (input logic clk, 
    input logic we, // write enable 
    input logic [N-1 : 0] adr, // address 
    input logic [M-1 : 0] din, // value in 
    output logic [M-1 : 0] dout); // read out value 

    logic [M-1:0] mem [2**N-1:0]; // memory matrix 

    always_ff @(posedge clk)
        if(we) mem[adr] <= din; 

    assign dout = mem[adr]; // direct access, no clock

endmodule

