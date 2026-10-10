
module mar(
    input clk,reset,MI,
    input [3:0]bus_in,
    output reg [3:0]mar_out
    );
    always@(posedge clk or posedge reset)
    begin
    if(reset)
    mar_out<=4'b0000;
    else if(MI)
    mar_out<=bus_in;
    else
    mar_out<=mar_out;
    end
endmodule