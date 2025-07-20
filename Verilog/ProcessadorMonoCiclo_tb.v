// mips_core_tb.v
// Bancada de testes para o processador MIPS completo.
`timescale 1ns/1ps

module ProcessadorMonoCiclo_tb;

    // Sinais para conectar ao processador
    reg clock_tb;
    reg reset_tb;
    
    // Fios para observar as saídas do processador
    wire [31:0] pc_out_tb;
    wire [31:0] alu_out_tb;
    wire [31:0] mem_out_tb;

    // Instanciação do processador MIPS completo (Unidade Sob Teste)
    ProcessadorMonoCiclo uut (
        .Clock(clock_tb),
        .Reset(reset_tb),
        .PC_out(pc_out_tb),
        .ALU_out(alu_out_tb),
        .MEM_out(mem_out_tb)
    );

    // Geração do sinal de clock
    initial begin
        clock_tb = 0;
        forever #5 clock_tb = ~clock_tb; // Período do clock de 10ns
    end

    // Roteiro de Testes: Apenas inicia e reseta o processador
    initial begin
        $display("------ INICIO DA SIMULACAO DO PROCESSADOR MIPS ------");

        // Pulsa o reset no início para limpar os registradores
        reset_tb = 1;
        #15;
        reset_tb = 0;
        
        // Deixa a simulação rodar por um tempo para executar o programa
        #300;
        
        $display("------ FIM DA SIMULACAO ------");
        $finish;
    end

endmodule