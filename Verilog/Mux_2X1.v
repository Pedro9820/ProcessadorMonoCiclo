module Mux_2X1(input1, input2, seletor, out);

input wire [31:0] input1;// entrada 1 do multiplexador
input wire [31:0] input2;// entrada 2 do multiplexador
input wire seletor;

output wire [31:0] out; // saida do multiplexador

assign out  = seletor? input2 : input1; //se seletor for: 1 -> out = input2 ; 0 -> out = input1


endmodule

