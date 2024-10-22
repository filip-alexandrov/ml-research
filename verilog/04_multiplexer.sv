module mux2(input logic[3:0] d0, d1, 
    input logic s, // select line
    output logic[3:0] y); 


    // ternary operator
    assign y = s ? d1 : d0; 

endmodule