module arm (
	clk,
	reset,
	PC,
	Instr,
	MemWrite,
	newALUResult,
	WriteData,
	ReadData
);
	input wire clk;
	input wire reset;
	output wire [31:0] PC;
	input wire [31:0] Instr;
	output wire MemWrite;
	//output wire [31:0] ALUResult;
	output wire [31:0] WriteData;
	input wire [31:0] ReadData;
	wire [3:0] ALUFlags;
	wire RegWrite;
	wire ALUSrc;
	wire MemtoReg;
	wire PCSrc;
	wire [1:0] RegSrc;
	wire [1:0] ImmSrc;
	wire [3:0] ALUControl;
	wire WE4;// nuevo
	wire NewSource;// nuevo
	wire IsMul; // nuevo
	output wire [31:0] newALUResult;
	wire ResultControl;
	wire [1:0]FPControl;

	controller c(
		.clk(clk),
		.reset(reset),
		.Instr(Instr[31:0]),
		.ALUFlags(ALUFlags),
		.RegSrc(RegSrc),
		.RegWrite(RegWrite),
		.ImmSrc(ImmSrc),
		.ALUSrc(ALUSrc),
		.ALUControl(ALUControl),
		.MemWrite(MemWrite),
		.MemtoReg(MemtoReg),
		.PCSrc(PCSrc),
		.WE4(WE4),
		.NewSource(NewSource),
		.IsMul(IsMul),
		.ResultControl(ResultControl),
		.FPControl(FPControl)		
	);
	datapath dp(
		.clk(clk),
		.reset(reset),
		.RegSrc(RegSrc),
		.RegWrite(RegWrite),
		.ImmSrc(ImmSrc),
		.ALUSrc(ALUSrc),
		.ALUControl(ALUControl),
		.MemtoReg(MemtoReg),
		.PCSrc(PCSrc),
		.ALUFlags(ALUFlags),
		.PC(PC),
		.Instr(Instr),
		.newALUResult(newALUResult),
		.WriteData(WriteData),
		.ReadData(ReadData),
		.WE4(WE4),
		.NewSource(NewSource), //
		.IsMul(IsMul),
		.ResultControl(ResultControl),
		.FPControl(FPControl)
	);
endmodule