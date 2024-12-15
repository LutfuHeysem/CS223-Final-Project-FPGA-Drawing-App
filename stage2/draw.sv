`timescale 1ns / 1ps

module draw(
    input moveUp,
    input moveDown,
    input moveLeft,
    input moveRight,
    input draw,
    input [7:0] color,
    input bigBrush,
    input logic clk,
    input logic rst,
    input logic rst_screen,
    input logic rst_cursor,
    output logic hsync,
    output logic vsync,
    output logic [2:0] vgargb
    );
    
    localparam DATA_WIDTH = 3;
    localparam ADDR_WIDTH = 20;
    localparam MEM_SIZE = 480 * 640;
    
    logic video_on;
    logic p_tick;
    logic [9:0] x;
    logic [9:0] y;
    logic [9:0] cursor_x;
    logic [9:0] cursor_y;
    
    logic drawColorRed;
    logic drawColorGreen;
    logic drawColorBlue;
    
    logic [ADDR_WIDTH-1:0] mem_write_addr;
    logic [ADDR_WIDTH-1:0] mem_read_addr;
    logic [DATA_WIDTH-1:0] mem_write_data;
    logic [DATA_WIDTH-1:0] mem_read_data;
    logic mem_we;
    
    VGA_controller(.clk_100MHz(clk), .reset(rst), .video_on(video_on),
                   .p_tick(p_tick),
                   .hsync(hsync), .vsync(vsync), 
                   .x(x), .y(y));

    logic slw_clk;               
    clock_divider clock_divider_inst(.clk(clk), .reset(rst), .slow_clk(slw_clk));
    
    color_pick color_pick_inst(.selection(color), .Red(drawColorRed), .Green(drawColorGreen), .Blue(drawColorBlue));
    
    logic [3:0] brushSize;
    logic [3:0] paintArea;
    control_cursor control_cursor_inst(.moveUp(moveUp), .moveDown(moveDown), .moveLeft(moveLeft), .moveRight(moveRight),
                   .rst_cursor(rst_cursor), .slw_clk(slw_clk), .bigBrush(bigBrush),
                   .cursor_x(cursor_x), .cursor_y(cursor_y), .brushSize(brushSize), .paintArea(paintArea));
                   
    // --- BRAM Instance ---
      bram_memory #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH),
        .MEM_SIZE(MEM_SIZE)
      )bram_inst (
        .clk(clk),
        .we(mem_we),
        .write_addr(mem_write_addr),
        .read_addr(mem_read_addr),
        .din(mem_write_data),
        .dout(mem_read_data)
      );
    // --- End of BRAM Instance ---
    
    address_generator #(
      .DATA_WIDTH(DATA_WIDTH),
      .ADDR_WIDTH(ADDR_WIDTH)
    ) address_gen_inst (
      .clk(clk),
      .rst(rst_screen),
      .x(x),
      .y(y),
      .cursor_x(cursor_x),
      .cursor_y(cursor_y),
      .brushSize(brushSize),
      .paintArea(paintArea),
      .draw(draw),
      .drawColorRed(drawColorRed),
      .drawColorGreen(drawColorGreen),
      .drawColorBlue(drawColorBlue),
      .video_on(video_on),
      .mem_we(mem_we),
      .mem_write_addr(mem_write_addr),
      .mem_write_data(mem_write_data),
      .mem_read_addr(mem_read_addr)
    );
    
    logic [2:0] current_pixel;
    always_ff @(posedge clk) begin
        if(video_on) begin
            if ((x == cursor_x && (y >= cursor_y - brushSize && y <= cursor_y + brushSize)) ||
                (y == cursor_y && (x >= cursor_x - brushSize && x <= cursor_x + brushSize))) begin
                current_pixel <= 3'b000; // Cursor in black
            end else begin
                current_pixel <= mem_read_data;
            end
        end else begin
            current_pixel <= 3'b000;
        end
        vgargb <= current_pixel;
    end
endmodule