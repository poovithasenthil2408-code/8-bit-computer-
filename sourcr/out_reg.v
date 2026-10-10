
module out_reg(
    input clk, reset, OI,
    input [7:0]bus_in,
    output reg [7:0]out_register
    );
    always@(posedge clk or posedge reset)
    begin
    if(reset)
    out_register<=8'b00000000;
    else if(OI)
    out_register<=bus_in;
    end
endmodule