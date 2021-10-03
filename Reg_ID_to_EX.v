`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/04 20:29:46
// Design Name: 
// Module Name: Reg_ID_to_EX
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


module Reg_ID_to_EX(clk,reset,
                    Flush, PC_i, ALUSrcA_i, ALUSrcB_i, ALUOp_i,
                    Shamt_i, Funct_i, Addr_i, Imm_i, Branch_i, BranchOp_i,
                    MemtoReg_i, MemRead_i, MemWrite_i, RegWrite_i,
                    Rs_i, Rd_i, ForwardingA_i, ForwardingB_i
    );
    input clk, reset;
    input Flush;
    
    input [31:0] PC_i;
    input ALUSrcA_i;
    input ALUSrcB_i;
    input [3:0] ALUOp_i;
    
    input [4:0] Shamt_i;
    input [5:0] Funct_i;
    input [4:0] Addr_i;
    input [31:0] Imm_i;
    input Branch_i;
    input [2:0] BranchOp_i;
    input [1:0] MemtoReg_i; 
    input MemRead_i, MemWrite_i, RegWrite_i;
    
    input [31:0] Rs_i, Rd_i;
    input [1:0] ForwardingA_i, ForwardingB_i;
    
    reg [31:0] PC;
    reg ALUSrcA, ALUSrcB;
    reg [3:0] ALUOp;
    reg [4:0] Shamt;
    reg [5:0] Funct;
    reg [4:0] Addr;
    reg [31:0] Imm;
    reg Branch;
    reg [2:0] BranchOp;
    reg [1:0] MemtoReg;
    reg MemRead, MemWrite, RegWrite;
    reg [31:0] Rs, Rt;
    reg [1:0] ForwardingA, ForwardingB;
    
    always @(posedge clk or posedge reset)
        begin
            if(reset) begin
                PC <= 32'h0;
                ALUSrcA <= 1'b0;
                ALUSrcB <= 1'b0;
                ALUOp <= 4'b0;
                Shamt <= 5'b0;
                Funct <= 6'b0;
                Addr <= 5'b0;
                Imm <= 32'h0;
                Branch <= 1'b0;
                BranchOp <= 3'b0;
                MemtoReg <= 2'b0;
                MemRead <= 1'b0;
                MemWrite <= 1'b0;
                RegWrite <= 1'b0;
                Rs <= 32'h0;
                Rt <= 32'h0;
                ForwardingA <= 2'b0;
                ForwardingB <= 2'b0;
            end
            else begin
                PC <= PC_i;
                ALUSrcA <= ALUSrcA_i;
                ALUSrcB <= ALUSrcB_i;
                ALUOp <= ALUOp_i;
                Shamt <= Shamt_i;
                Funct <= Funct_i;
                Addr <= Addr_i;
                Imm <= Imm_i;
                Branch <= Branch_i;
                BranchOp <= BranchOp_i;
                MemtoReg <= MemtoReg_i;
                MemRead <= MemRead_i;
                MemWrite <= MemWrite_i;
                RegWrite <= RegWrite_i;
                Rs <= Rs_i;
                Rt <= Rd_i;
                ForwardingA <= ForwardingA_i;
                ForwardingB <= ForwardingB_i;
            end
         end
endmodule
