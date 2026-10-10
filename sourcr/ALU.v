
module ALU(
    input  [7:0] A,
    input  [7:0] B,
    input        ADD,
    input        SUB,

    output reg [7:0] ALU_O,
    output reg       carry,
    output           zero
);

    reg [8:0] temp;

    always @(*)
    begin
        temp  = 9'b0;
        ALU_O  = 8'b0;
        carry = 1'b0;

        if (ADD)
        begin
            temp  = {1'b0, A} + {1'b0, B};
            ALU_O  = temp[7:0];
            carry = temp[8];
        end

        else if (SUB)
        begin
            temp  = {1'b0, A} - {1'b0, B};
            ALU_O  = temp[7:0];
        end
    end

    assign zero = (ALU_O == 8'b00000000);

endmodule
