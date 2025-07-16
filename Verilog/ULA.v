// ULA recebe o controle de ULA, 2 entradas de dados, e retorna um valor calculado na saida

module ULA(
input wire [3:0] controladorULA,
input wire [31:0] dados1,
input wire [31:0] dados2,
output reg [31:0] saida,
output wire zero // usado em operações de branch equals.
);

// um switch case para cada alu op
// o * significa que qualquer mudança no valor dos fios, deve executar o switch case e fazer a operação
always @(*) begin
case (controladorULA)
	4'b0000: saida = dados1 & dados2;
	4'b0001: saida = dados1 | dados2;
	4'b0010: saida = dados1 + dados2;
	4'b0110: saida = dados1 - dados2;
	4'b0111: saida = (dados1 < dados2) ? 32'd1 : 32'd0; // set on less, se A for menor do que B, retorna 1, senão retorna 0
	default: saida = 32'b0; // retorna 0 caso não ache qual operação fazer
endcase

end

// vai ser usado no branch equals, ele compara se na operação da ULA, o resultado foi 0, assim retorna true para o branch
assign zero = (saida == 32'b0);

endmodule

