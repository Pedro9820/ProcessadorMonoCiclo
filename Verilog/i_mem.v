module i_mem(
	input wire [31:0] Address,
	output wire [31:0] i_out

);

// esse modulo não faz nada além de receber o endereço, e enviar no fio de saida os dados lidos daquele endereco
reg [31:0] memoria[0:1023]; // 4kb de memoria

assign i_out = memoria[Address[11:2]]; //slice da sequencia de 32bits, para ler o endereco no vetor de memoria

endmodule 