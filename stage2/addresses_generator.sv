module address_generator #(
  parameter DATA_WIDTH = 3,
  parameter ADDR_WIDTH = 20,
  parameter MEM_WIDTH = 640,
  parameter MEM_HEIGHT = 480
) (
  input logic clk,
  input logic rst,
  input logic [9:0] x,
  input logic [9:0] y,
  input logic [9:0] cursor_x,
  input logic [9:0] cursor_y,
  input logic [3:0] brushSize,
  input logic [3:0] paintArea,  
  input logic draw,
  input logic drawColorRed,
  input logic drawColorGreen,
  input logic drawColorBlue,
  input logic video_on,
  output logic mem_we,
  output logic [ADDR_WIDTH-1:0] mem_write_addr,
  output logic [DATA_WIDTH-1:0] mem_write_data,
  output logic [ADDR_WIDTH-1:0] mem_read_addr
);

  logic [ADDR_WIDTH-1:0] init_addr;
  logic init_done;
  logic mem_init_we;
  localparam WHITE = 3'b111;

  // Initialization logic
  always_ff @(posedge clk) begin
    if (rst) begin
        init_addr <= '0;
        init_done <= 1'b0;
        mem_init_we <= 1'b1;
    end else if (!init_done) begin
      if (init_addr < (MEM_WIDTH * MEM_HEIGHT)-1) begin
        init_addr <= init_addr + 1;
        mem_init_we <= 1'b1;
      end else begin
        init_done <= 1'b1;
        mem_init_we <= 1'b0;
      end
    end
  end

  // Write logic
  always_ff @(posedge clk) begin
    mem_we <= 1'b0;  // Default to no write
    mem_write_data <= WHITE; // Default data is white

    if (!init_done) begin
      // BRAM initialization
      mem_write_addr <= init_addr;
      mem_write_data <= WHITE;
      mem_we <= mem_init_we;
    end else if (video_on) begin
      if ((x >= cursor_x - paintArea && x <= cursor_x + paintArea) &&
          (y >= cursor_y - paintArea && y <= cursor_y + paintArea)) begin
        mem_write_addr <= (y * MEM_WIDTH) + x;
        if(draw) begin
          mem_write_data <= {drawColorRed, drawColorGreen, drawColorBlue};
          mem_we <= 1'b1;
        end
      end
    end
  end

  // Read address logic
  always_ff @(posedge clk) begin
    mem_read_addr <= (y * MEM_WIDTH) + x;
  end

endmodule