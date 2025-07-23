/*
	Arquitetura e Organização de computadores - 2025.1
	Projeto para a 2VA
	Processador MonoCiclo em verilog
	Grupo: Guilherme Oliveira Aroucha
			 Kleber Barbosa de Fraga
			 Pedro Henrique Apolinario da Silva
	Descrição do arquivo: Unidade de controle


*/

// os sinais são do tipo reg, porque somente estes podem ser alterados e repassados no fio para os outros modulos
// output wire não permite modificação do dado.
module ctrl(
	input wire [5:0] OPCode,
	output reg RegDst,
	output reg Branch,
	output reg MemRead,
	output reg MemtoReg,
	output reg MemWrite,
	output reg ALUSrc,
	output reg RegWrite,
	output reg Jump,
	output reg ALUTipoR,
	output reg [3:0] ALUnaoR
);
		// Mapeamento dos códigos da ULA para facilitar a leitura
		localparam AND_OP = 4'b0000;
		localparam OR_OP = 4'b0001;
		localparam ADD_OP = 4'b0101;
		localparam XOR_OP = 4'b0011;
		localparam NOR_OP = 4'b0100;
		localparam SUB_OP = 4'b0110;
		localparam SLTU_OP = 4'b0111;
		localparam SLT_OP = 4'b1000;
		localparam LUI_OP = 4'b1100;


always @(*) begin
		// é mais fácil colocar tudo em 0,e só mudar para 1 o que for usar na função
		RegDst = 1'b0;
		Branch = 1'b0;
		MemRead = 1'b0;
		MemtoReg = 1'b0;
		MemWrite = 1'b0;
		ALUSrc = 1'b0;
		RegWrite = 1'b0;
		Jump = 1'b0;
		ALUTipoR = 1'b0; 
		ALUnaoR = 4'bxxxx;
	
		case(OPCode)
			// ----- Operações do tipo R -----
			6'b000000: begin
				RegDst = 1'b1;
				RegWrite = 1'b1;
				ALUTipoR = 1'b1; // Controlador da ULA decodifica o que fazer pelo funct
			end
			
			// ----- Operações do tipo J -----
			6'b000010: begin // j
				Jump = 1'b1;
			end
			6'b000011: begin // jal
				RegWrite = 1'b1; 
				Jump = 1'b1;
			end
			
			// ----- Operações do tipo I ----- 
			// para essas operações, o ALUnaoR da a operação que vai ser utilizada, o ALUOp me deu problema pq somente 2 bits
			// para tantas função dava
			6'b001000: begin // addi
				RegWrite = 1'b1;
				ALUSrc = 1'b1;
				ALUnaoR = ADD_OP;
			end
			6'b001100: begin // andi
				RegWrite = 1'b1;
				ALUSrc = 1'b1;
				ALUnaoR = AND_OP;
			end
			6'b001101: begin // ori
				RegWrite = 1'b1;
				ALUSrc = 1'b1;
				ALUnaoR = OR_OP;
			end
			6'b001110: begin // xori
				RegWrite = 1'b1;
				ALUSrc = 1'b1;
				ALUnaoR = XOR_OP;
			end
			6'b001010: begin // slti
				RegWrite = 1'b1;
				ALUSrc = 1'b1;
				ALUnaoR = SLT_OP;
			end
			6'b001011: begin // sltiu
				RegWrite = 1'b1;
				ALUSrc = 1'b1;
				ALUnaoR = SLTU_OP;
			end
			6'b001111: begin // lui
				RegWrite = 1'b1;
				ALUSrc = 1'b1; 
				ALUnaoR = LUI_OP; 
			end
			6'b000100: begin // beq
				Branch = 1'b1;
				ALUnaoR = SUB_OP;
			end
			6'b000101: begin // bne
				Branch = 1'b1;
				ALUnaoR = SUB_OP; 
			end
			6'b100011: begin // lw
				MemRead = 1'b1;
				MemtoReg = 1'b1;
				ALUSrc = 1'b1;
				RegWrite = 1'b1;
				ALUnaoR = ADD_OP;
			end
			6'b101011: begin // sw
				MemWrite = 1'b1;
				ALUSrc = 1'b1;
				ALUnaoR = ADD_OP;
			end
			
			default: begin
				// Não encontrou a operação, manda um estado seguro
				RegDst = 1'bx;
				Branch = 1'bx;
				MemRead = 1'bx;
				MemtoReg = 1'bx;
				MemWrite = 1'bx;
				ALUSrc = 1'bx;
				RegWrite = 1'bx;
				Jump = 1'bx;
				ALUTipoR = 1'bx;
				ALUnaoR = 4'bxxxx;
			end
		endcase
	end


endmodule