`timescale 1ns / 1ps

module riscv_top #(

    parameter   OP_WIDTH       = 2   ,
                ADDR_WIDTH     = 5   ,
                INST_WIDTH     = 32  ,
                DATA_WIDTH     = 64  ,
                Reg_File_Depth = 128 ,
                MEM_DEPTH      = 128

) (
    
    input   logic   i_clk,
    input   logic   i_rst_n

);
    

// ----------------------------------------
//            Internal Signals 
// ----------------------------------------
logic   [DATA_WIDTH - 1 : 0]    PC, PC_next  ;                                       // Program Counter Register 
logic   [DATA_WIDTH - 1 : 0]    adder_out, adder_2_out  ;                            // Next PC adderss 
logic   [INST_WIDTH - 1 : 0]    instruction;                                         // Instructio to be executed
logic   [DATA_WIDTH - 1 : 0]    operand_a, operand_b, alu_operand_2, alu_out, mem_data_out, sign_extended, MEM_TO_REG_MUX_out;
logic   [OP_WIDTH   + 1 : 0]    ALU_Operation;
logic   [OP_WIDTH   - 1 : 0]    ALUOp, ImmSrc;
logic                           alu_zero, Branch, MemRead, MemWrite, MemtoReg, RegWrite, PCSrc, ALUSrc;

// PCSrc Logic 
assign PCSrc = Branch && alu_zero;


// ----------------------------------------
//                 PC Logic 
// ----------------------------------------

Adder #(

    .DATA_WIDTH(DATA_WIDTH)
    
) PC_adder_1 (
    
        .i_operand_a(PC_next  ),        
        .i_operand_b(64'd4    ),   

        .o_result   (adder_out)

);


Adder #(

    .DATA_WIDTH(DATA_WIDTH)
    
) PC_adder_2 (
    
        .i_operand_a(adder_out),        
        .i_operand_b(sign_extended << 2),   

        .o_result   (adder_2_out)

);


mux_2x1 #(

    .DATA_WIDTH(DATA_WIDTH)

) PC_MUX (
    
    .in_0 (adder_out    ),
    .in_1 (adder_2_out  ),
    .i_Sel(PCSrc        ),

    .out(PC)

);

// ---------------------------
//  PC Next Registered Value 
// ---------------------------
Program_Counter #(

    .DATA_WIDTH(DATA_WIDTH)

) PC_reg (
    
    .i_clk     (i_clk  ),
    .i_rst_n   (i_rst_n),
    .i_PC      (PC     ),
    .o_PC_next (PC_next)

);



// ----------------------------------------
//           Instruction Memeory 
// ----------------------------------------
Instruction_MEM #(

    .ADDR_WIDTH (8),
    .INST_WIDTH (INST_WIDTH)

) INSTR_MEM (

    .i_addr        (PC_next[9:2]) ,
    .o_instruction (instruction)

);


// ----------------------------------------
//                 REGISTER FILE
// ----------------------------------------
Reg_File #(

    .DATA_WIDTH    (DATA_WIDTH    ),
    .Reg_File_Depth(Reg_File_Depth),
    .ADDR_WIDTH    (ADDR_WIDTH    )
    
    ) REGISTER_FILE (
    
       .i_clk        (i_clk             )   ,  
       .i_rst_n      (i_rst_n           )   ,          
       .i_reg_write  (RegWrite          )   ,
       .i_read_reg_1 (instruction[19:15])   ,       
       .i_read_reg_2 (instruction[24:20])   ,       
       .i_write_reg  (instruction[11:7] )   ,
       .i_write_data (MEM_TO_REG_MUX_out)   ,     
       .o_read_data_1(operand_a         )   ,         
       .o_read_data_2(operand_b         )        

);




// ----------------------------------------
//               MAIN CONTROLLER
// ----------------------------------------
Main_ctrl #(

    .IN_WIDTH(7)
              
) MAIN_CONTROL_UNIT (
    
    .i_instruction (instruction[6:0])  ,

    .o_ALUOp       (ALUOp   )  ,
    .o_ImmSrc      (ImmSrc  )  ,
    .o_ALUSrc      (ALUSrc  )  ,
    .o_Branch      (Branch  )  ,
    .o_MemRead     (MemRead )  ,
    .o_MemWrite    (MemWrite)  ,
    .o_MemtoReg    (MemtoReg)  ,
    .o_RegWrite    (RegWrite)  
    
);




// ----------------------------------------
//                  ALU MUX 
// ----------------------------------------
mux_2x1 #(

    .DATA_WIDTH(DATA_WIDTH)

) ALU_MUX (
    
    .in_0 (operand_b    ),
    .in_1 (sign_extended),
    .i_Sel(ALUSrc       ),

    .out  (alu_operand_2)

);



// ----------------------------------------
//           Arithmatic Logic Unit 
// ----------------------------------------
ALU #(

    .DATA_WIDTH(DATA_WIDTH)

) ALU (

    .i_operand_a (operand_a    ),                           
    .i_operand_b (alu_operand_2),                          
    .i_op        (ALU_Operation),                             
    .o_zero      (alu_zero     ),                           
    .o_result    (alu_out      )                            

);



// ----------------------------------------
//      Arithmatic Logic Unit Controller 
// ----------------------------------------
ALU_CTRL #(
    
    .OP_WIDTH(OP_WIDTH)

) ALU_CONTROL_UNIT (

    .i_ALUOp         (ALUOp             ) ,
    .i_funct_3       (instruction[14:12]) ,                   
    .i_funct7        (instruction[30]   ) ,                   
    .o_ALU_Operation (ALU_Operation     )

);



// ----------------------------------------
//            Sign Extending Block 
// ----------------------------------------
Sign_Extend #(
    
    .INST_WIDTH(INST_WIDTH)

) Sign_Extending (
    
    .i_instruction(instruction),                                 
    .i_ImmSrc     (ImmSrc),                                     
    .o_extended   (sign_extended)                               

);


// ----------------------------------------
//                Data Memory 
// ----------------------------------------
Data_MEM #(

    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(8),    
    .MEM_DEPTH (MEM_DEPTH )

) DATA_MEMORY (
    
    .i_clk      (i_clk       ) ,
    .i_rst_n    (i_rst_n     ) ,
    .i_Mem_Write(MemWrite    ) ,
    .i_Mem_Read (MemRead     ) , 
    .i_addr     (alu_out[9:2]) ,
    .i_Wr_Data  (operand_b   ) ,

    .o_Rd_Data  (mem_data_out)

);



// ----------------------------------------
//            MEM to REG DATA MUX 
// ----------------------------------------
mux_2x1 #(

    .DATA_WIDTH(DATA_WIDTH)

) MEM_TO_REG_MUX (
    
    .in_0 (alu_out      ),
    .in_1 (mem_data_out ),
    .i_Sel(MemtoReg     ),

    .out(MEM_TO_REG_MUX_out)

);
endmodule