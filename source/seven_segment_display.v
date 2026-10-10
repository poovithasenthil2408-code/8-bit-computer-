
`timescale 1ns / 1ps


module seven_segment_display(
    input clk,
    input reset,
    input [7:0] binary,

    output reg [6:0] seg,
    output reg [7:0] an
);

    reg [3:0] hundreds;
    reg [3:0] tens;
    reg [3:0] ones;
    reg [3:0] digit;

    reg [16:0] refresh_counter;
    reg [1:0] digit_select;

    // 1. Binary to decimal digits
    always @(*) begin
        hundreds = binary / 100;
        tens     = (binary % 100) / 10;
        ones     = binary % 10;
    end

    // 2. Display refresh counter
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            refresh_counter <= 0;
            digit_select <= 0;
        end
        else if (refresh_counter >= 17'd99999) begin
            refresh_counter <= 0;

            if (digit_select == 2)
                digit_select <= 0;
            else
                digit_select <= digit_select + 1'b1;
        end
        else begin
            refresh_counter <= refresh_counter + 1'b1;
        end
    end

    // 3. Select one of the three digits
    always @(*) begin
        digit = 4'd0;
        an = 8'b11111111;

        case (digit_select)
            2'd0: begin
                digit = ones;
                an = 8'b11111110;
            end

            2'd1: begin
                digit = tens;
                an = 8'b11111101;
            end

            2'd2: begin
                digit = hundreds;
                an = 8'b11111011;
            end

            default: begin
                digit = 4'd0;
                an = 8'b11111111;
            end
        endcase
    end

    // 4. Seven-segment decoder
    // Active-low segments: abcdefg
    always @(*) begin
        case (digit)
            4'd0: seg = 7'b0000001;
            4'd1: seg = 7'b1001111;
            4'd2: seg = 7'b0010010;
            4'd3: seg = 7'b0000110;
            4'd4: seg = 7'b1001100;
            4'd5: seg = 7'b0100100;
            4'd6: seg = 7'b0100000;
            4'd7: seg = 7'b0001111;
            4'd8: seg = 7'b0000000;
            4'd9: seg = 7'b0000100;
            default: seg = 7'b1111111;
        endcase
    end

endmodule
