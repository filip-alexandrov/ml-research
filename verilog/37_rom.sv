// 128 depth x 32 width (word) rom with one read port 
// contents initialized from file 
module rom(input logic [6:0] a, // 7 bits (2^7 addresses)
    output logic [31:0] rd); 

    logic [31:0] ROM[127:0]; // 128 addresses, each 32 bits

    // init with contents form file 
    initial 
        $readmemh("37_memfile.dat", ROM); 

    // read port 
    assign rd = ROM[a]; 

endmodule