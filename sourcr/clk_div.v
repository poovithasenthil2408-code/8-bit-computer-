
module clk_div(
    input wire clk_50MHz,
    input wire reset,
    output reg clk_5Hz
);

    reg [22:0] count;

    always @(posedge clk_50MHz or posedge reset) begin
        if (reset) begin
            count <= 0;
            clk_5Hz <= 0;
        end
        else begin
            if (count == 4999999) begin
                count <= 0;
                clk_5Hz <= ~clk_5Hz;
            end
            else begin
                count <= count + 1'b1;
            end
        end
    end

endmodule