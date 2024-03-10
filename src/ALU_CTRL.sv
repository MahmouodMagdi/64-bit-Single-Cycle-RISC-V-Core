// -----------------------------------------------------------------------------------------------
// -----------------------------------------------------------------------------------------------
// |    ALUOp   |   instruction[30]   |   intruction[14:12]   |          ALU_Operation           |
// -----------------------------------------------------------------------------------------------
// -----------------------------------------------------------------------------------------------
// |     00     |          x          |          xxx          |     lw & sw --> ADD --> 0001     |
// -----------------------------------------------------------------------------------------------  
// -----------------------------------------------------------------------------------------------
// |     01     |          x          |          xxx          |     beq     --> SUB --> 0010     |
// -----------------------------------------------------------------------------------------------
// -----------------------------------------------------------------------------------------------
// |     10     |          0          |          000          |     R-Type  --> ADD --> 0001     |
// -----------------------------------------------------------------------------------------------
// |     10     |          1          |          000          |     R-Type  --> SUB --> 0010     |
// -----------------------------------------------------------------------------------------------
// |     10     |          0          |          111          |     R-Type  --> AND --> 0011     |
// -----------------------------------------------------------------------------------------------
// |     10     |          0          |          110          |     R-Type  --> OR  --> 0100     |
// -----------------------------------------------------------------------------------------------
// |     10     |          0          |          100          |     R-Type  --> XOR --> 0101     |
// -----------------------------------------------------------------------------------------------



`timescale 1ns / 1ps

module ALU_CTRL #(
    
    parameter OP_WIDTH = 2

) (

    input    logic   [OP_WIDTH - 1 : 0] i_ALUOp     ,
    input    logic   [OP_WIDTH     : 0] i_funct_3   ,                   // instruction[14:12]
    input    logic                      i_funct7    ,                   // instruction[30]
    output   logic   [OP_WIDTH + 1 : 0] o_ALU_Operation 

);

always_comb begin : ALU_DECODING

    case (i_ALUOp)

        2'b00 : // Load and Store Instructions --> ld, sd 
                begin
                   o_ALU_Operation = 4'b0001;   // ADD Operation  
                end


        2'b01 : // Brach If Equal Instruction  --> beq
                begin
                    o_ALU_Operation = 4'b0010;  // SUB Operation 
                end


        2'b10 : // R-Type Instructions --> ADD, SUB, AND, OR, XOR
                begin

                    case (i_funct_3)

                        3'b000: begin
                    
                            if (i_funct7 == 1'b1) begin

                                o_ALU_Operation = 4'b0010;          // SUB Operation 
                    
                            end else begin
                                o_ALU_Operation = 4'b0001;          // ADD Operation           
                            end
                        end 

                        3'b100: begin   
                            o_ALU_Operation = 4'b0101;              // XOR Operation 
                        end     

                        3'b110: begin
                            o_ALU_Operation = 4'b0100;              // OR Operation 
                        end 

                        3'b111: begin
                            o_ALU_Operation = 4'b0011;              // AND Operation 
                        end 

                        default: o_ALU_Operation = 4'b0;
                    endcase
                end

        default: o_ALU_Operation = 4'b0;
    endcase
end

endmodule