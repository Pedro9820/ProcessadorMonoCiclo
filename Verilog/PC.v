// modulo do pc, recebe o clock, e o reset 
module pc(
input wire clk, // entrada do clock
input wire rst, // entrada do pulso de reset
input wire [31:0] proximo_Pc, // entrada do proximo pc ( será diferente de pc +4 no caso de branch)
output reg [31:0] atual_Pc // saida do pc atual
);

always @(posedge clk or posedge rst) begin // só inicia a função, ao sentir um pulso de reset ou clock.
if(rst)
atual_Pc <= 32'h00000000; // reinicia o PC para 0.
else
atual_Pc <= proximo_Pc; // se não for reset, simplesmente o pc vai receber o valor calculado da ULA ( geralmente + 4 )

end

endmodule