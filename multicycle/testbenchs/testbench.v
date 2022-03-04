module testbench;
	reg clk;
	reg reset;
	wire [31:0] WriteData;
	wire [31:0] DataAdr;
	wire MemWrite;
	top dut(
		.clk(clk),
		.reset(reset),
		.WriteData(WriteData),
		.Adr(DataAdr),
		.MemWrite(MemWrite)
	);
	initial begin
		reset <= 1;
		#(2)
			;
		reset <= 0;
	end
	always begin
		clk <= 1;
		#(1)
			;
		clk <= 0;
		#(1)
			;
	end
	always @(negedge clk)
		if (MemWrite)
			if ((DataAdr === 100) & (WriteData === 7)) begin
				$display("Simulation succeeded");
				$stop;
			end
			/*else if (DataAdr !== 96) begin
				$display("Simulation failed");
				$stop;
			end*/

initial begin
    $dumpfile("fpfunctionalitytest.vcd");
	$dumpvars;
end


endmodule



//iverilog datapath.v flopenr.v flopr.v mux2.v mux3.v regfile.v extend.v alu.v top.v arm.v mem.v controller.v decode.v condlogic.v condcheck.v mainfsm.v

//>iverilog datapath.v flopenr.v flopr.v mux2.v mux3.v regfile.v extend.v alu.v top.v arm.v mem.v controller.v decode.v condlogic.v condcheck.v mainfsm.v fp16.v fp32.v FPU.v testbench.v