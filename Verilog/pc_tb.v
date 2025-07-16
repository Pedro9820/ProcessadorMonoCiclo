`timescale 1ns/1ps

module pc_tb;
	// sinais de controle para visualizar a mudança de clock e reset
	reg clk;
	reg rst;
	reg [31:0] proximo_Pc;
	
	wire [31:0] atual_Pc;



// bancada de testes para o modulo PC
// uut é conveção.
pc uut(
// conexão dos fios do PC com os fios de teste
.clk(clk),
.rst(rst),
.proximo_Pc(proximo_Pc),
.atual_Pc(atual_Pc)
);

// iniciando um clock básico para entrada no PC
initial begin
	clk = 0;
	forever #5 clk = ~clk; // fica rodando e invertendo o pulso de clock a cada 5 ns
end

initial begin
// primeiro passo, reiniciar o PC com o rst
rst = 1;
proximo_Pc = 32'hAAAAAAAA;
#15; // #X significa quantos nano segundos ira esperar

//testar o pulso de clock agora
rst = 0;
proximo_Pc = 32'h00000004; // Pc inicia em 0 e recebe + 4
#10;

proximo_Pc = 32'h00000008; // Pc + 4
#10;

$stop; // para simulação

end

endmodule
