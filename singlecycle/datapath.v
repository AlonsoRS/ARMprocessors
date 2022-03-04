module datapath (
	clk,
	reset,
	RegSrc,
	RegWrite,
	ImmSrc,
	ALUSrc,
	ALUControl,
	MemtoReg,
	PCSrc,
	ALUFlags,
	PC,
	Instr,
	newALUResult, //nuevo
	WriteData,
	ReadData,
	WE4,
	NewSource,
	IsMul,
	ResultControl,
	FPControl
);
	input wire clk;
	input wire reset;
	input wire [1:0] RegSrc;
	input wire RegWrite;
	input wire [1:0] ImmSrc;
	input wire ALUSrc;
	input wire [3:0] ALUControl;
	input wire MemtoReg;
	input wire PCSrc;
	output wire [3:0] ALUFlags;
	output wire [31:0] PC;
	input wire [31:0] Instr;
	wire [31:0] ALUResult;
	output wire [31:0] WriteData;
	input wire [31:0] ReadData;
	wire [31:0] PCNext;
	wire [31:0] PCPlus4;
	wire [31:0] PCPlus8;
	wire [31:0] ExtImm;
	wire [31:0] SrcA;
	wire [31:0] SrcB;
	wire [31:0] Result;
	wire [3:0] RA1;
	wire [3:0] RA2;
	//nuevo
	wire [3:0] newRA1;
	wire [3:0] newRA2;
	wire [3:0] newRA3;
	wire [31:0] ALUResult2; // nuevo
	input wire  WE4; // nuevo
	wire [31:0] Result2;//
	input wire NewSource; // nuevo
	input wire IsMul; //
	input wire ResultControl;
	input wire [1:0]FPControl;
	wire [31:0] FPResult;
	output wire [31:0] newALUResult;
	//nuevo
	assign Result2 = ALUResult2;
	mux2 #(32) pcmux(
		.d0(PCPlus4),
		.d1(Result),
		.s(PCSrc),
		.y(PCNext)
	);
	flopr #(32) pcreg(
		.clk(clk),
		.reset(reset),
		.d(PCNext),
		.q(PC)
	);
	adder #(32) pcadd1(
		.a(PC),
		.b(32'b100),
		.y(PCPlus4)
	);
	adder #(32) pcadd2(
		.a(PCPlus4),
		.b(32'b100),
		.y(PCPlus8)
	);
	mux2 #(4) ra1mux(
		.d0(Instr[19:16]),
		.d1(4'b1111),
		.s(RegSrc[0]),
		.y(RA1)
	);
	mux2 #(4) ra2mux(
		.d0(Instr[3:0]),
		.d1(Instr[15:12]),
		.s(RegSrc[1]),
		.y(RA2)
	);


	//NUEVO
	mux2 #(32) FPmux(
		.d0(ALUResult),
		.d1(FPResult),
		.s(ResultControl),
		.y(newALUResult)
	);
	mux2 #(4) ra1mux2(
		.d0(RA1),
		.d1(Instr[11:8]),
		.s(NewSource),
		.y(newRA1)
	);
	mux2 #(4) ra2mux2(
		.d0(RA2),
		.d1(Instr[3:0]),
		.s(NewSource),
		.y(newRA2)
	);

	mux2 #(4) ra3mux(
		.d0(Instr[15:12]),
		.d1(Instr[19:16]),
		.s(IsMul),
		.y(newRA3)
	);
	//NUEVO


	regfile rf(
		.clk(clk),
		.we3(RegWrite),
		.ra1(newRA1),
		.ra2(newRA2),
		.wa3(newRA3),
		.wd3(Result),
		.r15(PCPlus8),
		.rd1(SrcA),
		.rd2(WriteData),
		.WE4(WE4),
		.WD4(Result2),
		.WA4(Instr[19:16])
	);
	mux2 #(32) resmux(
		.d0(newALUResult),
		.d1(ReadData),
		.s(MemtoReg),
		.y(Result)
	);
	extend ext(
		.Instr(Instr[23:0]),
		.ImmSrc(ImmSrc),
		.ExtImm(ExtImm)
	);
	mux2 #(32) srcbmux(
		.d0(WriteData),
		.d1(ExtImm),
		.s(ALUSrc),
		.y(SrcB)
	);
	alu alu(
		SrcA,
		SrcB,
		ALUControl,
		ALUResult,
		ALUFlags,
		ALUResult2
	);

	FPU FPU (
		.a(SrcA),
		.b(SrcB),
		.Result(FPResult),
		.ALUControl(FPControl)
	);
endmodule