module priority_encoder(input logic [7:0] a, 
    output logic [2:0] y, z, 
    output logic none1, none2); 

    always_comb begin 
        none1 = 1'b0; 
        none2 = 1'b0; 
        
        // first priority bit location (msb)
        casez (a)
            // indicate if no priority bit exists
            // 0 location not distinguishable, when all 0..00 and 0..01
            8'b0000_0000: begin y = 3'd0; none1 = 1'b1; end

            // priority bit exists
            8'b00000001: y = 3'd0;
            8'b0000001?: y = 3'd1;
            8'b000001??: y = 3'd2;
            8'b00001???: y = 3'd3;
            8'b0001????: y = 3'd4;
            8'b001?????: y = 3'd5;
            8'b01??????: y = 3'd6;
            8'b1???????: y = 3'd7;
        endcase

        // second priority bit location
        casez(a)
            // second bit on pos. 0
            8'b00000011: z = 3'b000;
            8'b00000101: z = 3'b000;
            8'b00001001: z = 3'b000;
            8'b00010001: z = 3'b000;
            8'b00100001: z = 3'b000;
            8'b01000001: z = 3'b000;
            8'b10000001: z = 3'b000;

            8'b0000011?: z = 3'b001;
            8'b0000101?: z = 3'b001;
            8'b0001001?: z = 3'b001;
            8'b0010001?: z = 3'b001;
            8'b0100001?: z = 3'b001;
            8'b1000001?: z = 3'b001;

            8'b000011??: z = 3'b010;
            8'b000101??: z = 3'b010;
            8'b001001??: z = 3'b010;
            8'b010001??: z = 3'b010;
            8'b100001??: z = 3'b010;

            8'b00011???: z = 3'b011;
            8'b00101???: z = 3'b011;
            8'b01001???: z = 3'b011;
            8'b10001???: z = 3'b011;

            8'b0011????: z = 3'b100;
            8'b0101????: z = 3'b100;
            8'b1001????: z = 3'b100;

            8'b011?????: z = 3'b101;
            8'b101?????: z = 3'b101;
            8'b11??????: z = 3'b110;

            // no second bit found, return missing second bit signal
            default: begin z = 3'b000; none2 = 1'b1; end

        endcase
    end
endmodule


