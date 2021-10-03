`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/04 20:01:02
// Design Name: 
// Module Name: Reg_MEM_to_WB
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


module Reg_MEM_to_WB(clk, reset,
                    Mem_Data_i, Addr_i,
                    MemtoReg_i, RegWrite_i
    );
    input clk, reset;
    input [31:0] Mem_Data_i;
    input [4:0] Addr_i;
    input [1:0] MemtoReg_i;
    input RegWrite_i;
    
    reg [31:0] Mem_data;
    reg [4:0] Addr;
    reg [1:0] MemtoReg;
    reg RegWrite;
    
    always @(posedge clk or posedge reset)
        begin
            if(reset) begin
                Mem_data <= 32'h0;
                Addr <= 5'h0;
                MemtoReg <= 1'h0;
                RegWrite <= 1'h0;
            end
            else begin
                Mem_data <= Mem_Data_i;
                Addr <= Addr_i;
                MemtoReg <= MemtoReg_i;
                RegWrite <= RegWrite_i;
            end
        end
endmodule
