`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/06 10:11:52
// Design Name: 
// Module Name: LEDs
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module LEDs(clk, reset,
            leds, MemWrite, Write_data
    );
    input clk, reset;
    input MemWrite;
    input [31:0] Write_data;
    output reg [31:0] leds;
    
    always @(posedge clk or posedge reset)
        begin
            if(reset) begin
                leds <= 32'h0000_0000;
            end
            else if(MemWrite) begin
                leds <= Write_data;
            end
        end
endmodule
