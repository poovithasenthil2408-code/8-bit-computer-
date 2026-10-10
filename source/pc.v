


module pc(
    input clk,reset,CO,Pinc,Cl,
    input [3:0]bus_in,
    output [3:0]bus_out,
    output reg [3:0]pc_out
    );
    always@(posedge clk or posedge reset)
    begin
    if(reset)
    pc_out<=4'b0000;
    else if(Cl)
    pc_out<=bus_in;
    else if(Pinc)
    pc_out<=pc_out+4'b0001;
    end
    assign bus_out=CO?pc_out:4'b0000;
endmodule