
/*
	Arquitetura e Organização de computadores - 2025.1
	Projeto para a 2VA
	Processador MonoCiclo em verilog
	Grupo: Guilherme Oliveira Aroucha
			 Kleber Barbosa de Fraga
			 Pedro Henrique Apolinario da Silva
	Descrição do arquivo: Modulo Unidade de logica aritmetica

*/
// ULA recebe o controle de ULA, 2 entradas de dados, e retorna um valor calculado na saida

module ula(
input wire [3:0] OP,
input wire [31:0] ln1,
input wire [31:0] ln2,
output reg [31:0] result,
output wire Zero_flag // usado em operações de branch equals.
);
// sll ta me dando problema
wire signed [31:0] s_ln1 = ln1;
wire signed [31:0] s_ln2 = ln2;

// um switch case para cada alu op
// o * significa que qualquer mudança no valor dos fios, deve executar o switch case e fazer a operação
always @(*) begin
case (OP)
	// -----Operações Lógicas-----
	
	4'b0000: result = ln1 & ln2; 		// AND
	4'b0001: result = ln1 | ln2; 		// OR
	4'b0011: result = ln1 ^ ln2; 		// XOR
	4'b0100: result = ~(ln1 | ln2);  // NOR
	
	// -----Operações Arimeticas-----
	4'b0101: result = ln1 + ln2; 		// SOMA
	4'b0110: result = ln1 - ln2; 		// SUBTRAÇÃO
	
	// -----Operações de Comparação-----
	4'b0111: result = (ln1 < ln2) ? 32'd1 : 32'd0;				// SLTU
	4'b1000: result = (s_ln1 < s_ln2) ? 32'd1 : 32'd0;   // SLT
	
	// -----Operações de Shift-----
	4'b1001: result = ln2 << ln1[4:0]; 					// SLLV 
	4'b1010: result = ln1 >> ln2[4:0]; 					// SRL
	4'b1011: result = s_ln2 >>> ln1[4:0];					// SRAV e SRA
	4'b1100: result = ln1 << 16; 						//lui
	
	default: result = 32'b0; // retorna 0 caso não ache qual operação fazer
endcase

end

// vai ser usado no branch equals, ele compara se na operação da ULA, o resultado foi 0, assim retorna true para o branch
assign Zero_flag = (result == 32'b0);

endmodule

