module mux8to1(input logic [7:0] d, // input lines 
    input logic [2:0] s, // select lines
    output logic y);

    assign y = d[s]; 
    
endmodule