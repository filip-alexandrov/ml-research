// testbenches not synthesizable, only test
module testbench1(); 
    logic a, b, c; 
    logic y; 

    // instantiate device under test, dut = instance name 
    sillyfunction dut(a, b, c, y); 

    // apply inputs one at a time 
    initial begin
        // set, then delay 10 ticks (ns)
        a = 0; b = 0; c = 0; #10; 
        c = 1; #10; 
        b = 1; c = 0; #10; 
        c = 1; #10; 
        a = 1; b = 0; c = 0; #10; 
        c = 1; #10; 
        b = 1; c = 0; #10; 
        c = 1; #10; 
    end
endmodule