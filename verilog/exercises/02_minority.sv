module minority(input logic a, b, c, 
    output logic y); 

    // at least 2 false => true 
    y = ~a & ~b | ~a & ~c | ~b & ~c;  
endmodule
