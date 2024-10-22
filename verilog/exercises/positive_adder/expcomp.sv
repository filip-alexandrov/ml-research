module expcomp(input logic [7:0] expa, expb, // exp of a, exp of b
    output logic alessb, // a < b
    output logic [7:0] exp, shamt); // exp = max(expa, expb), shamt = |expa - expb|

    logic [7:0] aminusb, bminusa; // a - b, b - a

    assign aminusb = expa - expb;
    assign bminusa = expb - expa;
    assign alessb = aminusb[7]; // a < b if aminusb[7] = 1

    always_comb
        if (alessb) begin 
            exp = expb; 
            shamt = bminusa; 
        end
        else begin
            exp = expa; 
            shamt = aminusb;
        end
endmodule

