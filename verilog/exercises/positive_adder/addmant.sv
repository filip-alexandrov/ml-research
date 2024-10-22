module addmant(input logic alessb, 
    input logic [23:0] manta, mantb, shmant, // mantissa of a, b, shifted mantissa (aligned with bigger) 
    input logic [7:0] exp_pre, // exp before normalization
    output logic [22:0] fract, // fraction of the sum
    output logic [7:0] exp); // exp of the sum 

    logic [24:0] addresult; 
    logic [23:0] addval; 

    assign addval = alessb ? mantb : manta; // gets the bigger mantissa
    assign addresult = shmant + addval; // adds the bigger mantissa to the shifted smaller mantissa

    assign fract = addresult[24] ? addresult[23:1] : addresult[22:0]; // covers overflow
    assign exp = addresult[24] ? (exp_pre + 1) : exp_pre; // increment exp if overflow

endmodule
