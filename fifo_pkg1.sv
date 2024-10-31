package FIFO_trans;

	parameter FIFO_WIDTH = 16;
	parameter FIFO_DEPTH = 8;

	class FIFO_transaction;
		/* Defining the Design I/O as Class Properties */
		rand bit [FIFO_WIDTH-1:0] data_in; 
		rand bit wr_en, rd_en, rst_n;
		bit full, empty, almostfull, almostempty, wr_ack, overflow, underflow; 
		bit [FIFO_WIDTH-1:0] data_out;

		int WR_EN_ON_DIST = 70, RD_EN_ON_DIST = 30;

		/* Constraint Blocks */
		constraint rstConstr {
			rst_n dist {0 := 4, 1 := 96};
		}

		constraint wrEnable {
			wr_en dist {1 := WR_EN_ON_DIST, 0 := 100-WR_EN_ON_DIST};
		}

		constraint rdEnable {
			rd_en dist {1 := RD_EN_ON_DIST, 0 := 100-RD_EN_ON_DIST};
		}

	endclass : FIFO_transaction

endpackage : FIFO_trans