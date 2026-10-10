
module control_unit(out,clk,reset,opcode,zero_flag);
output [15:0]out;
input clk,reset;
input [3:0]opcode;
input zero_flag;
localparam HLT=15,FI=14,MI=13,RI=12,RO=11,II=10;
localparam IO=9,AI=8,AO=7,ALU_O=6,SUB=5,BI=4,OI=3,CO=2,Pinc=1,CL=0;
localparam OP_LDA=4'b0000;
localparam OP_ADD=4'b0001;
localparam OP_SUB=4'b0010;
localparam OP_STA=4'b0011;
localparam OP_JMP=4'b0100;
localparam OP_JZ=4'b0101;
localparam OP_OUT=4'b0110;
localparam OP_HLT=4'b0111;
reg [15:0]ctrl_wd;
reg [2:0]state;
reg halt;
always @(posedge clk or posedge reset)
 begin
if(reset)
begin
state <= 3'b0;
halt<=0;
end
else if(halt)
begin
state<=state;
end
else if(ctrl_wd[HLT])
begin
halt<=1;
state <= state;
end
else if(state == 5)
state <= 0;
else
state <= state + 1;
end
always@(*)
begin
ctrl_wd=16'b0;
case(state)
0: begin
ctrl_wd[CO]=1;
ctrl_wd[MI]=1;
end
1: begin
ctrl_wd[RO]=1;
ctrl_wd[II]=1;
end
2: begin
ctrl_wd[Pinc]=1;
end
3: begin
case(opcode)
OP_LDA,OP_STA,OP_ADD,OP_SUB: begin
ctrl_wd[IO]=1;
ctrl_wd[MI]=1;
end
OP_JMP: begin
ctrl_wd[IO]=1;
ctrl_wd[CL]=1;
end
OP_OUT: begin
ctrl_wd[AO]=1;
ctrl_wd[OI]=1;
end
OP_HLT: begin
ctrl_wd[HLT]=1;
end
OP_JZ: if(zero_flag) begin
ctrl_wd[IO]=1;
ctrl_wd[CL]=1;
end
endcase 
end
4: begin
case (opcode)
OP_LDA: begin
ctrl_wd[RO]=1;
ctrl_wd[AI]=1;
end
OP_STA: begin
ctrl_wd[AO]=1;
ctrl_wd[RI]=1;
end
OP_ADD,OP_SUB: begin
ctrl_wd[RO]=1;
ctrl_wd[BI]=1;
end
endcase
end
5: begin
case(opcode)
OP_ADD: begin
ctrl_wd[ALU_O]=1;
ctrl_wd[AI]=1;
ctrl_wd[FI]=1;
end
OP_SUB: begin
ctrl_wd[SUB]=1;
ctrl_wd[ALU_O]=1;
ctrl_wd[AI]=1;
ctrl_wd[FI]=1;
end
endcase
end
endcase
end
assign out=ctrl_wd;
endmodule
