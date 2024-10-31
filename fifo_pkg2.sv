package FIFO_cvg;
	import FIFO_trans::*;
	class FIFO_coverage;
		FIFO_transaction F_cvg_Txn = new();

		function void sample_data(input FIFO_transaction F_txn);
			F_cvg_Txn = F_txn;
			cg.sample;
		endfunction : sample_data

		covergroup cg();
		   write_en_cp: 	coverpoint F_cvg_Txn.wr_en;
		   read_en_cp: 		coverpoint F_cvg_Txn.rd_en;
		   full_cp: 		coverpoint F_cvg_Txn.full;
		   empty_cp: 		coverpoint F_cvg_Txn.empty;
		   almostFull_cp: 	coverpoint F_cvg_Txn.almostfull;
		   almostEmpty_cp: 	coverpoint F_cvg_Txn.almostempty;
		   overflow_cp: 	coverpoint F_cvg_Txn.overflow;
		   underflow_cp: 	coverpoint F_cvg_Txn.underflow;
		   ack_cp: 			coverpoint F_cvg_Txn.wr_ack;
		   
		   full_cross: 		cross write_en_cp, read_en_cp, full_cp;
		   empty_cross: 	cross write_en_cp, read_en_cp, empty_cp;
		   almostF_cross: 	cross write_en_cp, read_en_cp, almostFull_cp;
		   almostE_cross: 	cross write_en_cp, read_en_cp, almostEmpty_cp;
		   ovf_cross: 		cross write_en_cp, read_en_cp, overflow_cp;
		   undf_cross: 		cross write_en_cp, read_en_cp, underflow_cp;
		   ack_cross: 		cross write_en_cp, read_en_cp, ack_cp;
		endgroup : cg

		function new ();
			cg = new;
		endfunction : new
	endclass : FIFO_coverage

endpackage : FIFO_cvg