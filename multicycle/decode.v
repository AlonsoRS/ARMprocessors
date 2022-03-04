module decode (
	clk,
	reset,
	Op,
	Funct,
	Rd,
	FlagW,
	PCS,
	NextPC,
	RegW,
	MemW,
	IRWrite,
	AdrSrc,
	ResultSrc,
	ALUSrcA,
	ALUSrcB,
	ImmSrc,
	RegSrc,
	ALUControl,
	MULL_Identifier,  // nuevo input
	WE4w,
	NewSource,
	IsMul,
	ResultControl,
	FPControl,
	FP_identifier,
	BIT_identifier,
	OP_identifier
);
	input wire clk;
	input wire reset;
	input wire [1:0] Op;
	input wire [5:0] Funct;
	input wire [3:0] Rd;
	output reg [1:0] FlagW;
	output wire PCS;
	output wire NextPC;
	output wire RegW;
	output wire MemW;
	output wire IRWrite;
	output wire AdrSrc;
	output wire [1:0] ResultSrc;
	output wire [1:0] ALUSrcA;
	output wire [1:0] ALUSrcB;
	output wire [1:0] ImmSrc;
	output wire [1:0] RegSrc;
	output reg [3:0] ALUControl; //
	wire Branch;
	wire ALUOp;

	//nuevo
	input wire [3:0] MULL_Identifier; //
	output wire WE4w; //
	output wire NewSource; //
	output wire IsMul; //
	reg [1:0] NewSignals;

	//fp
	output wire ResultControl;
	output reg [1:0] FPControl;
	input wire [4:0] FP_identifier;
	input wire [3:0] BIT_identifier;
	input wire [3:0] OP_identifier;

	// Main FSM
	mainfsm fsm(
		.clk(clk),
		.reset(reset),
		.Op(Op),
		.Funct(Funct),
		.IRWrite(IRWrite),
		.AdrSrc(AdrSrc),
		.ALUSrcA(ALUSrcA),
		.ALUSrcB(ALUSrcB),
		.ResultSrc(ResultSrc),
		.NextPC(NextPC),
		.RegW(RegW),
		.MemW(MemW),
		.Branch(Branch),
		.ALUOp(ALUOp),
		.MULL_Identifier(MULL_Identifier),
		.WE4w(WE4w),
		.ResultControl(ResultControl),
		.FP_identifier(FP_identifier)
	);

	// ADD CODE BELOW
	// Add code for the ALU Decoder and PC Logic.
	// Remember, you may reuse code from previous labs.

	// The ALU Decoder and PC Logic are identical to those in the single-cycle processor.

	// ALU Decoder    <------- Recibe ALUOp de MainFSM

	always @(*)
		if (ALUOp) begin
			if (FP_identifier == 5'b 11111 & !Funct[5]) begin
			case (BIT_identifier)
			4'b 0000: // 32bit
				if(OP_identifier == 4'b1111) //32mul
					FPControl = 2'b11;
				else //32add
					FPControl= 2'b 01;
			4'b 1111: // 16 bit
				if(OP_identifier == 4'b1111) //16mul
					FPControl= 2'b10;
				else//16add
					FPControl= 2'b00;
			default: FPControl = 2'bxx;
			endcase
			FlagW[1]=1'b 0; // nz
			FlagW[0]=1'b 0;	
			end
			else if (MULL_Identifier== 4'b1001 & !Funct[5]) begin
				case (Funct [3:1])
				3'b 000: ALUControl=4'b 0100; //MULL
				3'b 100: ALUControl=4'b 1000; //UMULL
				3'b	110: ALUControl=4'b 1100; //SMULL
				endcase
				FlagW[1]=1'b0; // nz
				FlagW[0]=1'b 0; //cv
			end
			else begin
				case (Funct[4:1])
				4'b0100: ALUControl = 4'b0000;
				4'b0010: ALUControl = 4'b0001;
				4'b0000: ALUControl = 4'b0010;
				4'b1100: ALUControl = 4'b0011;
				default: ALUControl = 4'bxxxx;
			endcase
			FlagW[1] = Funct[0];
			FlagW[0] = Funct[0] & ((ALUControl == 4'b0000) | (ALUControl == 4'b0001));
			end
		end
		else begin
			ALUControl = 4'b0000; //
			FlagW = 2'b00;
		end

	// PC Logic
	// Rd es input del Decoder, Branch y RegW vienen de MainFSM

	assign PCS = ((Rd == 4'b1111) & RegW) | Branch;


	// Add code for the Instruction Decoder (Instr Decoder) below.
	// Recall that the input to Instr Decoder is Op, and the outputs are
	// ImmSrc and RegSrc. We've completed the ImmSrc logic for you.

	// Instr Decoder
	assign RegSrc[1] = (Op == 01);
    assign RegSrc[0] = (Op == 10);
	assign ImmSrc = Op;

	//Nuevo

	always @(*)
		casex (Op)
		2'b00:
			if (MULL_Identifier== 4'b1001 & Funct[3] & !Funct[5] || FP_identifier== 5'b11111) //umull y smull y fp
				NewSignals = 2'b 10;    // nuevo 
			else if (MULL_Identifier== 4'b1001) //mull
				NewSignals = 2'b 11;
			else
				NewSignals = 2'b 00;
		default: NewSignals = 2'b 00; 
		endcase
	assign {NewSource,IsMul} = NewSignals;

endmodule

