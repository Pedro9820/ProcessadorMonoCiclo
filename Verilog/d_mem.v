
module d_mem (
	Clock,
	Address,
	WriteData,
	MemWrite,
	MemRead,
	ReadData
);
	// parametros para criação da memoria
	parameter tamanho = 32; // entrada de bits do mips
	parameter enderecamento = 10; // enderecamento de palavra de 4 bits

	// Declaração das portas
	input wire Clock;
	input wire [tamanho - 1:0] Address;
	input wire [tamanho - 1:0] WriteData;
	input wire MemWrite;
	input wire MemRead;
	output reg [tamanho - 1:0] ReadData;
	localparam tamanhoVetor = 1 << enderecamento; // tamanho do vetor é calculado com 2 ^ enderecamento
	
	//primeiro inicializar a memoria do sistema em um vetor
	reg [tamanho - 1:0] memoria[0:tamanhoVetor - 1]; // tamanho de memoria parametrizavel
	
	// Primeira etapa, ver se a função é descrita
	// Se a flag de ler ta em 0, então é porque é pra escrever dados
	// a leitura é sincronizada com o clock
	always @(posedge Clock) begin
	if(MemWrite) begin
	// fazemos uma fatia nos bits de endereço, porque em multiplos de 4, os 2 primeiros bits sempre são 0
	// 4 = 0100, 8 = 1000, 12 = 1100, 16 = 1 0000 ...
	// além disso, como em Assembly Mips, cada palavra é composta de 4 bytes
	// Podemos já dividir o valor de endereço por 4
	memoria[Address[enderecamento + 1:2]] <= WriteData; // <= significa que a atribuição é feita em paralelo, onde empilha cada uma
	end											// e executa todas de uma vez
	if (MemRead) begin
		ReadData <= memoria[Address[enderecamento + 1:2]];
	end
	end
	


	
	
endmodule