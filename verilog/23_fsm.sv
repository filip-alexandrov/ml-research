// outputs every 3 cycles
module devide_by_3_fsm(input logic clk, 
    input logic reset, 
    output logic y); 

    // statetype (00 = S0, 01 = S1...) allows named variable usage
    typedef enum logic [1:0] [S0, S1, S2] statetype; 
    statetype state, nextstate; 
    
    // state register, just gets next state at clock (like analog fsm models)
    always_ff @(posedge clk, posedge reset)
        if(reset) state <= S0; 
        else state <= nextstate; 

    // next state logic
    always_comb
        case(state)
            S0: nextstate = S1; 
            S1: nextstate = S2; 
            S2: nextstate = S0; 
            default nextstate = S0; 
        endcase

    // output logic 
    assign q = (state == S0);

endmodule
