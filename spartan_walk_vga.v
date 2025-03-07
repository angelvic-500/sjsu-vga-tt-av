  # Save the updated Verilog file for the user to download
verilog_code = """\
module spartan_walk_vga(
    input clk,               // System clock
    input reset,             // Reset button
    output hsync, vsync,     // VGA sync signals
    output [3:0] r, g, b     // VGA color outputs
);

    // VGA signal generator
    wire [9:0] hpos, vpos;
    hvsync_generator vga_sync (
        .clk(clk), .reset(reset), .hsync(hsync), .vsync(vsync), .hpos(hpos), .vpos(vpos)
    );
    
    // Position variables for animation
    reg [9:0] spartan_x = 100;
    reg direction = 1; // 1 = right, 0 = left

    // Clock divider to slow animation speed
    reg [20:0] counter = 0;
    always @(posedge clk) begin
        counter <= counter + 1;
        if (counter == 0) begin // Every few clock cycles
            if (direction)
                spartan_x <= spartan_x + 1;
            else
                spartan_x <= spartan_x - 1;
            
            // Change direction at edges
            if (spartan_x > 400) direction <= 0;
            if (spartan_x < 100) direction <= 1;
        end
    end

    // Spartan Helmet 16x16 pixel sprite (monochrome example)
    wire spartan_pixel;
    spartan_rom sprite (
        .clk(clk), 
        .x(hpos - spartan_x[3:0]), 
        .y(vpos - 100[3:0]), 
        .pixel(spartan_pixel)
    );
    
    // Set pixel color
    assign r = (spartan_pixel) ? 4'hF : 4'h0;
    assign g = (spartan_pixel) ? 4'hF : 4'h0;
    assign b = (spartan_pixel) ? 4'h0 : 4'h0;

endmodule
"""

# Save the file
file_path = "/mnt/data/spartan_walk_vga.v"
with open(file_path, "w") as f:
    f.write(verilog_code)

file_path
