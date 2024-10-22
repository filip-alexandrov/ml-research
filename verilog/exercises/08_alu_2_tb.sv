`include "08_alu_2.sv"

module testbench(); 
    logic clk, reset; 
    logic [31:0] a, b, result, result_expected; 
    logic [2:0] alu_control;
    logic [31:0] vector_num, errors;
    logic [98:0] test_vectors [10000:0];

    // init
    alu dut(a, b, alu_control, result); 

    // generate clock 
    always begin 
        clk = 1; #5; clk = 0; #5; 
    end 

    // at start of the test load vectors and pulse reset
    initial begin 
        $readmemh("08_alu_2.tv", test_vectors); 
        vector_num = 0; errors = 0; 
        reset = 1; #22; reset = 0; 
    end

    // apply test vectors on the rising edge of clk 
    always @(posedge clk) begin 
        #1; {alu_control, a, b, result_expected} = test_vectors[vector_num]; 
    end

    // check results on the falling edge of clk 
    always @(negedge clk) 
        if (~reset) begin // skip during reset
            if (result !== result_expected) begin 
                $display("Error: inputs: a = %h, b = %h, alu_control = %h, result = %h (%h expected)", a, b, alu_control, result, result_expected); 
                errors = errors + 1; 
            end

            vector_num = vector_num + 1; 

            if(test_vectors[vector_num] === 99'bx) begin 
                $display("%d tests completed with %d errors", vector_num, errors); 
                $finish; 
            end
        end

endmodule