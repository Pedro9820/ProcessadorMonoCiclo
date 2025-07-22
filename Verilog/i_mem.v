module i_mem(
	Address,
	i_out
);

	// parametros para criação da memoria
	parameter tamanho = 32; // entrada de bits do mips
	parameter enderecamento = 10; // enderecamento de palavra de 4 bits
	localparam tamanhoVetor = 1 << enderecamento; // tamanho do vetor é calculado com 2 ^ enderecamento
	
	input wire [tamanho - 1:0] Address;
	output wire [tamanho - 1:0] i_out;
	
	//inicializa o vetor de memoria com as instruções binárias que vai ler do arquivo
	reg [31:0] memoria [0: 63];
	
	// leitura do arquivo de teste instruction.list
	initial begin
		//$display("[%0t] i_mem: Tentando ler o arquivo C:/MIPS/instructions.list...", $time);
		// lê o valor binário desse arquivo
		$readmemb("C:/MIPS/instructions.list", memoria);
		
		//$display("[%0t] i_mem: Leitura do arquivo concluida.", $time);
	end
	
assign i_out = memoria[Address[enderecamento + 1 :2]]; //slice da sequencia de 32bits, para ler o endereco no vetor de memoria

endmodule 