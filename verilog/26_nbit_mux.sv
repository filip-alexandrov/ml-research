// 2:1 mux 
module mux
    #(parameter width = 8;) // name and default value 
    (input logic [width-1 : 0] d0, d1, 
    input logic s, 
    output logic [width-1 : 0] y); 

    assign y = s ? d1 : d0; 

endmodule

module mux8(input logic [7:0] d0, d1, d2, d3, 
    input logic [1:0] s, 
    output logic [7:0] y); 

    logic [7:0] low, hi; 

    // default width parameter
    mux lowmux(d0, d1, s[0], low); 
    mux himux(d2, d3, s[0], hi); 
    mux outmux(low, hi, s[1], y); 
endmodule

module mux12(input logic [11:0] d0, d1, d2, d3, 
    input logic [1:0] s, 
    output logic [11:0] y); 

    logic [11:0] low, hi; 

    // set the parameter of the mux
    mux #(12) lowmux(d0, d1, s[0], low); 
    mux #(12) himux(d2, d3, s[0], hi); 
    mux #(12) outmux(low, hi, s[1], y); 
endmodule