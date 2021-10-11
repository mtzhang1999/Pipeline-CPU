`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/05 10:35:57
// Design Name: 
// Module Name: BranchHazard
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


module BranchHazard(In1, In2, Branch, BranchOp, BranchHazard);
    input [31:0] In1, In2;
    input Branch;
    input [2:0] BranchOp;
    output BranchHazard;
    
    reg Result;
    
    assign BranchHazard = Result && Branch;
    
    always @(*)
        begin
            case(BranchOp)
                3'b001: Result = In1[31]; // bltz
                3'b010: Result = ~(In1 == In2); // bne
                3'b011: Result = In1 || In1[31]; // blez
                3'b100: Result = ~(In1 || In1[31]); // bgtz
                default: Result = In1 == In2;
            endcase
        end
endmodule
