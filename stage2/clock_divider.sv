`timescale 1ns / 1ps

module clock_divider(
    input logic clk,
    input logic reset,
    output logic slow_clk
    );
    
    logic [28:0] counter;
    
    localparam TARGET = 500000;
    
    always @(posedge clk or posedge reset)
    begin
        if(reset)begin
            counter <= 0;
            slow_clk <= 0;
        end else begin
            if(counter == TARGET-1)begin
                counter <= 0;  
                slow_clk <= ~slow_clk;
             end else begin
                counter <= counter + 1;
             end
        end
    end
endmodule
