`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/04 19:29:02
// Design Name: 
// Module Name: Reg_EX_to_MEM
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


module Reg_EX_to_MEM(clk, reset,
                    ALUOut_i, Rt_i, PC_i, Addr_i,
                    MemtoReg_i, MemRead_i, MemWrite_i, RegWrite_i
    );
    input clk, reset;
    // Input Data
    input [31:0] ALUOut_i;
    input [31:0] Rt_i;
    input [31:0] PC_i;
    input [4:0] Addr_i;
    
    // MEM Control
    input [1:0] MemtoReg_i;
    input MemRead_i;
    
    // WB Control
    input MemWrite_i;
    input RegWrite_i;
    
    reg [31:0] ALUOut;
    reg [31:0] Rt;
    reg [31:0] PC;
    reg [4:0] Addr;
    
    reg [1:0] MemtoReg;
    reg MemRead;
    reg MemWrite;
    reg RegWrite;
    
    always @(posedge clk or posedge reset)
        begin
            if(reset) begin
                ALUOut <= 32'h0;
                Rt <= 32'h0;
                PC <= 32'h0;
                Addr <= 5'h0;
                MemtoReg <= 2'h0;
                MemRead <= 1'b0;
                MemWrite <= 1'h0;
                RegWrite <= 1'h0;
            end
            else begin
                ALUOut <= ALUOut_i;
                Rt <= Rt_i;
                PC <= PC_i;
                Addr <= Addr_i;
                MemtoReg <= MemtoReg_i;
                MemRead <= MemRead_i;
                MemWrite <= MemWrite_i;
                RegWrite <= RegWrite_i;
            end
        end            
endmodule
