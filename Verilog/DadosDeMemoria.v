
module DadosDeMemoria(
	input wire Clock,
	input wire [31:0] Endereco,
	input wire [31:0] DadosEscrita,
	input wire MemWrite,
	input wire MemRead,
	output wire [31:0] DadosLidos
);
	
	//primeiro inicializar a memoria do sistema em um vetor
	reg [31:0] memoria[0:1023]; // equivale a 4kb de memoria, 1024 * 32 bits
	
	// Primeira etapa, ver se a função é descrita
	// Se a flag de ler ta em 0, então é porque é pra escrever dados
	// a leitura é sincronizada com o clock
	always @(posedge Clock) begin
	if(MemWrite) begin
	// fazemos uma fatia nos bits de endereço, porque em multiplos de 4, os 2 primeiros bits sempre são 0
	// 4 = 0100, 8 = 1000, 12 = 1100, 16 = 1 0000 ...
	// além disso, como em Assembly Mips, cada palavra é composta de 4 bytes
	// Podemos já dividir o valor de endereço por 4
	memoria[Endereco[11:2]] <= DadosEscrita; // <= significa que a atribuição é feita em paralelo, onde empilha cada uma
	end											// e executa todas de uma vez
	end
	
	//Segunda etapa, é verificar a flag de leitura e então ler
	// mux simples para leitura de dados
	// é lógica combinacional com leitura imediata e não sincrona
	assign DadosLidos = (MemRead)? memoria[Endereco[11:2]] : 32'bz; // vi que bz significa estado desligado se não esta lendo dados
	
	
endmodule