// unsigned multiplier (int)
module u_multipler(input logic [3:0] a, b,
    output logic [7:0] y); 

    // default multiplication is unsigned
    assign y = a * b; 
endmodule


// signed multiplier 
module s_multiplier(input logic signed [3:0] a, b, 
    output logic signed [7:0] y);

    assign y = a * b; 

endmodule
