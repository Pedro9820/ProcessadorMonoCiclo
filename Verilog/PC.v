// modulo do pc, recebe o clock, e o reset 
module PC(
input wire clock, // entrada do clock
input wire [31:0] nextPC, // entrada do proximo pc ( será diferente de pc +4 no caso de branch)
output reg [31:0] PC// saida do pc atual
);

	initial begin
        PC = 32'b0;
    end

always @(posedge clock) begin // só inicia a função, ao sentir um pulso de reset ou clock.
PC <= nextPC; // se não for reset, simplesmente o pc vai receber o valor calculado da ULA ( geralmente + 4 )

end

endmodule