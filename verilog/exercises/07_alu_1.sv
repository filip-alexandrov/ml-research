// simple alu

module alu(input logic [31:0] a, 
    input logic [31:0] b, 
    input logic [1:0] alu_control,
    output logic [31:0] y); 

    logic [31:0] cond_inv_b, sum; 

    assign cond_inv_b = alu_control[0] ? ~b : b; // inverts b (2s complement) if subtract
    assign sum = a + cond_inv_b + alu_control[0]; // add or subtract (subtract adds cin = 1 (2s complement) to b)

    always_comb
        case(alu_control)
            2'b00: y = sum; // add
            2'b01: y = sum; // subtract
            2'b10: y = a & b; // and
            2'b11: y = a | b;
            default: result = 32'bx; 
        endcase
endmodule