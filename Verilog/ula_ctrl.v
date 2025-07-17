module ula_ctrl(
	input wire [1:0] ALUOp,
	input wire [5:0] Func,
	output reg [3:0] OP
);
		
	// variaveis para facilitar a leitura desse switch case gigante
	 localparam AND_OP = 4'b0000;
    localparam OR_OP = 4'b0001;
    localparam ADD_OP = 4'b0010;
    localparam XOR_OP = 4'b0011;
    localparam NOR_OP = 4'b0100;
    localparam SUB_OP = 4'b0110;
    localparam SLTU_OP = 4'b0111;
    localparam SLT_OP = 4'b1000;
    localparam SLL_OP = 4'b1001;
    localparam SRL_OP = 4'b1010;
    localparam SRA_OP = 4'b1011;

	// qualquer mudança no estado de um fio de entrada, ele vai pra esse bloco de loop
	always @(*) begin
		
		
		case (ALUOp)
		2'b00: OP = ADD_OP; // load word / store word --> add
		2'b01: OP = SUB_OP; // branch equal --> sub
		2'b10: begin // as instruções a seguir possuem o mesmo valor ALUOp, então se diferenciam pelo campo Func
						case(Func)
						6'b000000: OP = SLL_OP; // tipo r --> sll
						6'b000010: OP = SRL_OP; // tipo r --> srl
						6'b000011: OP = SRA_OP; // tipo r --> sra
						6'b000100: OP = SLL_OP; // mesma operação do outro de cima, a diferença é a entrada do 2 operando no mux
						6'b000110: OP = SRL_OP; // igual o anterior
						6'b000111: OP = SRA_OP; // mesma coisa
						6'b100000: OP = ADD_OP; // tipo r --> add
						6'b100010: OP = SUB_OP; // tipo r --> sub
						6'b100100: OP = AND_OP; // tipo r --> and
						6'b100101: OP = OR_OP; // tipo r --> or
						6'b100110: OP = XOR_OP; //tipo r --> xor
						6'b100111: OP = NOR_OP; // tipo r --> nor
						6'b101010: OP = SLT_OP; // tipo r --> slt
						6'b101011: OP = SLTU_OP; //tipo r --> sltu
						default: OP = 4'bxxxx; // não esta ligado a nenhuma operaçao
						endcase
					end
			
			
		default: OP = 4'bxxxx; // não esta ligado a nenhuma operação
		endcase
		

	end

endmodule

