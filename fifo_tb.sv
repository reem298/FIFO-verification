import FIFO_trans::*;
import FIFO_cvg::*;
import FIFO_scrbrd::*;
import shared_pkg::*;

module FIFO_tb (FIFO_if.TEST fifoIF);

	localparam TESTS = 100;

	logic [fifoIF.FIFO_WIDTH-1:0] data_in, data_out;
	logic wr_en, rd_en, rst_n, full, empty, almostfull,
		  almostempty, wr_ack, overflow, underflow;

	assign clk 					= fifoIF.clk;
	assign full 				= fifoIF.full;
	assign empty 				= fifoIF.empty;
	assign almostfull 			= fifoIF.almostfull;
	assign almostempty 			= fifoIF.almostempty;
	assign wr_ack 				= fifoIF.wr_ack;
	assign overflow 			= fifoIF.overflow;
	assign underflow 			= fifoIF.underflow;
	assign data_out 			= fifoIF.data_out;
	assign fifoIF.rst_n 		= rst_n;
	assign fifoIF.wr_en 		= wr_en;
	assign fifoIF.rd_en 		= rd_en;
	assign fifoIF.data_in 		= data_in;

	FIFO_transaction F_rand = new;

	initial begin 
		rst_n = 0;
		#20 	rst_n = 1;

		for(int i=0;i<TESTS;i++) begin 
			assert(F_rand.randomize());
			@(negedge clk);
			rst_n = F_rand.rst_n; 	wr_en = F_rand.wr_en; 	rd_en = F_rand.rd_en;
			data_in = F_rand.data_in;
		end

		test_finished = 1;
	end

endmodule : FIFO_tb