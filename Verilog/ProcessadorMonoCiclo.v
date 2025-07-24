/*
	Arquitetura e Organização de computadores - 2025.1
	Projeto para a 2VA
	Processador MonoCiclo em verilog
	Grupo: Guilherme Oliveira Aroucha
			 Kleber Barbosa de Fraga
			 Pedro Henrique Apolinario da Silva
	Descrição do arquivo: Nucleo do Processador que conecta todos os modulos separados


*/


// nucleo do sistema que conecta todos os modulos e faz todas as saidas e entradas de fios
module ProcessadorMonoCiclo(
	input wire Clock,
	input wire Reset,
	output wire[31:0] PC_out,
	output wire[31:0] MEM_out,
	output wire[31:0] ALU_out,
	// debug
	output wire [31:0] debug_ln1,
	output wire [31:0] debug_ln2,
	output wire [3:0] debug_alu_op,
	output wire [31:0] debug_write_data,
	output wire [4:0] debug_write_reg,
	output wire [31:0] debug_mem_write_data

);

// os fios vão ser divididos por estagio pra facilitar a leitura

// Estagio IF
wire [31:0] PC_next, PC_maismais; // essa linguagem arcaica não tem PC++ ou PC += 4
wire [31:0] instruction;
wire jr = (instruction[31:26] == 6'b000000) && (instruction[5:0] == 6'b001000); // caso seja uma função de jr

// sinais de controle
wire RegDst, Branch, MemRead, MemtoReg, MemWrite, Jump, ALUSrc, RegWrite, ALUTipoR;
wire [3:0] ALUnaoR;

// Estagio ID

wire[31:0] read_data_1, read_data_2;
wire [31:0] sign_extended;
wire [4:0] write_reg_address;

// Sinais de controla da ula
wire [3:0] alu_op_tipoR;
wire [3:0] alu_op_correta;
wire [31:0] valor_shiftado_entrada;
wire usa_shamt; 

// Estagio EX

wire [31:0] alu_input_2;
wire Zero_flag;

// Estagio MEM
wire [31:0] branch_address;

// Estagio WB
wire [31:0] write_data_correto;

// Continuação do PC
wire eh_branch;
wire [31:0] Jump_address;
wire [31:0] Decisao_branch_pc;


// ---Conexão dos cabos de um modulo pra outro, parte chata do caramba--- //

// Estágio IF //

PC pc_componente(
	.clock(Clock),
	.nextPC(PC_next),
	.PC(PC_out)
	
);
assign PC_maismais = PC_out + 32'd4; // pc += 4

i_mem i_mem_componente(
	.Address(PC_out),
	.i_out(instruction)
);

// fazer a fiação igual o desenho e ter fé que não vai bugar

// Estágio ID //

ctrl control_componente (
	.OPCode(instruction[31:26]), // slice da sequencia binário para entrar só o opcode
	.RegDst(RegDst),
	.Branch(Branch),
	.MemRead(MemRead),
	.MemtoReg(MemtoReg),
	.MemWrite(MemWrite),
	.ALUSrc(ALUSrc),
	.RegWrite(RegWrite),
	.Jump(Jump),
	.ALUTipoR(ALUTipoR),
	.ALUnaoR(ALUnaoR)
);

regfile regfile_componente (
	.Clock(Clock),
	.Reset(Reset),
	.RegWrite(RegWrite),
	.ReadAddr1(instruction[25:21]),
	.ReadAddr2(instruction[20:16]),
	.WriteAddr(write_reg_address),
	.WriteData(write_data_correto),
	.ReadData1(read_data_1),
	.ReadData2(read_data_2)
);

// Registrador de destino (rd para tipo R, rt para tipo I, reg 31 para JAL)
assign write_reg_address = (Jump && instruction[31:26] == 6'b000011) ? 5'd31 :
                           (RegDst) ? instruction[15:11] :
                           instruction[20:16];

assign sign_extended = { {16{instruction[15]}}, instruction[15:0] }; // recebe a entrada de 16 bits, e faz a extensão para 32 bits, copiando para manter o sinal

// Estágio EX //

ula_ctrl ula_ctrl_componente( 
	.Func(instruction[5:0]), // os primeiros 6 bits são a operaçaõ
	.OP(alu_op_tipoR)

);

// pega o bizu, ele vê se é uma operação do tipo R, se for, ele só passa ela pra ula ctrl e lá resolve oq fazer
// se não for do tipo R, ele ele diz que vai usar o imediato, e diz qual operação é, ja que tipo I e J não tem campo funct
// e tem o usa_shamt pra ver se vai usar o campo de shamt, principal pro SLL que quebrou as pernas do processador
assign alu_op_correta = (ALUTipoR) ? alu_op_tipoR: ALUnaoR; // mux para ver se é operação do tipo R ou não
assign alu_input_2 = (ALUSrc) ? sign_extended: read_data_2; //mux para ver se usa outro registrador como entrada, ou extensão de bit
assign usa_shamt = (alu_op_correta == 4'b1001 && instruction[5:0] == 6'b000000) || 
                   (alu_op_correta == 4'b1011 && instruction[5:0] == 6'b000011); // SRA
																												// SLL, odeio essa operação, ta bugando tudo
assign valor_shiftado_entrada = (usa_shamt) ? {27'b0, instruction[10:6]} : read_data_1;


ula ula_componente(
	.OP(alu_op_correta),
	.ln1(valor_shiftado_entrada),
	.ln2(alu_input_2),
	.result(ALU_out),
	.Zero_flag(Zero_flag)
);

// estágio MEM //

d_mem d_mem_componente (
	.Clock(Clock),
	.Address(ALU_out),
	.WriteData(read_data_2),
	.MemWrite(MemWrite),
	.MemRead(MemRead),
	.ReadData(MEM_out)
);
// já calcula um possivel branch
assign branch_address = PC_maismais + (sign_extended << 2);

// estagio WB //
// Dados a serem escritos no registrador (vindo da memória, da ULA, ou PC+4 no caso de JAL)
assign write_data_correto = (Jump && instruction[31:26] == 6'b000011) ? PC_maismais :
                            (MemtoReg) ? MEM_out :
                            ALU_out;


// salto ou avanço do pc
assign eh_branch = (instruction[31:26] == 6'b000100) ? (Branch & Zero_flag) : // beq
                   (instruction[31:26] == 6'b000101) ? (Branch & ~Zero_flag) : // bne
                   1'b0;

						 // vai usar o sinal de branch e ao mesmo tempo já vai calculando o possivel salto, se for confirmado, ele ja usa o salto, se não só ignora
assign Jump_address = { PC_maismais[31:28], instruction[25:0], 2'b00 }; // fio para enviar o endereço do salto pra o PC
assign Decisao_branch_pc = (eh_branch) ? branch_address: PC_maismais; // se não é branch, so faz pc + 4;
assign PC_next = (jr) ? read_data_1 : // se a flag de jump ta ligada, é pq a instrução é de jumpar
                 (Jump) ? Jump_address :
                 Decisao_branch_pc;



//debug pro  teste bench

assign debug_ln1 = read_data_1;
assign debug_ln2 = alu_input_2;
assign debug_alu_op = alu_op_correta;

assign debug_write_data = write_data_correto; // Saída que vai para WriteData do regfile
assign debug_write_reg = write_reg_address;  // Registrador de destino
assign debug_mem_write_data = read_data_2; // o write_data_correto acabou não sendo o correto no debug ironicamente



endmodule

