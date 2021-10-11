`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/06 14:07:52
// Design Name: 
// Module Name: PipelineCPU
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


module PipelineCPU(clk, reset,
                uart_on, uart_mode, UART_RAM_id, Rx_Serial, Tx_Serial,
                leds, ssd
    );
    input clk, reset;
    input uart_on, uart_mode, UART_RAM_id, Rx_Serial;
    output [11:0] ssd;
    output [7:0] leds;
    output Tx_Serial;
    
    wire [31:0] PC;
    wire [31:0] PC_o; //pc_on_ break
    wire [31:0] Ins;
    wire IRQ;
    wire [31:0] PC_Next; // pc_plus_4
    wire [31:0] PC_Jump; // pc_next
    wire IntExc;
    wire BranchHazard, JumpHazard, DataHazard;
    wire [1:0] RegDst;
    wire ALUSrcA, ALUSrcB;
    wire ExtOp, LuiOp;
    wire [3:0] ALUOp;
    wire Branch;
    wire [2:0] BranchOp;
    wire MemWrite, MemRead, RegWrite;
    wire [1:0] MemtoReg;
    wire [2:0] PCSource;
    wire [31:0] ImmExt;
    wire [31:0] In1;
    wire [31:0] In2;
    wire [31:0] Result;
    wire [1:0]Forward_ID_A;
    wire Forward_ID_B;
    wire [1:0] Forward_EX_A, Forward_EX_B;
    wire [31:0] Rs_id, Rt_id;
    wire [31:0] Rs, Rt;
    wire [31:0] Rs_updated, Rt_updated;
    wire [31:0] MemOut;
    wire [31:0] Branch_id, Jump_id;
    
    assign PC_Next = PC + 32'd4;
    
    assign ImmExt = LuiOp ? {Reg_IF_to_ID.Ins[15:0], 16'h0000}:
                    {ExtOp ? {16{Reg_IF_to_ID.Ins[15]}}:
                    16'h0000, Reg_IF_to_ID.Ins[15:0]};

    assign Rs_id =
                Forward_ID_A == 2'b00 ? Rs:
                Forward_ID_A == 2'b10 ? Reg_EX_to_MEM.ALUOut:
                Reg_MEM_to_WB.Mem_data;                   
    
    assign Rt_id = Forward_ID_B ? Reg_MEM_to_WB.Mem_data : Rt;
    
    assign Rs_updated =
            Reg_ID_to_EX.ForwardingA == 2'b00 ? Reg_ID_to_EX.Rs:
            Reg_ID_to_EX.ForwardingA == 2'b10 ? Reg_EX_to_MEM.ALUOut:
            Reg_MEM_to_WB.Mem_data;
    
    assign Rt_updated =
            Reg_ID_to_EX.ForwardingB == 2'b00 ? Reg_ID_to_EX.Rt:
            Reg_ID_to_EX.ForwardingB == 2'b10 ? Reg_EX_to_MEM.ALUOut:
            Reg_MEM_to_WB.Mem_data;
    
    assign Branch_id = Reg_ID_to_EX.PC + {Reg_ID_to_EX.Imm[29:0], 2'b00};
    assign Jump_id = {Reg_IF_to_ID.PC[31:28], Reg_IF_to_ID.Ins[25:0], 2'b00};
    
    assign PC_Jump = BranchHazard ? Branch_id:
                PCSource == 3'b000 ? PC_Next:
                PCSrouce == 3'b001 ? Jump_id:
                PCSource == 3'b010 ? Rs_updated:
                PCSrouce == 3'b011 ? 32'h8000_0004:
                32'h8000_0008;
    
    wire [4:0] Write_Address =
                (RegDst == 2'b11) ? 5'd26:
                (RegDst == 2'b00) ? Reg_IF_to_ID.Ins[20:16]:
                (RegDst == 2'b01) ? Reg_IF_to_ID.Ins[15:11]:
                5'd31;
    
    wire [31:0] Mem_data =
                        Reg_EX_to_MEM.MemtoReg == 2'b00 ? Reg_EX_to_MEM.ALUOut:
                        Reg_EX_to_MEM.MemtoReg == 2'b01 ? MemOut:
                        Reg_EX_to_MEM.PC;
    
    ProgramCounter ProgramCounter(.clk(clk), .reset(reset),
                    .PCWrite(IntExc || (~DataHazard)), .PC_i(PC_Jump), .PC(PC));

    RegisterFile RegisterFile(.reset(reset), .clk(clk),
                    .RegWrite(Reg_MEM_to_WB.RegWrite), 
                    .Read_register1(Reg_IF_to_ID.Ins[25:21]), .Read_register2(Reg_IF_to_ID.Ins[20:16]),
                    .Write_register(Reg_MEM_to_WB.Addr), .Write_data(Reg_MEM_to_WB.Mem_data),
                    .Read_data1(Rs), .Read_data2(Rt));                    
    
    Reg_IF_to_ID Reg_IF_to_ID(.clk(clk), .reset(reset),
                    .Flush(IntExc || BranchHazard || JumpHazard), .PC_i(PC_Next), .wr_EN(IntExc || (~DataHazard)), .Ins_i(Ins));

    Reg_ID_to_EX Reg_ID_to_EX(.clk(clk),.reset(reset),
                    .Flush(BranchHazard || DataHazard), .PC_i(IntExc ? PC_o: Reg_IF_to_ID.PC),
                    .ALUSrcA_i(ALUSrcA), .ALUSrcB_i(ALUSrcB), .ALUOp_i(ALUOp),
                    .Shamt_i(Reg_IF_to_ID.Ins[10:6]), .Funct_i(Reg_IF_to_ID.Ins[5:0]),
                    .Addr_i(Write_Address), .Imm_i(ImmExt), .Branch_i(Branch), .BranchOp_i(BranchOp),
                    .MemtoReg_i(MemtoReg), .MemRead_i(MemRead), .MemWrite_i(MemWrite), .RegWrite_i(RegWrite),
                    .Rs_i(Rs_id), .Rd_i(Rt_id), .ForwardingA_i(Forward_EX_A), .ForwardingB_i(Forward_EX_B));                        

    Reg_EX_to_MEM Reg_EX_to_MEM(.clk(clk), .reset(reset),
                    .ALUOut_i(Result), .Rt_i(Rt_updated), .PC_i(Reg_ID_to_EX.PC), .Addr_i(Reg_ID_to_EX.Addr),
                    .MemtoReg_i(MemtoReg), .MemRead_i(MemRead), .MemWrite_i(MemWrite), .RegWrite_i(RegWrite));
                    
    Reg_MEM_to_WB Reg_MEM_to_WB(.clk(clk), .reset(reset),
                    .Mem_Data_i(Mem_data), .Addr_i(Reg_EX_to_MEM.Addr),
                    .MemtoReg_i(Reg_EX_to_MEM.MemtoReg), .RegWrite_i(Reg_EX_to_MEM.RegWrite));
    
     //  ALU Control
    wire [4:0] ALUConf;
    wire Sign;
    
    ALUControl ALUControl(.ALUOp(ALUOp),.Funct(Funct),.ALUConf(ALUConf),.Sign(Sign));
    
    //  ALU
    
    assign In1 = Reg_ID_to_EX.ALUSrcA ? {27'h0_0000, Reg_ID_to_EX.Shamt} : Rs_updated;
    assign In2 = Reg_ID_to_EX.ALUSrcB ? Reg_ID_to_EX.Imm : Rt_updated;
    
    ALU ALU(.ALUConf(ALUConf), .Sign(Sign), .In1(In1), .In2(In2), .Result(Result));
    
    BranchHazard Branch_Hazard(.In1(Rs_updated), .In2(Rt_updated), .Branch(Reg_ID_to_EX.Branch), .BranchOp(Reg_ID_to_EX.BranchOp), .BranchHazard(BranchHazard));
    
    Hazard Hazard(.HazardControl(DataHazard), .PCSource(PCSrouce),
            .Address_ID_EX(Reg_ID_to_EX.Addr), .MemRead_ID_EX(Reg_ID_to_EX.MemRead), .RegWrite_ID_EX(Reg_ID_to_EX.RegWrite),
            .Address_EX_MEM(Reg_EX_to_MEM.Addr), .MemRead_EX_MEM(Reg_EX_to_MEM.MemRead),
            .Rs(Reg_IF_to_ID.Ins[25:21]), .Rt(Reg_IF_to_ID.Ins[20:16]));
            
    ForwardUnit ForwardUnit(.reset(reset),
                .Address_ID_EX(Reg_ID_to_EX.Addr), .RegWrite_ID_EX(Reg_ID_to_EX.RegWrite),
                .Address_EX_MEM(Reg_EX_to_MEM.Addr), .RegWrite_EX_MEM(Reg_EX_to_MEM.RegWrite),
                .Address_MEM_WB(Reg_MEM_to_WB.Addr), .RegWrite_MEM_WB(Reg_MEM_to_WB.RegWrite),
                .Forward_ID_A(Forward_ID_A), .Forward_ID_B(Forward_ID_B), .Forward_EX_A(Forward_EX_A), .Forward_EX_B(Forward_EX_B),
                .Rs(Reg_IF_to_ID.Ins[25:21]), .Rt(Reg_IF_to_ID.Ins[20:16]));
    
    Bus Bus(.clk(clk), .reset(reset),
            .IRQ(IRQ), .leds(leds), .ssd(ssd), .PC({1'b0, PC[30:0]}),
            .MemRead(Reg_EX_to_MEM.MemRead), .MemWrite(Reg_EX_to_MEM.MemWrite), .Address(Reg_EX_to_MEM.ALUOut), .Write_data(Reg_EX_to_MEM.Rt),
            .Ins(Ins), .Read_data(MemOut),
            .UART_ON(UART_ON), .UART_Mode(UART_Mode), .UART_RAM_id(UART_RAM_id), .Rx_Serial(Rx_Serial), .Tx_Serial(Tx_Serial));                    
                        
    Controller Controller(.OpCode(Reg_IF_to_ID.Ins[31:26]), .Funct(Reg_IF_to_ID.Ins[5:0]),
                .MemWrite(MemWrite), .MemRead(MemRead),
                .MemtoReg(MemtoReg), .RegDst(RegDst), .RegWrite(RegWrite), .ExtOp(ExtOp), .LuiOp(LuiOp),
                .ALUSrcA(ALUSrcA), .ALUSrcB(ALUSrcB), .ALUOp(ALUOp), .PCSource(PCSource),
                .Branch(Branch), .BranchOp(BranchOp),
                .IRQ(IRQ), .Kenel(Reg_IF_to_ID.PC[31] || PC[31]), .IntExc(IntExc), .JumpHazard(JumpHazard));                    

    PC Pc(.reset(reset), .clk(clk), .PCWrite(~(Branch || BranchHazard || JumpHazard || DataHazard)), .PC_i(PC), .PC_o(PC_o));
endmodule
