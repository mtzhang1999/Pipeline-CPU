`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/06 10:49:37
// Design Name: 
// Module Name: Bus
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


module Bus(clk, reset,
        IRQ, leds, ssd, PC,
        MemRead, MemWrite, Address, Write_data,
        Ins, Read_data,
        UART_ON, UART_Mode, UART_RAM_id, Rx_Serial, Tx_Serial
    );
    input clk, reset;
    input [31:0] PC, Address, Write_data;
    input MemRead, MemWrite;
    input UART_ON, UART_Mode, UART_RAM_id, Rx_Serial;
    output IRQ;
    output [31:0] Ins;
    output wire [31:0] Read_data;
    output wire [7:0] leds;
    output wire [11:0] ssd;
    output Tx_Serial;
    
    parameter IM_SIZE_BIT = 8;
    parameter DM_SIZE_BIT = 8;
    parameter MAX_SIZE_BIT = 8;
    
    wire [DM_SIZE_BIT - 1:0] uart_addr;
    wire recv_flag;
    wire [31:0] recv_data;
    wire DataMem_Done, InsMem_Done;
    wire [31:0] read_data_DM;
    wire [31:0] read_data_Timer;
    wire [31:0] read_data_LED;
    wire [31:0] read_data_SSD;
    wire [31:0] read_data_ST;
    
    wire DataMem_EN;
    wire LED_EN;
    wire SSD_EN;
    wire UART_EN;

    
    assign UART_EN = (reset && UART_ON);
    assign DataMem_EN = (Address <= 32'h0000_07FF);
    assign LED_EN = (Address == 32'h4000_000C);
    assign SSD_EN = (Address == 32'h4000_0010);

    
    assign Read_data = (MemRead ? (DataMem_EN ? read_data_DM : LED_EN ? read_data_LED : SSD_EN ? read_data_SSD : read_data_ST) : 32'h0000_0000);
    assign leds = reset ? {InsMem_Done, DataMem_Done, 6'b000000} : read_data_LED[7:0];
    assign ssd = read_data_SSD[11:0];
    
    DataMemory #(.RAM_SIZE_BIT(DM_SIZE_BIT)) DataMem(.clk(clk), .reset(reset),
                .Address(UART_EN ? uart_addr[DM_SIZE_BIT - 1:0] : Address[DM_SIZE_BIT + 1:2]),
                .Write_data(UART_EN ? recv_data : Write_data),
                .Mem_data(read_data_DM),
                .MemWrite((DataMem_EN && MemWrite) || (UART_EN && UART_RAM_id == 1 && recv_flag)));
                
    InsMemory #(.RAM_SIZE_BIT(IM_SIZE_BIT)) InsMem(.clk(clk), .reset(reset),
                .Address(UART_EN ? uart_addr[IM_SIZE_BIT - 1:0] : PC[IM_SIZE_BIT + 1:2]),
                .Write_data(recv_data),
                .Mem_data(Ins),
                .MemWrite(UART_EN && UART_RAM_id == 0 && recv_flag));
    
    UART_Control #(.IM_SIZE_BIT(IM_SIZE_BIT), .DM_SIZE_BIT(DM_SIZE_BIT), .MAX_SIZE_BIT(MAX_SIZE_BIT))
     UART_Control(.clk(clk), .en(UART_EN), .mode(uart_mode), .RAM_id(UART_RAM_id),
            .Rx_Serial(Rx_Serial), .data_to_send(read_data_DM), .Address(uart_addr),
            .on_received(recv_flag), .recv_data(recv_data), .Tx_Serial(Tx_Serial),
            .IM_Done(InsMem_Done), .DM_Done(DataMem_Done));
                
    SysClkCounter SysclkCounter(.clk(clk), .reset(reset), .count(read_data_ST));
    
    SSD SSD(.clk(clk), .reset(reset),
            .ssd(read_data_SSD), .MemWrite(SSD_EN && MemWrite), .Write_data(Write_data));
           
    LEDs LED(.clk(clk), .reset(reset),
            .leds(read_data_LED), .MemWrite(LED_EN && MemWrite), .Write_data(Write_data));
                    
endmodule
