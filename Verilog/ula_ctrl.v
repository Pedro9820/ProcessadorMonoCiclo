
/*
	Arquitetura e Organização de computadores - 2025.1
	Projeto para a 2VA
	Processador MonoCiclo em verilog
	Grupo: Guilherme Oliveira Aroucha
			 Kleber Barbosa de Fraga
			 Pedro Henrique Apolinario da Silva
	Descrição do arquivo: Modulo controlador da ULA


*/

// controlador da ula adaptado, os poucos bits opcode originalmente usados aqui não cabiam os zilhões de funções
// então deixei o ula control mais burro e só lê o campo funct e mais nada
module ula_ctrl(
	input wire [5:0] Func,      
	output reg [3:0] OP         
);
		
	// facilita a leitura pra não ter que abrir o arquivo da ula e ver o código de cada função
	localparam AND_OP = 4'b0000;
	localparam OR_OP = 4'b0001;
	localparam ADD_OP = 4'b0101;
	localparam XOR_OP = 4'b0011;
	localparam NOR_OP = 4'b0100;
	localparam SUB_OP = 4'b0110;
	localparam SLTU_OP = 4'b0111;
	localparam SLT_OP = 4'b1000;
	localparam SLL_OP = 4'b1001;
	localparam SRL_OP = 4'b1010;
	localparam SRA_OP = 4'b1011;

	always @(*) begin
		// Decodifica o campo 'Func' para determinar a operação da ULA
		case(Func)
			
			6'b100000: OP = ADD_OP;  // add
			6'b100010: OP = SUB_OP;  // sub
			6'b100100: OP = AND_OP;  // and
			6'b100101: OP = OR_OP;   // or
			6'b100110: OP = XOR_OP;  // xor
			6'b100111: OP = NOR_OP;  // nor
			6'b101010: OP = SLT_OP;  // slt
			6'b101011: OP = SLTU_OP; // sltu
			6'b000000: OP = SLL_OP;  // sll
			6'b000010: OP = SRL_OP;  // srl
			6'b000011: OP = SRA_OP;  // sra
			6'b000100: OP = SLL_OP;  // sllv
			6'b000110: OP = SRL_OP;  // srlv
			6'b000111: OP = SRA_OP;  // srav
			
			default:   OP = 4'bxxxx; // Funct não suportado
		endcase
	end

endmodule