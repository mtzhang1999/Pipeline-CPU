`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/05 11:22:53
// Design Name: 
// Module Name: Hazard
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


module Hazard(HazardControl, PCSource,
            Address_ID_EX, MemRead_ID_EX, RegWrite_ID_EX,
            Address_EX_MEM, MemRead_EX_MEM,
            Rs, Rt
    );
    input [2:0] PCSource;
    input [4:0] Address_ID_EX, Address_EX_MEM;
    input MemRead_ID_EX, RegWrite_ID_EX, MemRead_EX_MEM;
    input [4:0] Rs, Rt;
    // Output Control Signals
    output wire HazardControl;
    
    wire Hazard_jr, Hazard_lw;
    wire Flag1, Flag2;
    
    assign Flag1 = ((Address_ID_EX == Rs || Address_ID_EX == Rt) && (Address_ID_EX != 0));
    assign Flag2 = ((Address_EX_MEM == Rs || Address_EX_MEM == Rt) && (Address_EX_MEM != 0));
    
    assign Hazard_jr = ((RegWrite_ID_EX && Flag1) || (MemRead_EX_MEM && Flag2) && (PCSource == 3'b010));
    assign Hazard_lw = (MemRead_ID_EX && Flag1);
    assign HazardControl = Hazard_jr || Hazard_lw;
endmodule
