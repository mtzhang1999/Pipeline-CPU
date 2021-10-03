module test_cpu(clk, reset,
         uart_on, uart_mode, uart_ram_id, Rx_Serial,
         led, ssd, Tx_Serial
    );
    input clk;
    input reset;
    input uart_on;
    input uart_mode;
    input uart_ram_id;
    input Rx_Serial;
    output [7:0] led;
    output [11:0] ssd;
    output Tx_Serial;

    PipelineCPU PipelineCPU_1(.clk(clk), .reset(reset),
                .uart_on(uart_on), .uart_mode(uart_mode), .UART_RAM_id(uart_ram_id), .Rx_Serial(Rx_Serial), .Tx_Serial(Tx_Serial),
                .leds(led), .ssd(ssd));
    endmodule