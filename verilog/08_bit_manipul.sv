module bitman(input logic [2:0] a, output logic [11:0] y); 

    // y = a[2] a[1] b[0] b[0] b[0] a[0] 1 0 0 0 1 0
    assign y = {a[2:1], { 3 {b[0]} }, a[0], 6'b100_010}; // 3 times, concat

endmodule