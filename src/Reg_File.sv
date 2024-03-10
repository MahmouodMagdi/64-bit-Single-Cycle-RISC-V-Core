`timescale 1ns / 1ps

module Reg_File #(

    parameter DATA_WIDTH     = 32 ,
              Reg_File_Depth = 128,
              ADDR_WIDTH     = 5

) (
    
       input    logic                           i_clk           ,  
       input    logic                           i_rst_n         ,          
       input    logic                           i_reg_write     ,
       input    logic   [ADDR_WIDTH - 1 : 0]    i_read_reg_1    ,       
       input    logic   [ADDR_WIDTH - 1 : 0]    i_read_reg_2    ,       
       input    logic   [ADDR_WIDTH - 1 : 0]    i_write_reg     ,
       input    logic   [DATA_WIDTH - 1 : 0]    i_write_data    ,     

       output   logic   [DATA_WIDTH - 1 : 0]    o_read_data_1   ,         
       output   logic   [DATA_WIDTH - 1 : 0]    o_read_data_2        

);

    logic [DATA_WIDTH - 1 : 0] REG [Reg_File_Depth - 1 : 0];

    always_ff @( posedge i_clk or negedge i_rst_n) begin : write_operation 
        
        if(!i_rst_n) begin

            for (int i = 0; i < Reg_File_Depth ; i++ ) begin

                REG[i] <= 64'b0;

            end

        end else if (i_reg_write) begin

            REG[i_write_reg] <= i_write_data;

        end else begin

            REG <= REG;

        end

    end

assign o_read_data_1 = (i_read_reg_1 == 'b0) ? 'b0 : (REG[i_read_reg_1]);
assign o_read_data_2 = (i_read_reg_2 == 'b0) ? 'b0 : (REG[i_read_reg_2]);

endmodule