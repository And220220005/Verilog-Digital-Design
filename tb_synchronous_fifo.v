`timescale 1ns/1ps

module tb_synchronous_fifo;
    reg clk, rst_n, wr_en, rd_en;
    reg [7:0] wr_data;
    wire [7:0] rd_data;
    wire full, empty;

    synchronous_fifo #(.DATA_WIDTH(8), .DEPTH(8)) dut (
        .clk(clk), .rst_n(rst_n),
        .wr_en(wr_en), .rd_en(rd_en),
        .wr_data(wr_data), .rd_data(rd_data),
        .full(full), .empty(empty)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0; rst_n = 0; wr_en = 0; rd_en = 0; wr_data = 0;
        #20 rst_n = 1;

        // Test Write until Full
        repeat (8) begin
            @(posedge clk);
            wr_en = 1; wr_data = wr_data + 8'h11;
        end
        @(posedge clk); wr_en = 0;

        // Test Read until Empty
        repeat (8) begin
            @(posedge clk); rd_en = 1;
        end
        @(posedge clk); rd_en = 0;

        #30 $finish;
    end
endmodule
