`timescale 1ns / 1ps

module Program_Counter #(

    parameter DATA_WIDTH = 64

) (
    
    input   logic                        i_clk  ,
    input   logic                        i_rst_n,
    input   logic   [DATA_WIDTH - 1 : 0] i_PC    ,
    output  logic   [DATA_WIDTH - 1 : 0] o_PC_next
);

always_ff @( posedge i_clk or negedge i_rst_n ) begin 

    if (!i_rst_n) begin

        o_PC_next <= 64'b0;

    end else begin

        o_PC_next <= i_PC;
        
    end
    
end
    
endmodule