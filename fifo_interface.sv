interface FIFO_if(
	input bit clk
	);

	parameter FIFO_WIDTH = 16;
	parameter FIFO_DEPTH = 8;

	logic [FIFO_WIDTH-1:0] data_in, data_out;
	logic wr_en, rd_en, rst_n, full, empty, almostfull, almostempty, wr_ack, overflow, underflow;

	modport DUT (input data_in, clk, wr_en, rd_en, rst_n, 
				 output data_out, full, empty, almostfull, almostempty, wr_ack, overflow, underflow);

	modport TEST (input clk, data_out, full, empty, almostfull, almostempty, wr_ack, overflow, underflow,
				  output wr_en, rd_en, rst_n, data_in);

	modport MONITOR (input data_in, data_out, wr_en, rd_en, clk, rst_n, full, empty, almostfull, 
					 almostempty, wr_ack, overflow, underflow);

endinterface