`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//
// Author:              Mahmoud Magdi 
// 
// Design Name:         RISC-V Core 
// Module Name:         Adder
// Project Name:        64-bit Single Cycle RISC-V core  
// Description:         This is a 64-bit adder PC adder that calculates the next  
//                      PC value based on the current value and type of the PC
// Dependencies:        
// 
//////////////////////////////////////////////////////////////////////////////////

module Adder #(

    parameter DATA_WIDTH = 64
    
) (
    
        input   logic   [DATA_WIDTH - 1 : 0] i_operand_a,        
        input   logic   [DATA_WIDTH - 1 : 0] i_operand_b,   

        output  logic   [DATA_WIDTH - 1 : 0] o_result

);

assign o_result = i_operand_a + i_operand_b;
    
endmodule
