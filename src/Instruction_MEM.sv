`timescale 1ns / 1ps

module Instruction_MEM #(

    parameter ADDR_WIDTH = 8,
              INST_WIDTH = 32

) (

    input   logic   [ADDR_WIDTH - 1 : 0] i_addr,
    output  logic   [INST_WIDTH - 1 : 0] o_instruction 

);


logic   [INST_WIDTH - 1 : 0] ROM [(INST_WIDTH*2) - 1 : 0];       // 512-Location ROM each of 64 bits

initial begin
    $readmemh("InstructionMem.txt", ROM);
end

assign o_instruction = ROM[i_addr];

endmodule