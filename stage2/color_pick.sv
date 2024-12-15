`timescale 1ns / 1ps

module color_pick(
    input [7:0] selection,
    output logic Red,
    output logic Green,
    output logic Blue
);
  always @(*) begin
        if(selection[0] == 1) begin
            Red = 0;
            Green = 0;
            Blue = 0;
        end
        else if(selection[1] == 1) begin
            Red = 1;
            Green = 1;
            Blue = 1;
        end
        else if(selection[2] == 1) begin
            Red = 1;
            Green = 1;
            Blue = 0;
        end
        else if(selection[3] == 1) begin
            Red = 1;
            Green = 0;
            Blue = 1;
        end
        else if(selection[4] == 1) begin
            Red = 0;
            Green = 1;
            Blue = 1;
        end
        else if(selection[5] == 1) begin
            Red = 1;
            Green = 0;
            Blue = 0;
        end
        else if(selection[6] == 1) begin
            Red = 0;
            Green = 1;
            Blue = 0;
        end
        else if(selection[7] == 1) begin
            Red = 0;
            Green = 0;
            Blue = 1;
        end
        else begin
            Red = 0;
            Green = 0;         
            Blue = 0;
        end
   end    
endmodule