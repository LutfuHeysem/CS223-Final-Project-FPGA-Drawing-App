module vga_top (
    input wire clk,             
    input wire rst,             
    input wire btnU,           
    input wire btnD,           
    input wire btnR,           
    input wire btnL,           
    output wire [3:0] vgaRed,  
    output wire [3:0] vgaGreen,
    output wire [3:0] vgaBlue, 
    output wire Hsync,         
    output wire Vsync          
);

    wire clk_25MHz;
    clock_divider clk_div (
        .clk_in(clk),
        .rst(rst),
        .clk_out(clk_25MHz)
    );

    wire [9:0] pixel_x;        
    wire [9:0] pixel_y;        
    wire video_on;             
    
    reg [9:0] scroll_x = 0;
    reg [9:0] scroll_y = 0;
    
    reg [15:0] scroll_counter = 0;
    wire scroll_tick;
    
    always @(posedge clk_25MHz) begin
        if (rst)
            scroll_counter <= 0;
        else
            scroll_counter <= scroll_counter + 1;
    end
    
    assign scroll_tick = (scroll_counter == 0);
    
    vga_sync sync_gen (
        .clk(clk_25MHz),
        .rst(rst),
        .hsync(Hsync),
        .vsync(Vsync),
        .video_on(video_on),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y)
    );
    
    pattern_gen pattern (
        .clk(clk_25MHz),
        .video_on(video_on),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .scroll_x(scroll_x),
        .scroll_y(scroll_y),
        .vgaRed(vgaRed),
        .vgaGreen(vgaGreen),
        .vgaBlue(vgaBlue)
    );
    
    always @(posedge clk_25MHz) begin
        if (rst) begin
            scroll_x <= 0;
            scroll_y <= 0;
        end else if (scroll_tick) begin
            if (btnR) scroll_x <= scroll_x + 1;
            if (btnL) scroll_x <= scroll_x - 1;
            if (btnD) scroll_y <= scroll_y + 1;
            if (btnU) scroll_y <= scroll_y - 1;
        end
    end

endmodule