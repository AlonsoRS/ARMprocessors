module controller (
	clk,
	reset,
	Instr,
	ALUFlags,
	RegSrc,
	RegWrite,
	ImmSrc,
	ALUSrc,
	ALUControl,
	MemWrite,
	MemtoReg,
	PCSrc,
	WE4,
	NewSource,
	IsMul,
	ResultControl,
	FPControl
);
	input wire clk;
	input wire reset;
	input wire [31:0] Instr; // paso la instr completa
	input wire [3:0] ALUFlags;
	output wire [1:0] RegSrc;
	output wire RegWrite;
	output wire [1:0] ImmSrc;
	output wire ALUSrc;
	output wire [3:0] ALUControl;
	output wire MemWrite;
	output wire MemtoReg;
	output wire PCSrc;
	// nuevo
	output wire WE4;//
	output wire NewSource;//
	output wire IsMul;
	//
	wire [1:0] FlagW;
	wire PCS;
	wire RegW;
	wire MemW;
	//nuevo
	wire WE4w;
	output wire ResultControl;
	output wire [1:0] FPControl;

	decode dec(
		.Op(Instr[27:26]),
		.Funct(Instr[25:20]),
		.Rd(Instr[15:12]),
		.FlagW(FlagW),
		.PCS(PCS),
		.RegW(RegW),
		.MemW(MemW),
		.MemtoReg(MemtoReg),
		.ALUSrc(ALUSrc),
		.ImmSrc(ImmSrc),
		.RegSrc(RegSrc),
		.ALUControl(ALUControl),
		.MULL_Identifier(Instr[7:4]), // nuevo
		.WE4w(WE4w),
		.NewSource(NewSource),
		.IsMul(IsMul),
		.FPControl (FPControl),
		.ResultControl(ResultControl),
		.BIT_identifier(Instr[19:16]),
		.OP_identifier(Instr[7:4]),
		.FP_identifier(Instr[24:20])
	);
	condlogic cl(
		.clk(clk),
		.reset(reset),
		.Cond(Instr[31:28]),
		.ALUFlags(ALUFlags),
		.FlagW(FlagW),
		.PCS(PCS),
		.RegW(RegW),
		.MemW(MemW),
		.PCSrc(PCSrc),
		.RegWrite(RegWrite),
		.MemWrite(MemWrite),
		.WE4w(WE4w),
		.WE4(WE4)
	);
endmodule