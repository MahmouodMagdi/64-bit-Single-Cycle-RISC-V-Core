`timescale 1ns / 1ps

module Sign_Extend #(

    parameter INST_WIDTH = 32

) (
    
    input   logic   [INST_WIDTH     - 1 : 0]    i_instruction,           // Sign Un-extended Instruction 
    input   logic   [1:0]                       i_ImmSrc     ,           // op_code [6:5]
    output  logic   [(INST_WIDTH*2) - 1 : 0]    o_extended               // 64-bit sign-extended field 

);

logic [11:0] selected_offset;
    


mux_3x1 #(

    .DATA_WIDTH(12)

) MUX3 (
    
    .in_1 ( i_instruction[31:20]                                                                ),
    .in_2 ({i_instruction[31:25], i_instruction[11:7]}                                          ),
    .in_3 ({i_instruction[31]   , i_instruction[7]  , i_instruction[30:25], i_instruction[11:8]}),
    .i_Sel(i_ImmSrc                                                                             ),
    .out  (selected_offset                                                                      )

);

always_comb begin 

    case (i_ImmSrc)
        
        2'b00:  begin       // I-Type Instruction  
                o_extended = { {52{selected_offset[11]}}, selected_offset };
        end 

        2'b01:  begin       // S-Type Instruction
                o_extended = { {52{selected_offset[11]}}, selected_offset };
        end 

        2'b10:  begin       // SB-Type Instruction 
                o_extended = { {52{selected_offset[11]}}, selected_offset };
        end 

        2'b11:  begin
                o_extended = 64'b0;
        end 


        default: o_extended = 64'b0;
    endcase
    
end

endmodule