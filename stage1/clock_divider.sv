module clock_divider (
    input wire clk_in,
    input wire rst,
    output reg clk_out
);
    reg count = 0;
    
    always @(posedge clk_in or posedge rst) begin
        if (rst) begin
            count <= 0;
            clk_out <= 0;
        end else begin
            count <= ~count;
            if (count) clk_out <= ~clk_out;
        end
    end
endmodule