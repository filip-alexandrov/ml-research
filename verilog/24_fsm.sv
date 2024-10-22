// sequence detector, outputs 1 if it detects 0,1
// mooore, behaviour module
module seqDetectMoore (input logic clk, reset, a, 
    output logic smile); 
    // also possible, but compiler might ignore: 
    // typedef enum logic [2:0] (S0 = 3'b001, S1 = 3'b010, S2 = 3'b100)
    typedef enum logic [1:0] (S0, S1, S2) statetype; 
    statetype state, nextstate; 

    // state register
    always_ff @(posedge clk, posedge reset)
        if(reset) state <= S0; 
        else state <= nextstate; 

    // next state logic 
    always_comb
        case(state) 
            S0: if(a) nextstate = S0; 
                else nextstate = S1; 
            S1: if(a) nextstate = S2; 
                else nextstate = S1; 
            S2: if(a) nextstate = S0; 
                else nextstate = S1; 
                
            // 1 state never occurs but comb logic has to be always deterministic
            default: nextstate = S0; 
        endcase

    // output logic 
    assign smile = (state == S2); 
    
endmodule