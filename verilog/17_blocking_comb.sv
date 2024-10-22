module gate(input logic [3:0] a, b, 
    output logic [3:0] y1, y2, y3, y4, y5); 

    always_comb 
    begin
        // same like with assing statements (=)
        y1 = a & b; 
        y2 = a | b; 
        y3 = a ^ b; 
        y4 = ~(a & b); 
        y5 = ~(a | b);
    end

endmodule