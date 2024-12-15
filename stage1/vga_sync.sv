module vga_sync (
    input wire clk,           
    input wire rst,
    output reg hsync,
    output reg vsync,
    output wire video_on,
    output reg [9:0] pixel_x,
    output reg [9:0] pixel_y
);
    parameter H_DISPLAY = 640;  
    parameter H_FRONT = 16;     
    parameter H_SYNC = 96;      
    parameter H_BACK = 48;      
    parameter H_TOTAL = 800;    
    
    parameter V_DISPLAY = 480;  
    parameter V_FRONT = 10;     
    parameter V_SYNC = 2;       
    parameter V_BACK = 33;      
    parameter V_TOTAL = 525;    
    
    reg [9:0] h_count = 0;
    reg [9:0] v_count = 0;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            h_count <= 0;
            v_count <= 0;
        end else begin
            if (h_count == H_TOTAL-1) begin
                h_count <= 0;
                if (v_count == V_TOTAL-1)
                    v_count <= 0;
                else
                    v_count <= v_count + 1;
            end else
                h_count <= h_count + 1;
        end
    end
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            hsync <= 1;
            vsync <= 1;
        end else begin
            hsync <= ~(h_count >= H_DISPLAY + H_FRONT && 
                      h_count < H_DISPLAY + H_FRONT + H_SYNC);
            vsync <= ~(v_count >= V_DISPLAY + V_FRONT && 
                      v_count < V_DISPLAY + V_FRONT + V_SYNC);
        end
    end
    
    assign video_on = (h_count < H_DISPLAY) && (v_count < V_DISPLAY);
    
    always @(posedge clk) begin
        pixel_x <= h_count;
        pixel_y <= v_count;
    end
    
endmodule