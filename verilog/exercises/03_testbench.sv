`include "03_sevenseq.sv"

// iverilog -g 2012 -o 03_out.out 03_testbench.sv
// ./03_out.out

module ex_testbench(); 
    logic clk, reset; 
    logic [3:0] data; 
    logic [6:0] s_expected; 
    logic [6:0] s; 
    logic [31:0] vectornum, errors; 
    logic [10:0] testvectors[10000:0]; 

    // init device under test 
    sevenseq dut(data, s); 

    always begin 
        clk = 1; #5; clk = 0; #5; 
    end


    initial begin
        $readmemb("03_testvector.tv", testvectors); 
        vectornum = 0; errors = 0; 
        reset = 1; #20; reset = 0;
    end

    always @(posedge clk) begin
        #1; {data, s_expected} = testvectors[vectornum];
    end

    always @(negedge clk)
        if(~reset) begin 
            if(s != s_expected) begin 
                $display("Error: inputs = %b", data); 
                $display("Outputs = %b (%b expected)", s, s_expected);
                errors = errors + 1; 
            end

            vectornum = vectornum + 1; 

            if(testvectors[vectornum] === 11'bx) begin
                $display("%d tests completed with %d errors", vectornum, errors);
                $finish; 
            end 
        end
endmodule




