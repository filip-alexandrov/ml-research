// three ported register file 
// reads from a1, a2 and writes to a3 simoutaneously 
module regfile(input logic clk, 
    input logic we3, // write enable
    input logic [5:0] a1, a2, a3, 
    input logic [31:0] wd3, 
    output logic [31:0] rd1, rd2); 

    // 32 bit value, 2^6 bit address space
    logic [31:0] rf[5:0]; 

    always_ff @(posedge clk) 
        if(we3) rf[a3] <= wd3; 

    assign rd1 = (a1 != 0) ? rf[a1] : 0; 
    assign rd2 = (a2 != 0) ? rf[a2] : 0; 

endmodule

      