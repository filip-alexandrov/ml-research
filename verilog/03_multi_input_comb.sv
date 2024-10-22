module and8(input logic[7:0] a, 
    output logic y); 

    // reduction operator, and on all bits to produce y
    assign y = &a; 

endmodule