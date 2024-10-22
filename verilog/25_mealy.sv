// again 0,1 sequence detector
// timing different, output is 1 clock cycle faster
module seqDetectMealy(input logic clk, reset, a, 
    output logic smile); 
    typedef enum logic (S0, S1) statetype; 
    statetype state, nextstate; 

    // state register
    always_ff @(posedge clk, posedge reset) 
        if(reset) state <= S0; 
        else state <= nextstate; 

    // next state and output logic combined
    always_comb begin
        // make deterministic, otherwise has to be assigned in the case statements
        smile = 1'b0; 
        case(state) 
            S0: if(a) nextstate = S0; 
                else nextstate = S1; 
            S1: if(a) 
                    begin
                        nextstate = S0; 
                        smile = 1'b1; 
                    end
                else nextstate = S1; 
            default: nextstate = S0; 
        endcase
    end

endmodule
