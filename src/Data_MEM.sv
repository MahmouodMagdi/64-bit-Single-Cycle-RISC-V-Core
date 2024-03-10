`timescale 1ns / 1ps

module Data_MEM #(

    parameter DATA_WIDTH = 64,
              ADDR_WIDTH = 8,
              MEM_DEPTH  = 128

) (
    
    input   logic                           i_clk       ,
    input   logic                           i_rst_n     ,
    input   logic                           i_Mem_Write ,
    input   logic                           i_Mem_Read  , 
    input   logic   [ADDR_WIDTH - 1 : 0]    i_addr      ,
    input   logic   [DATA_WIDTH - 1 : 0]    i_Wr_Data   ,

    output  logic   [DATA_WIDTH - 1 : 0]    o_Rd_Data  

);
    
    logic [DATA_WIDTH - 1 : 0] data_memory [MEM_DEPTH - 1 : 0];                // 128-location data memory each of 64 bits 

    always_ff @( posedge i_clk or negedge i_rst_n ) begin 

        if (!i_rst_n) begin

            for (int i = 0; i < MEM_DEPTH ; i++ ) begin

                data_memory[i] <= 64'b0;
                o_Rd_Data      <= 'b0;
                
            end
        
        end else begin

            if (i_Mem_Write) begin
                
                data_memory[i_addr] <= i_Wr_Data;
            
            end else if(i_Mem_Read) begin

                o_Rd_Data <= data_memory[i_addr];

            end   

        end
        
    end 
endmodule