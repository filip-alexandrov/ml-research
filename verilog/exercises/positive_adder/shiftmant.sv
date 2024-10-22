module shiftmant(input logic alessb, // a < b
    input logic [23:0] manta, mantb, // mantissa a, mantissa b
    input logic [7:0] shamt, // shift amount
    output logic[23:0] shmant); // shifted mantissa

    logic [23:0] shiftedval; // shifted value 

    assign shiftedval = alessb ? (mantb >> shamt) : (manta >> shamt);

    always_comb
        if (shamt[7] | shamt[6] | shamt[5] | (shamt[4] & shamt[3]))
            shmant = 24'b0; // shift amount too large
        else
            shmant = shiftedval;
endmodule