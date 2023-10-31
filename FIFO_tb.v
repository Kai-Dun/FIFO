`timescale 1ns/10ps
`define CYCLE_TIME 10.0

module FIFO_tb();
	reg clk;
	reg rst_n;
   reg wr_en, rd_en;

   wire fifo_full, fifo_empty;

	reg [15 : 0] wr_data;
   wire[15 : 0] rd_data;
	
	always  #(`CYCLE_TIME/2.0)  clk = ~clk;
	
	
    initial begin
        $fsdbDumpfile("wave.fsdb");
        //$fsdbDumpvars(0, myfifo);
        $fsdbDumpon();
    end
	
	initial begin
		clk = 0;
		rst_n = 1;
		
		wr_en = 0;
      rd_en = 0;
		
		repeat(2) @(negedge clk);  
		rst_n = 0;

		@(negedge clk);  
		rst_n = 1;

		@(negedge clk);  
		wr_data = {$random}%60;
		wr_en = 1;

		repeat(2) @ (negedge clk);
		wr_data = {$random}%60;

		@(negedge clk);
		wr_en = 0;
		rd_en = 1;

		repeat(4) @ (negedge clk);
		rd_en = 0;
		wr_en = 1;
		wr_data = {$random}%60;

		repeat(5) @ (negedge clk);
		wr_data = {$random}%60;

		repeat(2) @ (negedge clk);
		wr_en = 0;
		rd_en = 1;

		repeat(2) @ (negedge clk);
		rd_en = 0;
		wr_en = 1;
		wr_data = {$random}%60;

		repeat(3) @ (negedge clk);
		wr_en = 0;

		#50 $finish;
		end
	
	FIFO 
	#( .WIDTH	(16),
		.DEPTH	(32))
	FIFO_inst
	(
		.clk(clk),
		.rst_n(rst_n),
	//read
		.rd_en(rd_en),
		.rd_data(rd_data),
		.fifo_empty(fifo_empty),
	//write
		.wr_en(wr_en),
		.wr_data(wr_data),
		.fifo_full(fifo_full)
	);


endmodule 

