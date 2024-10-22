module sevenseq(input logic [3:0] data, 
    output logic [6:0] segments); 

    always_comb
        case(data)
            //               abc_defg
            0: segments = 7'b111_1110; 
            1: segments = 7'b011_0000; 
            2: segments = 7'b110_1101; 
            3: segments = 7'b111_1001; 
            // and so on...

            // comb logic has to have output specified for every case
            // otherwise may result in latch (remembering prev state required)
            default: segments = 7'b000_0000; // required otherwise may produce latches
        endcase
endmodule

