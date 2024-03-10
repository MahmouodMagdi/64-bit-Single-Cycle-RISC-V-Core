`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//
// Author:              Mahmoud Magdi 
// 
// Design Name:         RISC-V Core 
// Module Name:         ALU
// Project Name:        64-bit Single Cycle RISC-V core  
// Description:         This is the Arithematic Logic Unit which is the core unit 
//                      of any processor.
//			This unit supports:
//						- R-Type: Add, Subtract, AND, OR, XOR 
//						- I-Type: Addi, ANDi, ORi, XORi
//						- B-Type: Branch if equal 
//						- Memory Instructions: Load and Store
//    
// 
//////////////////////////////////////////////////////////////////////////////////

module ALU #(

    parameter DATA_WIDTH = 32

) (

    input   logic   [DATA_WIDTH - 1 : 0] i_operand_a ,              // 1st Operand 
    input   logic   [DATA_WIDTH - 1 : 0] i_operand_b ,              // 2nd Operand 
    input   logic   [3:0]                i_op        ,              // Input Operation signal  
    output  logic                        o_zero      ,              // Carry Out 
    output  logic   [DATA_WIDTH - 1 : 0] o_result                   // Output Result 

);

typedef enum logic [3:0]{ 
    NO_OP       ,
    ADD         , 
    SUB         ,
    AND         ,
    OR          ,
    XOR         

 } OpCode;

logic [DATA_WIDTH - 1 : 0] adder_sum;
logic [DATA_WIDTH - 1 : 0] operand_b;
logic                      c_in, c_out;

/////////////////////////////////////////////////////////////////////
// --- Selecting either the operatn is addition or subtraction --- //
/////////////////////////////////////////////////////////////////////
assign operand_b = (i_op == 'b0010) ? (~i_operand_b) : i_operand_b;
assign c_in      = (i_op == 'b0010) ?      1'b1      : 1'b0; 


always_comb begin 

    case (i_op)

        ADD        :begin
            o_result = adder_sum;
        end

        SUB        :begin
            o_result = adder_sum;
        end

        AND        :begin
            o_result = i_operand_a & i_operand_b;
        end

        OR         :begin
            o_result = i_operand_a | i_operand_b;
        end

        XOR        :begin
            o_result = i_operand_a ^ i_operand_b;
        end

        default: o_result = 'b0;
    
    endcase
    
end


carry_look_ahead_adder #(
    
	.DATA_WIDTH(DATA_WIDTH)
	
) CLA_ADDER (
    
	.in_1  (i_operand_a),
    .in_2  (operand_b  ),
	.c_in  (c_in       ),
    .o_Sum (adder_sum  ),
	.c_out (c_out      )
    
);

assign o_zero = ((o_result == 'b0) || (o_result == {16{4'hf}})) ? 1'b1 : 1'b0 ;

endmodule
