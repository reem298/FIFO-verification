module FIFO_top ();

	/* Clock Generation */
	bit clk;
	initial begin 
		clk = 0;
		forever 
			#1 clk = ~clk;
	end

	/* Interface Instantiation */
	FIFO_if FIFOif(clk);

	/* DUT Instantiation */ 
	FIFO DUT(FIFOif);

	/* Testbench Instantiation */
	FIFO_tb dutTB(FIFOif);

	/* Monitor Instantiation */
	FIFO_monitor mon(FIFOif);

	// /* Assertions Binding to the Design */
	// bind FIFO FIFO_assertions fifo_assert(FIFOif);

endmodule : FIFO_top