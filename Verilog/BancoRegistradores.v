// recebe o clock para sempre ir lendo novos dados na mudança de clock
// recebe o comando de controle para escrever ou não
// recebe as entradas de registradore de leitura ou escrita, e sai somente os dados lidos
module BancoRegistradores(
	input wire Clock,
	input wire regWrite,
	input wire [4:0] regLeitura1,
	input wire [4:0] regLeitura2,
	input wire [4:0] regEscrita,
	input wire [31:0] DadosEscrita,
	output wire [31:0] DadosLeitura1,
	output wire [31:0] DadosLeitura2
);

// os 32 registradores do mips em um vetor
reg [31:0] registradores[0:31];

// lógica de escrita
// acontece após a queda do clock.
always @(posedge Clock) begin
// Não se pode sobscrever o que esta escrito no registrador 0.
if(regWrite && (regEscrita != 5'b0)) begin
registradores[regEscrita] <= DadosEscrita;
end
end

// lógica de leitura
// ela acontece o tempo todo, independente do clock
// só passar os dados dos registradores de leitura, para o de saida
// e verificar se o de leitura é o 0, porque dai é simplesmente retornar 0.
assign DadosLeitura1 = (regLeitura1 == 5'b0) ? 32'b0 : registradores[regLeitura1];
assign DadosLeitura2 = (regLeitura2 == 5'b0) ? 32'b0 : registradores[regLeitura2];



endmodule
