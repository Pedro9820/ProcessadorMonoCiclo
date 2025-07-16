// bancada de testes para o banco de registrador
// testar a leitura e escrita de dados
module BancoRegistradores_tb;
	 reg Clock_tb;
	 reg regWrite_tb;
	 reg [4:0] regLeitura1_tb;
	 reg [4:0] regLeitura2_tb;
	 reg[4:0] regEscrita_tb;
	 reg [31:0] DadosEscrita_tb;
	 wire [31:0] DadosLeitura1_tb;
	 wire [31:0] DadosLeitura2_tb;

	 // conectando as entradas e saidas com a da bancada de teste
BancoRegistradores uut(
.Clock(Clock_tb),
.regWrite(regWrite_tb),
.regLeitura1(reg_Leitura1_tb),
.regLeitura2(reg_Leitura2_tb),
.regEscrita(regEscrita_tb),
.DadosEscrita(DadosEscrita_tb),
.DadosLeitura1(DadosLeitura1_tb),
.DadosLeitura2(DadosLeitura2_tb)
);

initial begin
Clock_tb = 0;
forever #5 Clock_tb = ~Clock_tb; // a cada 5 ns o clock se inverte
end


initial begin
// inicializa todo os registradores e dados como 0.
regWrite_tb = 0;
regEscrita_tb = 5'b0;
DadosEscrita_tb = 32'b0;
regLeitura1_tb = 5'b0;
regLeitura2_tb = 5'b0;


@(posedge Clock_tb);// aguarda o ciclo de clock
$display("Teste 1: Escrevendo 192 em R5");

regWrite_tb = 1;
regEscrita_tb = 5'd5;
DadosEscrita_tb = 32'd192;

#10;
@(posedge Clock_tb);
regWrite_tb = 0; //desliga o regwrite

#10;
@(posedge Clock_tb);
$display("Teste 2: Lendo 192 em R5");
regLeitura1_tb = 5'd5;
regLeitura2_tb = 5'd0;

#1;
$display("Teste 2 Valor Lido: %d", DadosLeitura1_tb);

@(posedge Clock_tb);
regWrite_tb = 1;
@(posedge Clock_tb);

#10;

$display("Teste 3: Escrevendo 999 em R0");
regEscrita_tb = 5'd0;
DadosEscrita_tb = 32'd999;

@(posedge Clock_tb);
regWrite_tb = 0;

#10;
@(posedge Clock_tb);
$display("Teste 4: Lendo 0 em R0");
regLeitura1_tb = 5'd5;
regLeitura2_tb = 5'd0;

#1;
$display("Teste 4 Valor Lido: %d", DadosLeitura1_tb);
#10;
@(posedge Clock_tb);

$finish;
end


endmodule