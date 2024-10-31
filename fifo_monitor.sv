import FIFO_trans::*;
import FIFO_cvg::*;
import FIFO_scrbrd::*;
import shared_pkg::*;

module FIFO_monitor (FIFO_if.MONITOR fifoIF);

	logic clk;
	assign clk = fifoIF.clk;

	FIFO_transaction obj_trans;
	FIFO_coverage obj_cvg;
	FIFO_scoreboard obj_scr;
	
	initial begin 
		obj_trans = new;
		obj_cvg = new;
		obj_scr = new;
		forever @(negedge clk) begin 
			obj_trans.rst_n 		= fifoIF.rst_n;
			obj_trans.wr_en 		= fifoIF.wr_en;
			obj_trans.rd_en 		= fifoIF.rd_en;
			obj_trans.data_in 		= fifoIF.data_in;
			obj_trans.full 			= fifoIF.full;
			obj_trans.empty 		= fifoIF.empty;
			obj_trans.almostfull 	= fifoIF.almostfull;
			obj_trans.almostempty 	= fifoIF.almostempty;
			obj_trans.overflow 		= fifoIF.overflow;
			obj_trans.underflow 	= fifoIF.underflow;
			obj_trans.wr_ack 		= fifoIF.wr_ack;
			obj_trans.data_out 		= fifoIF.data_out;
			
			fork
				/* Process 1 */
				begin 
					obj_cvg.sample_data(obj_trans);
				end

				/* Process 2 */
				begin 
					obj_scr.check_data(obj_trans);
				end
			join

			if(test_finished) begin 
				$display("Correct Count: %d", correct_count);
				$display("Error Count:   %d", error_count);
				$stop;
			end
		end
	end

endmodule : FIFO_monitor