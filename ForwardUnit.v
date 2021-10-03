`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/05 12:19:30
// Design Name: 
// Module Name: ForwardUnit
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


module ForwardUnit(reset,
                Address_ID_EX, RegWrite_ID_EX,
                Address_EX_MEM, RegWrite_EX_MEM,
                Address_MEM_WB, RegWrite_MEM_WB,
                Forward_ID_A, Forward_ID_B, Forward_EX_A, Forward_EX_B,
                Rs, Rt
    );
    input reset;
    input [4:0] Address_ID_EX, Address_EX_MEM, Address_MEM_WB;
    input RegWrite_ID_EX, RegWrite_EX_MEM, RegWrite_MEM_WB;
    input [4:0] Rs, Rt;
    output reg [1:0] Forward_ID_A, Forward_EX_A, Forward_EX_B;
    output reg Forward_ID_B;
    
    always @(*)
        begin
            if(reset) begin
                Forward_ID_A = 2'b00;
                Forward_ID_B = 1'b0;
                Forward_EX_A = 2'b00;
                Forward_EX_B = 2'b00;
            end
            else begin
            // ID Forwarding
                if(RegWrite_EX_MEM && (Address_EX_MEM == Rs) && (Address_EX_MEM != 0)) begin
                    Forward_ID_A = 2'b10;
                end
                else if(RegWrite_MEM_WB && (Address_MEM_WB == Rs) && (Address_MEM_WB != 0)) begin
                    Forward_ID_A = 2'b01;
                end
                else begin
                    Forward_ID_A =2'b00;
                end
                
                if(RegWrite_MEM_WB && (Address_MEM_WB == Rt) && (Address_MEM_WB != 0)) begin
                    Forward_ID_B = 1'b1;
                end
                else begin
                    Forward_ID_B = 1'b0;
                end
            // EX Forwarding
                if(RegWrite_ID_EX && (Address_ID_EX == Rs) && (Address_ID_EX != 0)) begin
                    Forward_EX_A = 2'b10;
                end
                else if(RegWrite_EX_MEM && (Address_EX_MEM == Rs) && (Address_EX_MEM != 0)) begin
                    Forward_EX_A = 2'b01;
                end
                else begin
                    Forward_EX_A = 2'b00;
                end
                
                if(RegWrite_ID_EX && (Address_ID_EX == Rt) && (Address_ID_EX != 0)) begin
                    Forward_EX_B = 2'b10;
                end
                else if(RegWrite_EX_MEM && (Address_EX_MEM == Rt) && (Address_EX_MEM != 0)) begin
                    Forward_EX_B = 2'b01;
                end
                else begin
                    Forward_EX_B =2'b00;
                end
            end
        end
endmodule
