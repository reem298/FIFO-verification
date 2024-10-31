package FIFO_scrbrd;
	import FIFO_trans::*;
	import shared_pkg::*;

	class FIFO_scoreboard;
		int wr_ptr, rd_ptr;
		int count;
		bit [FIFO_WIDTH-1:0] mem [FIFO_DEPTH-1:0];

		logic [FIFO_WIDTH-1:0] data_out_ref;
		logic full_ref, empty_ref, almostfull_ref, almostempty_ref, wr_ack_ref, overflow_ref, underflow_ref;

		function void check_data (input FIFO_transaction F_chk);
			reference_model(F_chk);

			$display(" \n");
			
			if(F_chk.data_out != data_out_ref) begin 
				error_count++;
				$display("Data Out Error\nExpected: %h\nGot: %h", data_out_ref, F_chk.data_out, $time());
			end
			else 
				correct_count++;

			if(F_chk.full != full_ref) begin 
				error_count++;
				$display("Full Error\nExpected: %h\nGot: %h", full_ref, F_chk.full, $time());
			end
			else 
				correct_count++;

			if(F_chk.empty != empty_ref) begin 
				error_count++;
				$display("Empty Error", $time());
			end
			else 
				correct_count++;

			if(F_chk.almostfull != almostfull_ref) begin 
				error_count++;
				$display("Almost Full Error", $time());
			end
			else 
				correct_count++;

			if(F_chk.almostempty != almostempty_ref) begin 
				error_count++;
				$display("Almost Empty Error", $time());
			end
			else 
				correct_count++;

			if(F_chk.overflow != overflow_ref) begin 
				error_count++;
				$display("Overflow Error", $time());
			end
			else 
				correct_count++;

			if(F_chk.underflow != underflow_ref) begin 
				error_count++;
				$display("Underflow Error", $time());
			end
			else 
				correct_count++;

			if(F_chk.wr_ack != wr_ack_ref) begin 
				error_count++;
				$display("Write Ack Error", $time());
			end
			else 
				correct_count++;
		endfunction : check_data

		function void reference_model (input FIFO_transaction F_chk_ref);

			fork
				begin 
					if (!F_chk_ref.rst_n)
						wr_ptr = 0;
					else if (F_chk_ref.wr_en && count < FIFO_DEPTH) begin
						mem[wr_ptr] = F_chk_ref.data_in;
						wr_ack_ref = 1;
						wr_ptr = wr_ptr + 1;
					end
					else begin 
						wr_ack_ref = 0; 
						if (full_ref & F_chk_ref.wr_en)
							overflow_ref = 1;
						else
							overflow_ref = 0;
					end
				end

				begin 
					if (!F_chk_ref.rst_n)
						rd_ptr = 0;
					else if (F_chk_ref.rd_en && count != 0) begin
						data_out_ref = mem[rd_ptr];
						rd_ptr = rd_ptr + 1;
					end
				end

				/********************/

				begin 
					if (!F_chk_ref.rst_n) begin
						count = 0;
					end
					else begin
						if	( ({F_chk_ref.wr_en, F_chk_ref.rd_en} == 2'b10) && !full_ref) 
							count = count + 1;
						else if ( ({F_chk_ref.wr_en, F_chk_ref.rd_en} == 2'b01) && !empty_ref)
							count = count - 1;
					end
				end
			join

			full_ref = (count == FIFO_DEPTH)? 1 : 0;
			empty_ref = (count == 0)? 1 : 0;
			underflow_ref = (empty_ref && F_chk_ref.rd_en)? 1 : 0; 
			almostfull_ref = (count == FIFO_DEPTH-1)? 1 : 0; 
			almostempty_ref = (count == 1)? 1 : 0;

		endfunction : reference_model
	endclass : FIFO_scoreboard
endpackage : FIFO_scrbrd

//$display("\n%h\n%h\n%h\n%h\n%h\n%h\n%h\n%h\n", data_out_ref, full_ref, empty_ref, almostfull_ref, almostempty_ref, wr_ack_ref, overflow_ref, underflow_ref);
