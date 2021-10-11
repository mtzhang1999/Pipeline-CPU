`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/06 10:24:28
// Design Name: 
// Module Name: SSD
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


module SSD(clk, reset,
        ssd, MemWrite, Write_data
    );
    input clk, reset;
    input MemWrite;
    input [31:0] Write_data;
    output ssd;
    reg [31:0] ssd;
    
    always @(posedge clk or posedge reset)
        begin
            if(reset) begin
                ssd <= 32'h0000_0000;
            end
            else if(MemWrite) begin
                ssd <= Write_data;
            end
        end
endmodule
