module fulladder(input logic a, b , cin, 
    output logic s, cout); 

    // internal signals, (p)propagate, (g)generate
    logic p, q; 

    assign p = a ^ b; 
    assign g = a & b; 

    assign s = p ^ cin; 
    assign cout = g | (p & cin); 

endmodule