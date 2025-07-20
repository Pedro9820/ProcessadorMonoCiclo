module ProcessadorMonoCiclo(
	input wire Clock,
	input wire Reset,
	output wire[31:0] PC_out,
	output wire[31:0] MEM_out,
	output wire[31:0] ALU_out
);

// os fios vão ser divididos por estagio pra facilitar a leitura

// Estagio IF
wire [31:0] PC_next, PC_maismais;
wire [31:0] instruction;

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

// Estagio EX

wire [31:0] alu_input_2;
wire Zero_flag;

// Estagio MEM
wire [31:0] branch_address;

// Estagio WB
wire [31:0] write_data_correto;


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

assign write_reg_address = (RegDst) ? instruction[15:11]: instruction[20:16]; //multiplexador para entrada do registrador destino ou imediato
assign sign_extended = { {16{instruction[15]}}, instruction[15:0] }; // recebe a entrada de 16 bits, e faz a extensão para 32 bits, copiando para manter o sinal

// Estágio EX //

ula_ctrl ula_ctrl_componente( 
	.Func(instruction[5:0]), // os primeiros 6 bits são a operaçaõ
	.OP(alu_op_tipoR)

);

assign alu_op_correto = (ALUTipoR) ? alu_op_tipoR: ALUnaoR; // mux para ver se é operação do tipo R ou não
assign alu_input_2 = (ALUSrc) ? sign_extended: read_data_2; //mux para ver se usa outro registrador como entrada, ou extensão de bit

ula ula_componente(
	.OP(alu_op_correta),
	.ln1(read_data_1),
	.ln2(alu_input_2),
	.result(ALU_out),
	.Zero_flag(zero_flag)
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

assign branch_address = PC_maismais + (sign_extended << 2);

// estagio WB //
assign write_data_correto = (MemtoReg) ? MEM_out : ALU_out; // mux pra ver o que vai ser escrito no reg, se é da memoria ou da ULA.

wire eh_branch = Branch & Zero_flag; // só faço branch se o resultado da ula levantar a flag e se o sinal de branch estiver ligado
wire [31:0] Jump_address = { PC_maismais[31:28], instruction[25:0], 2'b00 }; // fio para enviar o endereço do salto pra o PC

wire [31:0] Decisao_branch_pc = (eh_branch) ? branch_address: PC_maismais; // se não é branch, so faz pc + 4;
assign PC_next = (Jump) ? Jump_address : Decisao_branch_pc; // se a flag de jump ta ligada, é pq a instrução é de jumpar



endmodule

