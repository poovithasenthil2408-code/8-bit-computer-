

module A_reg(
    input clk,
    input reset,
    input AI,
    input [7:0] bus_in,
    output reg [7:0] AO
);

    always @(posedge clk or posedge reset)
    begin
        if (reset)
            AO <= 8'b00000000;

        else if (AI)
            AO <= bus_in;
    end

endmodule