
module B_reg(
    input clk,
    input reset,
    input BI,
    input [7:0] bus_in,
    output reg [7:0] B
);

    always @(posedge clk or posedge reset)
    begin
        if (reset)
            B <= 8'b00000000;

        else if (BI)
            B <= bus_in;
    end

endmodule

