//shift left 

module Shift_Left(endereco_Entrada, endereco_Final);

input wire [31:0] endereco_Entrada; // endereço de entrada para o shift
output wire [31:0] endereco_Final; // endedreço com o shift left

assign endereco_Final = endereco_Entrada << 2; //desaloca 2 bits para a esquerda

endmodule
 