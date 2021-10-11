`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Class: Fundamentals of Digital Logic and Processor
// Designer: Shulin Zeng
// 
// Create Date: 2021/04/30
// Design Name: MultiCycleCPU
// Module Name: MultiCycleCPU
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

module MultiCycleCPU (reset, clk);
    //Input Clock Signals
    input reset;
    input clk;

    //--------------Your code below-----------------------
    //Control
    wire PCWriteCond;
    wire PCWrite;
    wire IorD;
    wire MemWrite;
    wire MemRead;
    wire IRWrite;
    wire [1:0] RegDst;
    wire [1:0] MemtoReg;
    wire RegWrite;
    wire [1:0] ALUSrcA;
    wire ExtOp;
    wire LuiOp;
    wire [1:0] ALUSrcB;
    wire [1:0] PCSource;
    wire [3:0] ALUOp;
    //  Data Memory
    wire [31:0] Mem_data;
    wire [31:0] Address;
     //  IR
    wire [5:0]  OpCode;
    wire [4:0]  rs;
    wire [4:0]  rt;
    wire [4:0]  rd;
    wire [4:0]  Shamt;
    wire [5:0]  Funct;
    //  RegisterFile
    wire [4:0] Write_register;
    wire [31:0] Read_data1;
    wire [31:0] Read_data2;
    wire [31:0] Write_data;
    //  Memory Data Register
    wire [31:0] MDR_data_o;
    // ImmProcess
    wire [31:0] ImmExtOut;
    wire [31:0] ImmExtShift;
    wire [15:0] Immediate;
    assign Immediate = {rd, Shamt, Funct};
    
    InstReg InstReg(.reset(reset), .clk(clk), .IRWrite(IRWrite), .Instruction(Mem_data), 
            .OpCode(OpCode), .rs(rs), .rt(rt), .rd(rd), .Shamt(Shamt), .Funct(Funct));
    RegisterFile RegisterFile (.reset(reset), .clk(clk), .RegWrite(RegWrite), .Read_register1(rs), .Read_register2(rt), 
            .Write_register(Write_register), .Write_data(Write_data), .Read_data1(Read_data1), .Read_data2(Read_data2));

    wire [31:0] A_data_o;
    wire [31:0] B_data_o;
    
    RegTemp RegTempA(.reset(reset),.clk(clk),.Data_i(Read_data1),.Data_o(A_data_o));
    RegTemp RegTempB(.reset(reset),.clk(clk),.Data_i(Read_data2),.Data_o(B_data_o));
    
    InstAndDataMemory InstAndDataMemory(.reset(reset), .clk(clk), .Address(Address), 
            .Write_data(B_data_o), .MemRead(MemRead), .MemWrite(MemWrite), .Mem_data(Mem_data));
    RegTemp RegTemp1(.reset(reset),.clk(clk),.Data_i(Mem_data),.Data_o(MDR_data_o));
    ImmProcess ImmProcess(.ExtOp(ExtOp), .LuiOp(LuiOp), .Immediate(Immediate), .ImmExtOut(ImmExtOut), .ImmExtShift(ImmExtShift));
    
    //  ALU Control
    wire [4:0] ALUConf;
    wire Sign;
    
    ALUControl ALUControl(.ALUOp(ALUOp),.Funct(Funct),.ALUConf(ALUConf),.Sign(Sign));
    
    //  ALU
    wire Zero;
    wire [31:0] In1;
    wire [31:0] In2;
    wire [31:0] Result;
    
    ALU ALU(.ALUConf(ALUConf), .Sign(Sign), .In1(In1), .In2(In2), .Zero(Zero), .Result(Result));
    
    // ALUOut
    wire [31:0] ALUOut;
    RegTemp RegTemp2(.reset(reset), .clk(clk), .Data_i(Result), .Data_o(ALUOut));
    
    //  Address Register
    wire [31:0] PC_i;
    wire [31:0] PC_o;
    wire PCwrite;
    assign PCwrite = PCWrite || Zero && PCWriteCond;
    
    PC PC(.reset(reset), .clk(clk), .PCWrite(PCwrite), .PC_i(PC_i), .PC_o(PC_o));
    
    //MUX
    wire [31:0] ExtShamt = {27'b0, Shamt};
    
    MUX_2_to_1 MUX_IorD(.Select(IorD), .Data_i1(PC_o), .Data_i2(ALUOut), .Data_o(Address));
    MUX_A MUX_SrcA(.Select(ALUSrcA), .Data_i1(PC_o), .Data_i2(A_data_o), .Data_i3(6'b0), .Data_i4(ExtShamt), .Data_o(In1));
    MUX_4_to_1 MUX_SrcB(.Select(ALUSrcB), .Data_i1(B_data_o), .Data_i2(32'h4), .Data_i3(ImmExtOut), .Data_i4(ImmExtShift), .Data_o(In2));
    MUX_4_to_1 MUX_Mem_to_Reg(.Select(MemtoReg), .Data_i1(MDR_data_o), .Data_i2(ALUOut), .Data_i3(PC_o), .Data_i4(ImmExtOut), .Data_o(Write_data));
    MUX_4_to_1 MUX_PCsource(.Select(PCSource), .Data_i1(Result), .Data_i2(ALUOut), .Data_i3({PC_o[31:28], rs, rt, rd, Shamt, Funct, 2'b00}), .Data_i4(A_data_o), .Data_o(PC_i));
    MuxRegDst MuxRegDst(.Select(RegDst), .Data_i1(rt), .Data_i2(rd), .Data_i3(5'b11111), .Data_i4(5'b0), .Data_o(Write_register));
    
    Controller Controller(.reset(reset), .clk(clk), .OpCode(OpCode), .Funct(Funct), .PCWrite(PCWrite), .PCWriteCond(PCWriteCond),
            .IorD(IorD), .MemWrite(MemWrite), .MemRead(MemRead), .IRWrite(IRWrite), .MemtoReg(MemtoReg), .RegDst(RegDst), .RegWrite(RegWrite),
            .ExtOp(ExtOp), .LuiOp(LuiOp), .ALUSrcA(ALUSrcA), .ALUSrcB(ALUSrcB), .ALUOp(ALUOp), .PCSource(PCSource));

    //--------------Your code above-----------------------

endmodule
