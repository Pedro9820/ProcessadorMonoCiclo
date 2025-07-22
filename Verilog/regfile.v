// recebe o clock para sempre ir lendo novos dados na mudança de clock
// recebe o comando de controle para escrever ou não
// recebe as entradas de registradore de leitura ou escrita, e sai somente os dados lidos
module regfile(
	input wire Clock,
	input wire Reset,
	input wire RegWrite,
	input wire [4:0] ReadAddr1,
	input wire [4:0] ReadAddr2,
	input wire [4:0] WriteAddr,
	input wire [31:0] WriteData,
	output wire [31:0] ReadData1,
	output wire [31:0] ReadData2
);
// não dá pra iniciar variavel dentro de um bloco begin nessa linguagem arcaica
integer i;
// os 32 registradores do mips em um vetor
reg [31:0] registradores[0:31];

// lógica de escrita
// acontece após a queda do clock.
always @(posedge Clock or posedge Reset) begin
// se é reset, coloca todos os registradores com valor 0,
	if(Reset) begin
	for(i = 0; i < 32; i = i + 1) begin // não existe i++ nessa linguagem de dinossauros
	registradores[i] <= 32'b0;
	end
end else begin // se não é pra resetar, faz a escrita normalmente
// Não se pode sobscrever o que esta escrito no registrador 0.
	if (RegWrite && WriteAddr !== 5'b0 && WriteAddr !== 5'bx) begin
	registradores[WriteAddr] <= WriteData;
	end
end

end

// lógica de leitura
// ela acontece o tempo todo, independente do clock
// só passar os dados dos registradores de leitura, para o de saida
// e verificar se o de leitura é o 0, porque dai é simplesmente retornar 0.
assign ReadData1 = (ReadAddr1 == 5'b0) ? 32'b0 : registradores[ReadAddr1];
assign ReadData2 = (ReadAddr2 == 5'b0) ? 32'b0 : registradores[ReadAddr2];



endmodule
