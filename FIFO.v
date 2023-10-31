module FIFO 
#(	parameter WIDTH = 16,
	parameter DEPTH = 32
	)
(
	clk,
	rst_n,
//read
	rd_en,
	rd_data,
	fifo_empty,
//write
	wr_en,
	wr_data,
	fifo_full
);

input clk, rst_n;
//read
input rd_en;
output reg[WIDTH - 1 : 0]rd_data;
output fifo_empty;
//write
input wr_en;
input [WIDTH - 1 : 0]wr_data;
output fifo_full;


reg [$clog2(DEPTH) : 0] wr_ptr, rd_ptr;
reg [WIDTH - 1 : 0] MEM[DEPTH - 1 : 0];

integer i;

//ptr
always @(posedge clk, negedge rst_n)begin
	if(~rst_n)
		wr_ptr <= 0;
	else begin
		if(wr_en && ~fifo_full)
			wr_ptr <= wr_ptr + 1;
		else
			wr_ptr <= wr_ptr;
	end
end

always @(posedge clk, negedge rst_n)begin
	if(~rst_n)
		rd_ptr <= 0;
	else begin
		if(rd_en && ~fifo_empty)
			rd_ptr <= rd_ptr + 1;
		else
			rd_ptr <= rd_ptr;
	end
end

//write data
always @(posedge clk, negedge rst_n)begin
	if(~rst_n)begin
		for(i = 0 ;i<DEPTH;i=i+1 )begin
			MEM[i] <= 0;
		end
	end
	else begin
		if(wr_en && ~fifo_full)
			MEM[wr_ptr] <= wr_data;
		else 
			MEM[wr_ptr] <= MEM[wr_ptr];
	end
end

//read data
always @(posedge clk, negedge rst_n)begin
	if(~rst_n)begin
		rd_data <= 0;
	end
	else begin
		if(rd_en && ~fifo_empty)
			rd_data <= MEM[rd_ptr];
		else 
			rd_data <= rd_data;
	end
end

//cnt
assign fifo_empty = (wr_ptr == rd_ptr);
assign fifo_full = (wr_ptr[$clog2(DEPTH)] != rd_ptr[$clog2(DEPTH)] && wr_ptr[$clog2(DEPTH) - 1 : 0] == rd_ptr[$clog2(DEPTH) - 1 : 0]);


endmodule 
