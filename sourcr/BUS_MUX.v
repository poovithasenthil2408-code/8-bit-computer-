
module BUS_MUX (
    input  [7:0] pc_data,
    input  [7:0] ram_data,
    input  [7:0] ir_data,
    input  [7:0] a_data,
    input  [7:0] alu_data,

    input CO,
    input RO,
    input IO,
    input AO,
    input ALU_O,

    output reg [7:0] bus,
    output reg bus_conflict
);

    always @(*) begin
        bus = 8'b00000000;
        bus_conflict = 1'b0;

        case ({CO, RO, IO, AO, ALU_O})

            5'b10000: bus = pc_data;
            5'b01000: bus = ram_data;
            5'b00100: bus = ir_data;
            5'b00010: bus = a_data;
            5'b00001: bus = alu_data;
            5'b00000: bus = 8'b00000000;

            default: begin
                bus = 8'b00000000;
                bus_conflict = 1'b1;
            end

        endcase
    end

endmodule
