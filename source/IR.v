

module IR(
    input clk,
    input reset,
    input II,
    input [7:0] bus_in,
    output reg [7:0] ir_out,
    output [3:0] opcode
);

    always @(posedge clk or posedge reset) begin
        if (reset)
            ir_out <= 8'b0;
        else if (II)
            ir_out <= bus_in;
    end

    assign opcode = ir_out[7:4];

endmodule
