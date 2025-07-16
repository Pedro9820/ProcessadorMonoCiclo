
// bancada de testes para a ULA
`timescale 1ns/1ps
// lembrar que tb não recebe reg ou wire na declaração do modulo 
module ULA_tb;
	reg [3:0] controladorULA_tb;
	reg [31:0] dados1_tb;
	reg [31:0] dados2_tb;
	wire [31:0] saida_tb;
	wire zero_tb;

// conexão dos reg com os fios da ULA para bancada de testes
ULA uut(
.controladorULA(controladorULA_tb),
.dados1(dados1_tb),
.dados2(dados2_tb),
.saida(saida_tb),
.zero(zero_tb)
);

initial begin

$dumpfile("ondaULA.vcd");
$dumpvars(0, ULA_tb);

#10; // aguarda 10 ns

// teste de soma
controladorULA_tb = 4'b0010;
dados1_tb = 32'd10;
dados2_tb = 32'd15; 
#10;

// teste de subtração
controladorULA_tb = 4'b0110;
dados1_tb = 32'd20;
dados2_tb = 32'd5; 
#10;

// teste de set on less
controladorULA_tb = 4'b0111;
dados1_tb = 32'd10;
dados2_tb = 32'd15; 
#10;

// teste de and
controladorULA_tb = 4'b0000;
dados1_tb = 32'b0000_0000_0000_0000_0000_0010_0000_1100;
dados2_tb = 32'b0000_0000_0000_0000_0000_0000_0100_1100; 
#10;

// teste de ou
controladorULA_tb = 4'b0001;
dados1_tb = 32'b0000_0000_0000_0000_0000_0010_0000_1100;
dados2_tb = 32'b0000_0000_0000_0000_0000_0000_0100_1100; 
#10;

$finish;

end

endmodule
