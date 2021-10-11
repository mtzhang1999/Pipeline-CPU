`timescale 1ns / 1ps


module Controller(OpCode, Funct,
                MemWrite, MemRead,
                MemtoReg, RegDst, RegWrite, ExtOp, LuiOp,
                ALUSrcA, ALUSrcB, ALUOp, PCSource,
                Branch, BranchOp,
                IRQ, Kenel, IntExc, JumpHazard);

    //Input Signals
    input [5:0] OpCode;
    input [5:0] Funct;
    input IRQ;
    input Kenel;
    //Output Control Signals
    output reg Branch;
    output reg [2:0] BranchOp;
    output reg MemWrite;
    output reg MemRead;
    output reg [1:0] MemtoReg;
    output reg [1:0] RegDst;
    output reg RegWrite;
    output reg ExtOp;
    output reg LuiOp;
    output reg ALUSrcA;
    output reg ALUSrcB;
    output reg [3:0] ALUOp;
    output reg [2:0] PCSource;
    output wire JumpHazard;
    output wire IntExc; // flag for Interrupt and Exception
    
    // R-type: sll, srl, sra, add, addu, sub, subu, and, or, xor, nor, slt, sltu, jr, jalr
    // I-type: lw, sw, bltz, beq, bne, bgtz, addi, addiu, slti, sltiu, lui
    // J-type: j, jal
    
    // Instructions not included
    wire InsNotIn;
    assign InsNotIn = ~((OpCode >= 6'h01 && OpCode <=6'h0c) || (OpCode == 6'h0f || OpCode == 6'h23 || OpCode == 6'h2b) ||
    (OpCode == 6'h00 && (Funct == 6'h00 || Funct == 6'h02 || Funct == 6'h03 || Funct == 6'h08 || Funct == 6'h09 || Funct == 6'h2a || Funct == 6'h2b ||
    (Funct >= 6'h20 && Funct <= 6'h27))));
    
    // Interrupt and Exception Handling
    assign IntExc = (IRQ || InsNotIn) && (~Kenel);
    
    // flag for JumpHazard
    assign JumpHazard = PCSource == 3'b001 || PCSource == 3'b010;

    always @(*)
        begin
            // PCSource
            PCSource = (~Kenel && IRQ) ? 3'b011 : (~Kenel && InsNotIn) ? 3'b100 :
            (OpCode == 6'h02 || OpCode == 6'h03) ? 3'b001 : (OpCode == 6'h00 && (Funct == 6'h08 || Funct == 6'h09)) ? 3'b010 : 3'b000; // j, jr, jal, jalr
            // Branch
            Branch = (~IntExc) && (OpCode == 6'h01 || (OpCode >= 6'h04 && OpCode <= 6'h07));
            // BranchOp
            BranchOp[2:0] =
		    (OpCode == 6'h04)? 3'b001:
		    (OpCode == 6'h05)? 3'b010:
		    (OpCode == 6'h06)? 3'b011:
		    (OpCode == 6'h07)? 3'b100:
		    (OpCode == 6'h01)? 3'b101:
		    3'b000;
		    // ALUSrc
		    ALUSrcA = OpCode == 6'h00 && (Funct == 5'h00 || Funct == 5'h02 || Funct == 5'h03);
		    ALUSrcB = ~(OpCode == 6'h00 || OpCode == 6'h04);
		    // ALUSrcB = OpCode == 6'h23 || OpCode == 6'h2b || OpCode == 6'h0f || OpCode == 6'h08 || OpCode == 6'h09 || OpCode == 6'h0c || OpCode == 6'h0a || OpCode == 6'h0b;
            // RegDst
            RegDst[1:0] =
            IntExc ? 2'b11 :
            (OpCode == 6'h03) ? 2'b10 : // jal
            (OpCode == 6'h00) ? 2'b01 : // R-type
             2'b00; // I-type
//            RegDst[1:0] =
//		    IntExc ? 2'b11:
//		    (OpCode == 6'h23 || OpCode == 6'h0f || OpCode == 6'h08 || OpCode == 6'h09 || OpCode == 6'h0c || OpCode == 6'h0a || OpCode == 6'h0b)? 2'b00:
//		    (OpCode == 6'h03)? 2'b10:
//		    2'b01;
            // MemWrite
            MemWrite = OpCode ==  6'h2b && (~IntExc);
            // MemRead
            MemRead = OpCode == 6'h23 && (~IntExc);
            // MemtoReg
            MemtoReg[1:0] =
		    (OpCode == 6'h23) ? 2'b01:
		    (IntExc || (OpCode == 6'h03 || (OpCode == 6'h00 && Funct == 5'h09))) ? 2'b10: 
		    2'b00;
		    // RegWrite
		    RegWrite = IntExc || ~((OpCode == 6'h02 || OpCode == 6'h04 || OpCode == 6'h2b) || (OpCode == 6'h00 && Funct == 6'h08));
		    // RegWrite = ~(~IntExc &&(OpCode == 6'h2b || OpCode == 6'h02 || OpCode == 6'h01 || (OpCode >= 6'h04 && OpCode <= 6'h07) || (OpCode == 6'h00 && Funct == 5'h08)));
            // ALUOp
            ALUOp[3] = OpCode[0];
//            ALUOp[2:0] =
//            (OpCode == 6'h00) ? 3'b010:
//            (OpCode == 6'h0c) ? 3'b100:
//            (OpCode == 6'h0d) ? 3'b101:
//            (OpCode == 6'h0a || OpCode == 6'h0b) ? 3'b110:
//            3'b000;
            ALUOp[2:0] = 
		    (OpCode == 6'h00)? 3'b010: 
		    (OpCode == 6'h04)? 3'b001: 
		    (OpCode == 6'h0c)? 3'b100: 
		    (OpCode == 6'h0a || OpCode == 6'h0b)? 3'b101: 
		    3'b000;
            // ExtOp
            ExtOp = ~(OpCode == 6'h0c || OpCode == 6'h0d); 
            // LuiOp
            LuiOp = OpCode == 6'h0f;
        end
endmodule
            
    

