module priority_casez(input logic [3:0] a,
    output logic [3:0] y); 

    always_comb
        casez (a)
            // outputs the most significant bit of the input
            4'b1???: y = 4'b1000; // ? = dont care
            4'b01??: y = 4'b0100; 
            4'b001?: y = 4'b0010; 
            4'b0001: y = 4'b0001;
            default: y = 4'b0000;   
        endcase

endmodule