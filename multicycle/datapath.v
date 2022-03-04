// ADD CODE BELOW
// Complete the datapath module below for Lab 11.
// You do not need to complete this module for Lab 10.
// The datapath unit is a structural SystemVerilog module. That is,
// it is composed of instances of its sub-modules. For example,
// the instruction register is instantiated as a 32-bit flopenr.
// The other submodules are likewise instantiated. 
module datapath (
	clk,
	reset,
	Adr,
	WriteData,
	ReadData,
	Instr,
	ALUFlags,
	PCWrite,
	RegWrite,
	IRWrite,
	AdrSrc,
	RegSrc,
	ALUSrcA,
	ALUSrcB,
	ResultSrc,
	ImmSrc,
	ALUControl,
	WE4, //
	NewSource,
	IsMul,
	ResultControl,
	FPControl
);
	input wire clk;
	input wire reset;
	output wire [31:0] Adr;
	output wire [31:0] WriteData;
	input wire [31:0] ReadData;
	output wire [31:0] Instr;
	output wire [3:0] ALUFlags;
	input wire PCWrite;
	input wire RegWrite;
	input wire IRWrite;
	input wire AdrSrc;
	input wire [1:0] RegSrc;
	input wire [1:0] ALUSrcA;
	input wire [1:0] ALUSrcB;
	input wire [1:0] ResultSrc;
	input wire [1:0] ImmSrc;
	input wire [3:0] ALUControl;
	wire [31:0] PCNext;
	wire [31:0] PC;
	wire [31:0] ExtImm;
	wire [31:0] SrcA;
	wire [31:0] SrcB;
	wire [31:0] Result;
	wire [31:0] Data;
	wire [31:0] RD1;
	wire [31:0] RD2;
	wire [31:0] A;
	wire [31:0] ALUResult;
	wire [31:0] ALUOut;
	wire [3:0] RA1;
	wire [3:0] RA2;
	//nuevo
	wire [31:0] ALUResult2;
	wire [31:0] Result2;
	wire [3:0] newRA1;
	wire [3:0] newRA2;
	wire [3:0] newRA3;
	input wire WE4;
	input wire IsMul;
	input wire NewSource;
	input wire ResultControl;
	input wire [1:0] FPControl;
	wire [31:0] FPResult;
	wire [31:0] newALUResult;




	// Your datapath hardware goes below. Instantiate each of the 
	// submodules that you need. Remember that you can reuse hardware
	// from previous labs. Be sure to give your instantiated modules 
	// applicable names such as pcreg (PC register), adrmux 
	// (Address Mux), etc. so that your code is easier to understand.

	// ADD CODE HERE

	


	// Instruction Register
	flopenr #(32) IRegister(
		.clk(clk),
		.reset(reset),
		.en(IRWrite),
		.d(ReadData),
		.q(Instr)
	);

	// Data Register
	flopr #(32) DataRegister(   // 
		.clk(clk),
		.reset(reset),
		.d(ReadData),
		.q(Data)
	);


	// PC  
	flopenr #(32) pcreg(
		.clk(clk),
		.reset(reset),
		.en(PCWrite),
		.d(Result),
		.q(PC)
	);

	// mux para escoger Adr
	mux2 #(32) Adrmux(
		.d0(PC),
		.d1(Result),
		.s(AdrSrc),
		.y(Adr)
	);


	// mux para escoger RA1 (igual al single cycle)
	mux2 #(4) ra1mux(
		.d0(Instr[19:16]),
		.d1(4'b1111),
		.s(RegSrc[0]),
		.y(RA1)
	);

	// mux para escoger RA2 (igual single cycle)
	mux2 #(4) ra2mux(
		.d0(Instr[3:0]),
		.d1(Instr[15:12]),
		.s(RegSrc[1]),
		.y(RA2)
		);
	

	//new muxes // -----------------------------------------------------
	mux2  #(4) ra1mux2 (
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

	mux2 #(32) FPmux(
		.d0(ALUResult),
		.d1(FPResult),
		.s(ResultControl),
		.y(newALUResult)

	);


	// Register File
	regfile rf(
		.clk(clk),
		.we3(RegWrite),
		.ra1(newRA1),
		.ra2(newRA2),
		.wa3(newRA3),
		.wd3(Result),
		.r15(Result), 
		.rd1(RD1),
		.rd2(RD2),
		.WE4(WE4),
		.WD4(Result2),
		.WA4(Instr[19:16])
	);

	// A Register
	flopr #(32) Areg(
		.clk(clk),
		.reset(reset),
		.d(RD1),
		.q(A)
	);

	// WriteData Register
	flopr #(32) WDreg(
		.clk(clk),
		.reset(reset),
		.d(RD2),
		.q(WriteData)
	);


	// Extend Imm    <------- same
	extend ext(
		.Instr(Instr[23:0]),
		.ImmSrc(ImmSrc),
		.ExtImm(ExtImm)
	);

	
	// mux para escoger SrcA

	mux3 #(32) muxSrcA(
		.d0(A),
		.d1(PC),
		.d2(ALUOut),
		.s(ALUSrcA),
		.y(SrcA)
	);

	// mux para escoger SrcB

	mux3 #(32) muxSrcB(
		.d0(WriteData),
		.d1(ExtImm),
		.d2(32'b00000000000000000000000000000100),
		.s(ALUSrcB),
		.y(SrcB)
	);

	// alu <------same as in single cycle

	alu alu(
		SrcA,
		SrcB,
		ALUControl,
		ALUResult,
		ALUFlags,
		ALUResult2
	);

	FPU FPU(
		.a(SrcA),
		.b(SrcB),
		.ALUControl(FPControl),
		.Result(FPResult)
	);

	// ALUOut Register
	//assign Result2=ALUResult2;
	// new flopr <---------------
	flopr #(32) Result2ToReg(
		.clk(clk),
		.reset(reset),
		.d(ALUResult2),
		.q(Result2)
	);
	flopr #(32) aluoutreg(
		.clk(clk),
		.reset(reset),
		.d(newALUResult),
		.q(ALUOut)
	);

	// mux para escoger Result

	mux3 #(32) muxResult(
		.d0(ALUOut),
		.d1(Data),
		.d2(newALUResult),
		.s(ResultSrc),
		.y(Result)
	);



endmodule