`timescale 1ns / 1ps
module control_cursor(
    input logic moveUp,
    input logic moveDown,
    input logic moveRight,
    input logic moveLeft,
    input logic rst_cursor,
    input logic slw_clk,
    input logic bigBrush,
    output logic [9:0] cursor_x,
    output logic [9:0] cursor_y,
    output logic [3:0] brushSize,
    output logic [3:0] paintArea
);
    
    logic [9:0] cursor_x_reg;
    logic [9:0] cursor_y_reg;
    
    localparam SCREEN_WIDTH = 640;
    localparam SCREEN_HEIGHT = 480;
    localparam CURSOR_START_X = 320;
    localparam CURSOR_START_Y = 240;

    always_ff @(posedge slw_clk or posedge rst_cursor) begin   
        if(rst_cursor) begin
            cursor_x_reg <= CURSOR_START_X;
            cursor_y_reg <= CURSOR_START_Y;
        end
        else begin
            if (moveUp) begin
                if (cursor_y_reg > 1) 
                    cursor_y_reg <= cursor_y_reg - 1;
            end
            if (moveDown) begin
                if (cursor_y_reg < (SCREEN_HEIGHT - 5)) 
                    cursor_y_reg <= cursor_y_reg + 1;
            end
            if (moveLeft) begin
                if (cursor_x_reg > 1) 
                    cursor_x_reg <= cursor_x_reg - 1;
            end
            if (moveRight) begin
                if (cursor_x_reg < (SCREEN_WIDTH - 5)) 
                    cursor_x_reg <= cursor_x_reg + 1;
            end
        end   
    end
    
    assign cursor_x = cursor_x_reg;
    assign cursor_y = cursor_y_reg;
   
    // Brush size control
    always_comb begin
        if(bigBrush) begin 
            brushSize = 4'd6;
            paintArea = 4'd3;
        end
        else begin
            brushSize = 4'd3;
            paintArea = 4'd1;
        end
    end
    
endmodule