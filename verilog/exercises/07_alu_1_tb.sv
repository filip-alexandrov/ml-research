`include "07_alu_1.sv"

module testbench(); 
    logic clk, reset; 
    logic [31:0] a, b, result, result_expected; 
    logic [1:0] alu_control; 
    logic [31:0] vector_num, errors; 
    logic [97:0] test_vectors [10000:0]; 

    // init device under test 
    alu dut(a, b, alu_control, result); 

    // generate clock 
    always begin
        clk = 1; #5; clk = 0; #5; 
    end 

    // at start of test, load vectors and pulse reset 
    initial begin 
        $readmemh("07_alu_1.tv", test_vectors); 
        vector_num = 0; errors = 0; 
        reset = 1; #22; reset = 0; 
    end 

    // apply test vectors on rising edge of clk 
    always @(posedge clk) begin
        #1; {alu_control, a, b, result_expected} = test_vectors[vector_num]; 
    end

    // check the result on the falling edge 
    always @(negedge clk) 
        if (~reset) begin // skip during reset
            if (result !== result_expected) begin 
                $display("Error: inputs: a = %h (%h expected)", result, result_expected); 
                errors = errors + 1; 
            end

            vector_num = vector_num + 1;
            
            if(test_vectors[vector_num] === 98'bx) begin 
                $display("%d tests completed with %d errors", vector_num, errors); 
                $stop; 
            end
        end

endmodule