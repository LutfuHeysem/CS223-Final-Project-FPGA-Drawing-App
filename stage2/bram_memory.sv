module bram_memory #(
    parameter DATA_WIDTH = 3,
    parameter ADDR_WIDTH = 20,
    parameter MEM_SIZE = 480 * 640
) (
    input  logic        clk,
    input  logic        we,
    input  logic [ADDR_WIDTH-1:0] write_addr,
    input  logic [ADDR_WIDTH-1:0] read_addr,
    input  logic [DATA_WIDTH-1:0] din,
    output logic [DATA_WIDTH-1:0] dout
);

    logic [DATA_WIDTH-1:0] mem [0:MEM_SIZE-1];

    always_ff @(posedge clk) begin
        if(we) begin
            mem[write_addr] <= din;
        end
        dout <= mem[read_addr];
    end

endmodule