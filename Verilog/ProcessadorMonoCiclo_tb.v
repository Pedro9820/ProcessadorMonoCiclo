/*
	Arquitetura e Organização de computadores - 2025.1
	Projeto para a 2VA
	Processador MonoCiclo em verilog
	Grupo: Guilherme Oliveira Aroucha
			 Kleber Barbosa de Fraga
			 Pedro Henrique Apolinario da Silva
	Descrição do arquivo: Bancada de testes para o processador completo


*/

`timescale 1ns/1ps

module ProcessadorMonoCiclo_tb;
	
    reg clock_tb;
    reg reset_tb;
    wire [31:0] pc_out_tb;
    wire [31:0] alu_out_tb;
    wire [31:0] mem_out_tb;
    wire [31:0] debug_ln1_tb, debug_ln2_tb, debug_write_data_tb;
    wire [3:0] debug_alu_op_tb;
    wire [4:0] debug_write_reg_tb;
	 wire [31:0] debug_mem_write_data_tb;

    reg [31:0] mem_out_atrasado_tb;  // o clock tava deixando meio doido o mem out, ai vai ter uma cópia dele com um delay pra garantir que a leitura certa

    // Instancia o processador
	 // usa os fios de debug lá do main
    ProcessadorMonoCiclo uut (
        .Clock(clock_tb),
        .Reset(reset_tb),
        .PC_out(pc_out_tb),
        .ALU_out(alu_out_tb),
        .MEM_out(mem_out_tb),
        .debug_ln1(debug_ln1_tb),
        .debug_ln2(debug_ln2_tb),
        .debug_alu_op(debug_alu_op_tb),
        .debug_write_data(debug_write_data_tb),
        .debug_write_reg(debug_write_reg_tb),
		  .debug_mem_write_data(debug_mem_write_data_tb)
    );

    // Clock 10ns
    initial begin
        clock_tb = 0;
        forever #5 clock_tb = ~clock_tb;
    end

    // Atraso de 1 ciclo no mem_out
    always @(posedge clock_tb) begin
        mem_out_atrasado_tb <= mem_out_tb;
    end

    // Monitor que exibe a cada ciclo de clock
always @(posedge clock_tb) begin
    // Adicionado para não imprimir durante ou logo após o reset
    if (reset_tb == 1'b0) begin 
        if (debug_write_reg_tb == 5'b0) begin
            // Usa $display para imprimir a mensagem condicional
            $display("[%0t] PC=%h, ALU_Result=%h, MEM_Out=%h | ln1=%h, ln2=%h, alu_op=%b | WR: Tentativa de escrita no reg 0 | MEM_WR=%h",
                $time, pc_out_tb, alu_out_tb, mem_out_atrasado_tb,
                debug_ln1_tb, debug_ln2_tb, debug_alu_op_tb,
                debug_mem_write_data_tb);
        end else begin
            // Usa $display para imprimir a mensagem normal
            $display("[%0t] PC=%h, ALU_Result=%h, MEM_Out=%h | ln1=%h, ln2=%h, alu_op=%b | WR[%0d]=%h | MEM_WR=%h",
                $time, pc_out_tb, alu_out_tb, mem_out_atrasado_tb,
                debug_ln1_tb, debug_ln2_tb, debug_alu_op_tb,
                debug_write_reg_tb, debug_write_data_tb, debug_mem_write_data_tb);
        end
    end
end

    // Sequência de reset e finalização
    initial begin
        $display("------ INICIO DA SIMULACAO DO PROCESSADOR MIPS ------");
        reset_tb = 1;
        #15;
        reset_tb = 0;
        #600; // deve ser o suficiente pra durar a simulação
        $display("------ FIM DA SIMULACAO ------");
        $finish;
    end

endmodule
