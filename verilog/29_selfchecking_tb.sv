module testbench2(); 
    logic a, b, c; 
    logic y; 

    sillyfunction dut(a, b, c, y); // instantiate dut 

    initial begin 
        a = 0; b = 0; c = 0; #10; 
        if (y !== 1) $display("000 failed"); 

        c = 1; #10; 
        if (y !== 0) $display("001 failed"); 

        b = 1; c = 0; #10; 
        if(y !== 0) $display("011 failed"); 

        // and so on for every combination of the truth table....
    end

endmodule


