`timescale 1ns/1ps
`include "04_mux8.sv"

// iverilog -g 2012 -o 04_out.out 04_mux8_tb.sv
// ./04_out.out
// gtkwave 04_waveform.vcd

module mux8_tb; 
    logic [7:0] d; // data
    logic [2:0] s; // select
    logic y; // output

    mux8to1 dut(d, s, y); 

    initial begin
        d = 8'b0000_0000; 
        s = 3'b000; 

        $dumpfile("04_waveform.vcd"); 
        $dumpvars(0, mux8_tb); 

        s = 3'b000; #1;  // Select d[0]
        s = 3'b001; #1;  // Select d[1]
        s = 3'b010; #1;  // Select d[2]
        s = 3'b011; #1;  // Select d[3]
        s = 3'b100; #1;  // Select d[4]
        s = 3'b101; #1;  // Select d[5]
        s = 3'b110; #1;  // Select d[6]
        s = 3'b111; #1;  // Select d[7]

        // Change the data pattern and repeat
        d = 8'b11001100;

        s = 3'b000; #1;  // Select d[0]
        s = 3'b001; #1;  // Select d[1]
        s = 3'b010; #1;  // Select d[2]
        s = 3'b011; #1;  // Select d[3]
        s = 3'b100; #1;  // Select d[4]
        s = 3'b101; #1;  // Select d[5]
        s = 3'b110; #1;  // Select d[6]
        s = 3'b111; #1;  // Select d[7]

        $finish; 
    end

endmodule