`timescale 1ns / 1ps

module mux_3x1 #(

    parameter DATA_WIDTH = 12

) (
    
    input   logic   [DATA_WIDTH - 1 : 0] in_1,
    input   logic   [DATA_WIDTH - 1 : 0] in_2,
    input   logic   [DATA_WIDTH - 1 : 0] in_3,
    input   logic                  [1:0] i_Sel,
    output  logic   [DATA_WIDTH - 1 : 0] out

);


always_comb begin
    
    case (i_Sel)

        2'b00 :begin
            out = in_1;
        end

        2'b01 :begin
            out = in_2;
        end

        2'b10 :begin
            out = in_3;
        end

        2'b11 :begin
            out = 'b0;
        end 

        default: out = 'b0;
    endcase
    
end
endmodule