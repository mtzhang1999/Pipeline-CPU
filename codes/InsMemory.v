`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/06 11:31:51
// Design Name: 
// Module Name: InsMemory
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


module InsMemory(clk, reset,
                Address, Write_data, Mem_data, MemWrite
    );
    // Input Clock Signals
    input reset;
    input clk;
    // Input Data Signals
    input [31:0] Address;
    input [31:0] Write_data;
    // Input Control Signals
    input MemWrite;
    // Output Data
    output [31:0] Mem_data;
    
//    parameter RAM_SIZE = 256;
    
//    reg [31:0] RAM_data[RAM_SIZE - 1:0];
    
//    assign Mem_data = RAM_data[Address];
    
//    always @(posedge reset or posedge clk) begin
//        if(reset) begin
//            if(MemWrite) begin
//                RAM_data[Address] <= Write_data;
//            end
//        end
//    end
//endmodule

    parameter RAM_SIZE = 256;
    parameter RAM_SIZE_BIT = 8;
	parameter RAM_INST_SIZE = 32;
    
    reg [31:0] RAM_data[RAM_SIZE - 1:0];
    
    assign Mem_data = RAM_data[Address[RAM_SIZE_BIT + 1:2]];
    integer i;
    
    always @(posedge reset or posedge clk) begin
        if(reset) begin

            for (i = RAM_INST_SIZE; i < RAM_SIZE; i = i + 1)
				RAM_data[i] <= 32'h00000000;
        end
            else if(MemWrite) begin
                RAM_data[Address[RAM_SIZE_BIT + 1:2]] <= Write_data;
            end
    end
endmodule
