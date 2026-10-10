
module cpu_top(
    input clk,
    input reset,

    output [6:0] seg,
    output [7:0] an,

    output [3:0] pc_disp,
    output halted
);
    wire clk_5Hz;
    wire [7:0] cpu_output;
    
    // Generate 5 Hz clock
    clk_div clk_div_inst (
        .clk_50MHz(clk),
        .reset(reset),
        .clk_5Hz(cpu_clk)
    );

    // CPU Core
    cpu_core cpu_inst(
        .clk(clk_5Hz),
        .reset(reset),
        .pc_disp(pc_disp),
        .out_display(cpu_output),
        .halted(halted)
    );

    // Seven-Segment Display
    seven_segment_display display_inst(
        .clk(clk),
        .reset(reset),
        .binary(cpu_output),
        .seg(seg),
        .an(an)
    );

endmodule