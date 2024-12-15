module pattern_gen (
    input wire clk,
    input wire video_on,
    input wire [9:0] pixel_x,
    input wire [9:0] pixel_y,
    input wire [9:0] scroll_x,
    input wire [9:0] scroll_y,
    output reg [3:0] vgaRed,
    output reg [3:0] vgaGreen,
    output reg [3:0] vgaBlue
);
    parameter SQUARE_SIZE = 64;  
    
    wire [9:0] adjusted_x = pixel_x + scroll_x;
    wire [9:0] adjusted_y = pixel_y + scroll_y;
    
    wire is_black_square = ((adjusted_x / SQUARE_SIZE) + (adjusted_y / SQUARE_SIZE)) % 2;
    
    always @(posedge clk) begin
        if (!video_on) begin
            vgaRed <= 0;
            vgaGreen <= 0;
            vgaBlue <= 0;
        end else begin
            if (is_black_square) begin
                vgaRed <= 4'h0;
                vgaGreen <= 4'h0;
                vgaBlue <= 4'hF;
            end else begin
                vgaRed <= 4'hF;
                vgaGreen <= 4'hF;
                vgaBlue <= 4'h0;
            end
        end
    end
endmodule