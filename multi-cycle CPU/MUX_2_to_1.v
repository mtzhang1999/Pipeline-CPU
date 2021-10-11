`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/09 18:17:49
// Design Name: 
// Module Name: MUX_2_to_1
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




module MUX_2_to_1(Select, Data_i1, Data_i2, Data_o);
    //Control Signal
    input Select;
    //Input Data
    input [31:0] Data_i1;
    input [31:0] Data_i2;
    //Output Data
    output reg [31: 0] Data_o;
    
    always@(*) begin
        if(Select == 1'b0) begin
            Data_o = Data_i1;
        end else begin
            Data_o = Data_i2;
        end
    end
    
endmodule
