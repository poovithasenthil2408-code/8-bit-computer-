
module ram(ram_out,clk,write_en,read_en,ram_add,ram_in);
input clk,write_en,read_en;
input [3:0]ram_add;
input [7:0]ram_in;
output [7:0]ram_out;
reg [7:0] memory [0:15];
always@(posedge clk) begin
if(write_en)
memory[ram_add]<=ram_in;
end
assign ram_out=read_en?memory[ram_add]:8'b00000000;
endmodule
