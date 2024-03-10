`timescale 1ns / 1ps

module Main_ctrl #(

    parameter IN_WIDTH = 7
              
) (
    
    input   logic   [IN_WIDTH - 1 : 0]  i_instruction   ,

    output  logic   [1:0]               o_ALUOp         ,
    output  logic   [1:0]               o_ImmSrc        ,
    output  logic                       o_ALUSrc        ,
    output  logic                       o_Branch        ,
    output  logic                       o_MemRead       ,
    output  logic                       o_MemWrite      ,
    output  logic                       o_MemtoReg      ,
    output  logic                       o_RegWrite      
    
);


always_comb begin : MAIN_CONTROL_UNIT

    case (i_instruction)
        
        7'b1100110: begin           // R-Format 

            o_ALUOp     = 2'b10;    
            o_ImmSrc    = 2'b00;    
            o_ALUSrc    = 1'b0;  
            o_Branch    = 1'b0;  
            o_MemRead   = 1'b0;  
            o_MemWrite  = 1'b0;  
            o_MemtoReg  = 1'b0;  
            o_RegWrite  = 1'b1;  
            
        end 

        7'b1100000: begin           // Load 

            o_ALUOp     = 2'b00;    
            o_ImmSrc    = 2'b00;    
            o_ALUSrc    = 1'b1;  
            o_Branch    = 1'b0;  
            o_MemRead   = 1'b1;  
            o_MemWrite  = 1'b0;  
            o_MemtoReg  = 1'b1;  
            o_RegWrite  = 1'b1;  
            
        end 

        7'b0010011: begin           // Immediate Add, OR, AND 

            o_ALUOp     = 2'b00;    
            o_ImmSrc    = 2'b00;    
            o_ALUSrc    = 1'b1;  
            o_Branch    = 1'b0;  
            o_MemRead   = 1'b0;  
            o_MemWrite  = 1'b1;  
            o_MemtoReg  = 1'b0;  
            o_RegWrite  = 1'b1;  
            
        end 

        7'b1100010: begin           // Store 

            o_ALUOp     = 2'b00;    
            o_ImmSrc    = 2'b01;    
            o_ALUSrc    = 1'b1;  
            o_Branch    = 1'b0;  
            o_MemRead   = 1'b0;  
            o_MemWrite  = 1'b1;  
            o_MemtoReg  = 1'bx;  
            o_RegWrite  = 1'b0;  
            
        end 


        7'b1100011: begin           // Branch if Equal  

            o_ALUOp     = 2'b01;    
            o_ImmSrc    = 2'b10;    
            o_ALUSrc    = 1'b0;  
            o_Branch    = 1'b1;  
            o_MemRead   = 1'b0;  
            o_MemWrite  = 1'b0;  
            o_MemtoReg  = 1'bx;  
            o_RegWrite  = 1'b0;  
            
        end 

        default: begin            

            o_ALUOp     = 2'b11;    
            o_ImmSrc    = 2'b00;    
            o_ALUSrc    = 1'b0;  
            o_Branch    = 1'b0;  
            o_MemRead   = 1'b0;  
            o_MemWrite  = 1'b0;  
            o_MemtoReg  = 1'b0;  
            o_RegWrite  = 1'b0;  
            
        end 
        
    endcase
end
    
endmodule