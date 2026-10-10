
module Flag_Register(
    input clk,
    input reset,
    input FI,
    input carry_in,
    input zero_in,
    output reg carry,
    output reg zero
);

    always @(posedge clk or posedge reset)
    begin
        if (reset)
        begin
            carry <= 1'b0;
            zero  <= 1'b0;
        end

        else if (FI)
        begin
            carry <= carry_in;
            zero  <= zero_in;
        end
    end

endmodule
