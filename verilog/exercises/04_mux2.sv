module mux2to1 (
    input logic s, // select 
    input logic d0, d1, 
    output logic y
);
    assign y = s ? d1 : d0; 
    
endmodule