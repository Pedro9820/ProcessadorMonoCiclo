module DadosDeMemoria_tb;
	// variaveis que serviram de entrada para os testes
	reg Clock_tb;
	reg [31:0] Endereco_tb;
	reg [31:0] DadosEscrita_tb;
	reg MemWrite_tb;
	reg MemRead_tb;
	wire [31:0] DadosLidos_tb;

	// conecta os nosso reg de teste com as entradas do circuito de MemoryData
DadosDeMemoria uut(
.Clock(Clock_tb),
.Endereco(Endereco_tb),
.DadosEscrita(DadosEscrita_tb),
.MemWrite(MemWrite_tb),
.MemRead(MemRead_tb),
.DadosLidos(DadosLidos_tb)
);

// inicializando o clock para ficar ciclando infinitamente
initial begin
Clock_tb = 0;
forever #5 Clock_tb = ~Clock_tb; // a cada 5 ns o clock se inverte
end


	// Roteiro de testes
	initial begin
		// 1. Inicializa todos os sinais para um estado conhecido e seguro.
		$display("[%0t] INICIO: Inicializando sinais.", $time);
		Endereco_tb = 32'd0;
		DadosEscrita_tb = 32'd0;
		MemWrite_tb = 0;
		MemRead_tb = 0;
		
		@(posedge Clock_tb); // Espera a primeira borda do clock para sincronizar.

		// 2. TESTE DE ESCRITA: Escrever o valor 24 no endereço 8.
		$display("[%0t] ACAO: Preparando para escrever 24 no endereco 8...", $time);
		// coloca os dados que eu quero para a escrita
		MemWrite_tb = 1;
		Endereco_tb = 32'd8;      // Endereço de byte 8
		DadosEscrita_tb = 32'd24;     // Dado a ser escrito

		@(posedge Clock_tb); // ESPERA O CLOCK. A escrita acontece neste instante!
		
		// desligar o memwrite
		$display("[%0t] ACAO: Escrita concluida. Desligando MemWrite.", $time);
		MemWrite_tb = 0;
		
		#1;

		// 3. TESTE DE LEITURA: Ler o valor do endereço 8.
		@(posedge Clock_tb); // Espera mais um clock para separar as operações
		$display("[%0t] ACAO: Preparando para ler do endereco 8...", $time);
		// PREPARA a leitura
		MemRead_tb = 1;
		Endereco_tb = 32'd8; // Aponta para o endereço que queremos ler

		#1; // Esperar 1ns para os sinais se propagarem

		// VERIFICA a saída
		$display("[%0t] VERIFICACAO: Lido do endereco %d o valor: %d (esperado: 24)",$time, Endereco_tb, DadosLidos_tb);
		
		@(posedge Clock_tb);

		// Limpa os sinais de leitura
		MemRead_tb = 0;

		#10;
		$finish;
		end

endmodule