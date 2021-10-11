`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/04 20:15:55
// Design Name: 
// Module Name: Reg_IF_to_ID
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


module Reg_IF_to_ID(clk, reset,
                    Flush, PC_i, wr_EN, Ins_i
    );
    input clk, reset;
    input Flush;
    input [31:0] PC_i;
    input wr_EN;
    input [31:0] Ins_i;
    
    reg [31:0] PC;
    reg [31:0] Ins;
    
    always @(posedge clk or posedge reset)
        begin
            if(reset) begin
                PC <= 32'h0;
                Ins <= 32'h0;
            end
            else begin
                if(wr_EN) begin
                    PC <= PC_i;
                    Ins <= Flush ? 32'h0 : Ins_i;
                end
            end
        end
endmodule
