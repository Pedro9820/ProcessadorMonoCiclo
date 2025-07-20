// ctrl_tb.v
// Bancada de testes AJUSTADA para a Unidade de Controle Principal.
`timescale 1ns/1ps

module ctrl_tb;

    // --- Sinais ---
    // Entrada que vamos controlar
    reg  [5:0] OPCode_tb;

    // Saídas que vamos observar (AGORA CORRESPONDEM AO NOVO 'ctrl.v')
    wire       RegDst_tb, Branch_tb, MemRead_tb, MemtoReg_tb, MemWrite_tb, ALUSrc_tb, RegWrite_tb, Jump_tb;
    wire       ALUTipoR_tb;
    wire [3:0] ALUnaoR_tb;


    // --- Instanciação da Unidade Sob Teste (UUT) com as novas portas ---
    ctrl uut (
        .OPCode(OPCode_tb),
        .RegDst(RegDst_tb),
        .Branch(Branch_tb),
        .MemRead(MemRead_tb),
        .MemtoReg(MemtoReg_tb),
        .MemWrite(MemWrite_tb),
        .ALUSrc(ALUSrc_tb),
        .RegWrite(RegWrite_tb),
        .Jump(Jump_tb),
        .ALUTipoR(ALUTipoR_tb),
        .ALUnaoR(ALUnaoR_tb)
    );

    // --- Roteiro de Testes ---
    initial begin
        $display("------ INICIO DOS TESTES DA CTRL (VERSAO AJUSTADA) ------");
        
        // Teste 1: Instrução Tipo-R (ex: add, funct=100000)
        OPCode_tb = 6'b000000;
        #10;
        $display("[%0t] Teste Tipo-R: ALUTipoR=%b (Esperado: 1), ALUnaoR=%h (Esperado: x), RegDst=%b (Esperado: 1), RegWrite=%b (Esperado: 1)", 
                  $time, ALUTipoR_tb, ALUnaoR_tb, RegDst_tb, RegWrite_tb);

        // Teste 2: Instrução 'lw' (opcode = 100011)
        OPCode_tb = 6'b100011;
        #10;
        $display("[%0t] Teste LW: ALUTipoR=%b (Esperado: 0), ALUnaoR=%h (Esperado: 2 - ADD), MemRead=%b (Esperado: 1), MemtoReg=%b (Esperado: 1), RegWrite=%b (Esperado: 1)", 
                  $time, ALUTipoR_tb, ALUnaoR_tb, MemRead_tb, MemtoReg_tb, RegWrite_tb);
                  
        // Teste 3: Instrução 'beq' (opcode = 000100)
        OPCode_tb = 6'b000100;
        #10;
        $display("[%0t] Teste BEQ: ALUTipoR=%b (Esperado: 0), ALUnaoR=%h (Esperado: 6 - SUB), Branch=%b (Esperado: 1)", 
                  $time, ALUTipoR_tb, ALUnaoR_tb, Branch_tb);

        // Teste 4: Instrução 'andi' (opcode = 001100)
        OPCode_tb = 6'b001100;
        #10;
        $display("[%0t] Teste ANDI: ALUTipoR=%b (Esperado: 0), ALUnaoR=%h (Esperado: 0 - AND), RegWrite=%b (Esperado: 1)", 
                  $time, ALUTipoR_tb, ALUnaoR_tb, RegWrite_tb);

        // Teste 5: Instrução 'j' (opcode = 000010)
        OPCode_tb = 6'b000010;
        #10;
        $display("[%0t] Teste JUMP: Jump=%b (Esperado: 1)", $time, Jump_tb);

        #10;
        $display("------ FIM DOS TESTES ------");
        $finish;
    end

endmodule