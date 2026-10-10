
module cpu_core(
    input clk,
    input reset,
    output [3:0] pc_disp,
    output [7:0] out_display,
    output halted
);

    // Control Unit output
    wire [15:0] ctrl;

    wire HLT, FI, MI, RI, RO, II, IO;
    wire AI, AO, ALU_O, SUB, BI, OI;
    wire CO, Pinc, CL;

    assign HLT   = ctrl[15];
    assign FI    = ctrl[14];
    assign MI    = ctrl[13];
    assign RI    = ctrl[12];
    assign RO    = ctrl[11];
    assign II    = ctrl[10];
    assign IO    = ctrl[9];
    assign AI    = ctrl[8];
    assign AO    = ctrl[7];
    assign ALU_O = ctrl[6];
    assign SUB   = ctrl[5];
    assign BI    = ctrl[4];
    assign OI    = ctrl[3];
    assign CO    = ctrl[2];
    assign Pinc  = ctrl[1];
    assign CL    = ctrl[0];

    assign halted = HLT;

    // Internal signals
    wire [3:0] pc_bus;
    wire [3:0] pc_value;
    wire [3:0] mar_address;

    wire [7:0] ram_data;
    wire [7:0] IR_bus;
    wire [7:0] IR_value;
    wire [3:0] opcode;

    wire [7:0] a_value;
    wire [7:0] b_value;
    wire [7:0] alu_result;
    wire [7:0] bus;

    wire [7:0] out_value;

    wire carry_alu;
    wire zero_alu;
    wire carry_flag;
    wire zero_flag;

    wire bus_conflict;

    // Program Counter
    pc pc_inst(
        .clk(clk),
        .reset(reset),
        .CO(CO),
        .Pinc(Pinc),
        .Cl(CL),
        .bus_in(bus[3:0]),
        .bus_out(pc_bus),
        .pc_out(pc_value)
    );

    assign pc_disp = pc_value;

    // Memory Address Register
    mar mar_inst(
        .clk(clk),
        .reset(reset),
        .MI(MI),
        .bus_in(bus[3:0]),
        .mar_out(mar_address)
    );

    // RAM
    ram ram_inst(
        .ram_out(ram_data),
        .clk(clk),
        .write_en(RI),
        .read_en(RO),
        .ram_add(mar_address),
        .ram_in(bus)
    );

    // Instruction Register
    IR ir_inst(
       .clk(clk),
       .reset(reset),
       .II(II),
       .bus_in(bus),
       .ir_out(IR_value),
       .opcode(opcode)
    );

    // A Register
    A_reg a_inst(
        .clk(clk),
        .reset(reset),
        .AI(AI),
        .bus_in(bus),
        .AO(a_value)
    );

    // B Register
    B_reg b_inst(
        .clk(clk),
        .reset(reset),
        .BI(BI),
        .bus_in(bus),
        .B(b_value)
    );

    // ALU
    ALU alu_inst(
        .A(a_value),
        .B(b_value),
        .ADD(ALU_O & ~SUB),
        .SUB(ALU_O & SUB),
        .ALU_O(alu_result),
        .carry(carry_alu),
        .zero(zero_alu)
    );

    // Flag Register
    Flag_Register flag_inst(
        .clk(clk),
        .reset(reset),
        .FI(FI),
        .carry_in(carry_alu),
        .zero_in(zero_alu),
        .carry(carry_flag),
        .zero(zero_flag)
    );

    // Output Register
    out_reg out_inst(
        .clk(clk),
        .reset(reset),
        .OI(OI),
        .bus_in(bus),
        .out_register(out_value)
    );

    assign out_display = out_value;

    // Control Unit
    control_unit control_inst(
        .out(ctrl),
        .clk(clk),
        .reset(reset),
        .opcode(opcode),
        .zero_flag(zero_flag)
    );

    // Common Bus Multiplexer
    // The MUX selects one source for the shared bus.
    BUS_MUX bus_max_inst(
        .pc_data({4'b0000, pc_value}),
        .ram_data(ram_data),
        .ir_data({4'b0000, IR_value[3:0]}),
        .a_data(a_value),
        .alu_data(alu_result),

        .CO(CO),
        .RO(RO),
        .IO(IO),
        .AO(AO),
        .ALU_O(ALU_O),

        .bus(bus),
        .bus_conflict(bus_conflict)
    );

endmodule
