`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Class: Fundamentals of Digital Logic and Processor
// Designer: Shulin Zeng
// 
// Create Date: 2021/04/30
// Design Name: MultiCycleCPU
// Module Name: Controller
// Project Name: Multi-cycle-cpu
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


module Controller(reset, clk, OpCode, Funct, 
                PCWrite, PCWriteCond, IorD, MemWrite, MemRead,
                IRWrite, MemtoReg, RegDst, RegWrite, ExtOp, LuiOp,
                ALUSrcA, ALUSrcB, ALUOp, PCSource);
    //Input Clock Signals
    input reset;
    input clk;
    //Input Signals
    input  [5:0] OpCode;
    input  [5:0] Funct;
    //Output Control Signals
    output reg PCWrite;
    output reg PCWriteCond;
    output reg IorD;
    output reg MemWrite;
    output reg MemRead;
    output reg IRWrite;
    output reg [1:0] MemtoReg;
    output reg [1:0] RegDst;
    output reg RegWrite;
    output reg ExtOp;
    output reg LuiOp;
    output reg [1:0] ALUSrcA;
    output reg [1:0] ALUSrcB;
    output reg [3:0] ALUOp;
    output reg [1:0] PCSource;
    //--------------Your code below----------------------- 
    // state transition   
    reg [4:0] currentstate;
    reg [4:0] nextstate;
    
    parameter S0 = 5'b00000;
    parameter S1 = 5'b00001;
    parameter S2 = 5'b00010;
    parameter S3 = 5'b00011;
    parameter S4 = 5'b00100;
    parameter S5 = 5'b00101;
    parameter S6 = 5'b00110;
    parameter S7 = 5'b00111;
    parameter S8 = 5'b01000;
    parameter S9 = 5'b01001;
    parameter S10 = 5'b01010;
    parameter S11 = 5'b01011;
    parameter S12 = 5'b01100;
    parameter S13 = 5'b01101;
    parameter S14 = 5'b01110;
    parameter S15 = 5'b01111;
    parameter S16 = 5'b10000;
      
    always@(posedge reset or posedge clk)begin
        if(reset)begin
            currentstate <= S0;
        end
        else begin
            currentstate <= nextstate;
        end
    end
    
    always@(*)begin
        case(currentstate)
            S0: nextstate <= S1;
            S1: begin
                    case(OpCode)
                        6'b100011:nextstate <= S2;
                        6'b101011:nextstate <= S2;
                        6'b001111:nextstate <= S3;
                        6'b001000:nextstate <= S6;
                        6'b001001:nextstate <= S6;
                        6'b001100:nextstate <= S6;
                        6'b001010:nextstate <= S6;
                        6'b001011:nextstate <= S6;
                        6'b000100:nextstate <= S7;
                        6'b000010:nextstate <= S8;
                        6'b000011:nextstate <= S9;
                        6'b000000: begin
                            case(Funct)
                                6'b100000:nextstate <= S4;
                                6'b100001:nextstate <= S4;
                                6'b100010:nextstate <= S4;
                                6'b100011:nextstate <= S4;
                                6'b100100:nextstate <= S4;
                                6'b100101:nextstate <= S4;
                                6'b100110:nextstate <= S4;
                                6'b100111:nextstate <= S4;
                                6'b101010:nextstate <= S4;
                                6'b101011:nextstate <= S4;
                                6'b111111:nextstate <= S4;
                                6'b000000:nextstate <= S5;
                                6'b000010:nextstate <= S5;
                                6'b000011:nextstate <= S5; 
                                6'b001000:nextstate <= S10;
                                6'b001001:nextstate <= S11;
                            endcase
                        end
                    endcase
                end
            S2:begin
                    case(OpCode)
                        6'b100011:nextstate <= S12;
                        6'b101011:nextstate <= S13;
                    endcase
                end
                S3:nextstate <= S0;
                S4:nextstate <= S15;
                S5:nextstate <= S15;
                S6:nextstate <= S16;
                S7:nextstate <= S0;
                S8:nextstate <= S0;
                S9:nextstate <= S8;
                S10:nextstate <= S0;
                S11:nextstate <= S10;
                S12:nextstate <= S14;
                S13:nextstate <= S0;
                S14:nextstate <= S0;
                S15:nextstate <= S0;
                S16:nextstate <= S0;
            endcase
    end

    always@(currentstate)begin
        case(currentstate)
            S0:begin
                    MemRead = 1;
                    MemWrite = 0;
                    RegWrite = 0;
                    IRWrite = 1;
                    PCWriteCond = 0;
                    PCWrite = 1;
                    IorD = 0;
                    ALUSrcA = 2'b00;
                    ALUSrcB =2'b01;
                    PCSource = 2'b00;
                    
                end
            S1:begin
                    IRWrite = 0;
                    PCWrite = 0;
                    ALUSrcA = 2'b00;
                    ALUSrcB = 2'b11;
                    LuiOp = 0;
                    ExtOp = 1;
                end
            S2:begin
                    ALUSrcA = 2'b01;
                    ALUSrcB = 2'b10;
                end
            S3:begin
                    MemtoReg = 2'b11;
                    RegWrite = 1;
                    RegDst = 2'b00;
                    LuiOp = 1; 
                end
            S4:begin
                    ALUSrcA = 2'b01;
                    ALUSrcB = 2'b00;
                end
            S5:begin
                    ALUSrcA = 2'b11;
                    ALUSrcB = 2'b00;
                    RegDst = 2'b01;
                end
            S6:begin
                    ALUSrcA = 2'b01;
                    ALUSrcB = 2'b10;
                    LuiOp = 0;
                    ExtOp = 1;
                end
            S7:begin
                    PCWriteCond = 1;
                    ALUSrcA = 2'b01;
                    ALUSrcB = 2'b00;
                    PCSource = 2'b01;
                end
            S8:begin
                    RegWrite = 0;
                    PCWrite = 1;
                    PCSource = 2'b10;
                end
            S9:begin
                    MemtoReg = 2'b10;
                    RegWrite = 1;
                    RegDst = 2'b10;
                end
            S10:begin
                    RegWrite = 0;
                    PCWrite = 1;
                    PCSource = 2'b11;
                end
            S11:begin
                    MemtoReg = 2'b10;
                    RegWrite = 1;
                    RegDst = 2'b01;
                end
            S12:begin
                    MemRead = 1;
                    IorD = 1;
                end
            S13:begin
                    MemWrite = 1;
                    IorD = 1;
                end
            S14:begin
                    MemtoReg = 2'b00;
                    RegWrite = 1;
                    RegDst = 2'b00;
                end
            S15:begin
                    MemtoReg = 2'b01;
                    RegWrite = 1;
                    RegDst = 2'b01;
                end
            S16:begin
                    MemtoReg = 2'b01;
                    RegWrite = 1;
                    RegDst = 2'b00;
                end
        endcase
    end
    //--------------Your code above-----------------------


    //ALUOp
    always@(*) begin
        ALUOp[3] = OpCode[0];
        if(currentstate == S0 || currentstate == S1) begin
            ALUOp[2:0] = 3'b000;
        end else if(OpCode == 6'h00) begin 
            ALUOp[2:0] = 3'b010;
        end else if(OpCode == 6'h04) begin
            ALUOp[2:0] = 3'b001;
        end else if(OpCode == 6'h0c) begin
            ALUOp[2:0] = 3'b100;
        end else if(OpCode == 6'h0a || OpCode == 6'h0b) begin
            ALUOp[2:0] = 3'b101;
        end else begin
            ALUOp[2:0] = 3'b000;
        end
    end

endmodule
