`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/06 10:05:03
// Design Name: 
// Module Name: SysClkCounter
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


module SysClkCounter(clk, reset, count);
    input clk, reset;
    output count;
    reg [31:0] count;
    
    always @(posedge clk or posedge reset)
        begin
            if(reset) begin
                count <= 32'h0000_0000;
            end
            else begin
                count <= count + 1;
            end
        end
endmodule
