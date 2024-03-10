`timescale 1ns / 1ps

module mux_2x1 #(

    parameter DATA_WIDTH = 12

) (
    
    input   logic   [DATA_WIDTH - 1 : 0] in_0 ,
    input   logic   [DATA_WIDTH - 1 : 0] in_1 ,
    input   logic                        i_Sel,

    output  logic   [DATA_WIDTH - 1 : 0] out

);


always_comb begin
    
    case (i_Sel)

        1'b0 :begin
            out = in_0;
        end

        1'b1 :begin
            out = in_1;
        end

        default: out = 'b0;
    endcase
    
end
endmodule