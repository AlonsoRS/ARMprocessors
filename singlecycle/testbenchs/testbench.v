`timescale 1ns/1ns
module testbench;
	reg clk;
	reg reset;
	wire [31:0] WriteData;
	wire [31:0] DataAdr;
	wire MemWrite;
	reg Stop;
	top dut(
		.clk(clk),
		.reset(reset),
		.WriteData(WriteData),
		.DataAdr(DataAdr),
		.MemWrite(MemWrite)
	);
	initial begin
		reset <= 1;
		#(1)
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
				Stop=1;
			end
			/*else if (DataAdr !== 96) begin
				$display("Simulation failed");
				$stop;
			end*/
			
	always@(negedge clk)
	if(Stop)
	 $stop;

	initial begin
    $dumpfile("fpfunctionalitytest.vcd");
	$dumpvars;
	end

endmodule

//iverilog adder.v alu.v arm.v condcheck.v condlogic.v controller.v datapath.v decode.v dmem.v  extend.v  flopenr.v flopr.v  fp16.v fp32.v FPU.v imem.v  mux2.v regfile.v top.v