`include "expcomp.sv"
`include "addmant.sv"
`include "shiftmant.sv"

module fpadd(input logic [31:0], a, b, 
    output logic [31:0] s);

    logic [7:0] expa, expb, exp_pre, exp, shamt; // exp of a, exp of b, exp before norm, exp after norm, shift amount (to align mantissas)
    logic alessb; // a < b
    logic [23:0] manta, mantb, shmant; // mantissa of a, b, shifted mantissa (aligned with bigger)
    logic [22:0] fract; // fraction of the sum

    assign {expa, manta} = {a[30:23], 1'b1, a[22:0]}; // extract exp and mantissa of a, implicit 1 incl., positive by default here
    assign {expb, mantb} = {b[30:23], 1'b1, b[22:0]};

    assign s = {1'b0, exp, fract}; // combine sign, exp, fraction (after sum)

    // in: expa, expb, out: alessb, exp_pre, shamt
    expcomp expcomp1(expa, expb, alessb, exp_pre, shamt); 

    // in: alessb, manta, mantb, shamt, out: shmant
    shiftmant shiftmant1(alessb, manta, mantb, shamt, shmant); 

    // in: alessb, manta, mantb, shmant, exp_pre, out: fract, exp
    addmant addmant1(alessb, manta, mantb, shmant, exp_pre, fract, exp); 

endmodule
