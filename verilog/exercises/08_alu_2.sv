module alu(input logic [31:0] a, 
    input logic [31:0] b, 
    input logic [2:0] alu_control,
    output logic [31:0] y);

    logic [31:0] cond_inv_b, sum;
    logic cout; // carry out of the adder 

    assign cond_inv_b = alu_control[0] ? ~b : b;
    assign {cout, sum} = a + cond_inv_b + alu_control[0]; // slt (+1), add, sub (+1)

    // this slt implementation is not correct
    // overflow is not considered
    always_comb
        case(alu_control)
            3'b000: y = sum; // add
            3'b001: y = sum; // subtract
            3'b010: y = a & b; // and
            3'b011: y = a | b; // or
            3'b101: y = {31'b0, sum[31]}; // slt, also goes = sum[31]
            default: y = 32'bx;
        endcase

endmodule
