////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: FIFO Design 
// 
////////////////////////////////////////////////////////////////////////////////
module FIFO(FIFO_if.DUT fifoIF);

	logic [fifoIF.FIFO_WIDTH-1:0] data_in, data_out;
	logic wr_en, rd_en, rst_n, full, empty, almostfull, almostempty, wr_ack, overflow, underflow;

	assign clk 					= fifoIF.clk;
	assign rst_n 				= fifoIF.rst_n;
	assign wr_en 				= fifoIF.wr_en;
	assign rd_en 				= fifoIF.rd_en;
	assign data_in 				= fifoIF.data_in;
	assign fifoIF.full 			= full;
	assign fifoIF.empty 		= empty;
	assign fifoIF.almostfull 	= almostfull;
	assign fifoIF.almostempty 	= almostempty;
	assign fifoIF.wr_ack 		= wr_ack;
	assign fifoIF.overflow 		= overflow;
	assign fifoIF.underflow 	= underflow;
	assign fifoIF.data_out 		= data_out;
 
	localparam max_fifo_addr = $clog2(fifoIF.FIFO_DEPTH);

	reg [fifoIF.FIFO_WIDTH-1:0] mem [fifoIF.FIFO_DEPTH-1:0];

	reg [max_fifo_addr-1:0] wr_ptr, rd_ptr;
	reg [max_fifo_addr:0] count;

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			wr_ptr <= 0;
		end
		else if (wr_en && (count < fifoIF.FIFO_DEPTH)) begin
			mem[wr_ptr] <= data_in;
			wr_ack <= 1;
			wr_ptr <= wr_ptr + 1;
		end
		else begin 
			wr_ack <= 0; 
			if (full & wr_en)
				overflow <= 1;
			else
				overflow <= 0;
		end
	end

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			rd_ptr <= 0;
		end
		else if (rd_en && count) begin
			data_out <= mem[rd_ptr];
			rd_ptr <= rd_ptr + 1;
		end
	end

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			count <= 0;
		end
		else begin
			if	( ({wr_en, rd_en} == 2'b10) && !full) 
				count <= count + 1;
			else if ( ({wr_en, rd_en} == 2'b01) && !empty) begin
				count <= count - 1;
			end
		end
	end

	assign full = (count == fifoIF.FIFO_DEPTH)? 1 : 0;
	assign empty = (count == 0)? 1 : 0;
	assign underflow = (empty && rd_en)? 1 : 0; 
	assign almostfull = (count == fifoIF.FIFO_DEPTH-1)? 1 : 0; 
	assign almostempty = (count == 1)? 1 : 0;

	/* ASSERTIONS */
	`ifdef SIM
	property reset;
		@(posedge clk)
		!rst_n |-> (!count && !rd_ptr && !wr_ptr)
	endproperty

	property full_flag;
		@(posedge clk)
		(count == fifoIF.FIFO_DEPTH) |-> full;
	endproperty

	property empty_flag;
		@(posedge clk)
		!count |-> empty;
	endproperty

	property almostfull_flag;
		@(posedge clk)
		(count == fifoIF.FIFO_DEPTH-1) |-> almostfull;
	endproperty

	property almostempty_flag;
		@(posedge clk)
		(count == 1) |-> almostempty;
	endproperty

	property overflow_flag;
		@(posedge clk)
		(full & wr_en) |=> overflow;
	endproperty

	property underflow_flag;
		@(posedge clk)
		(empty && rd_en) |-> underflow;
	endproperty

	property wrAck_flag;
		@(posedge clk)
		(wr_en && (count < fifoIF.FIFO_DEPTH)) |=> wr_ack;
	endproperty

	assert property(reset);
	assert property(full_flag);
	assert property(empty_flag);
	assert property(almostfull_flag);
	assert property(almostempty_flag);
	assert property(overflow_flag);
	assert property(underflow_flag);
	assert property(wrAck_flag);

	cover property(reset);
	cover property(full_flag);
	cover property(empty_flag);
	cover property(almostfull_flag);
	cover property(almostempty_flag);
	cover property(overflow_flag);
	cover property(underflow_flag);
	cover property(wrAck_flag);
	`endif

endmodule