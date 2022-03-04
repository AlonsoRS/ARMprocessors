module condlogic (
	clk,
	reset,
	Cond,
	ALUFlags,
	FlagW,
	PCS,
	NextPC,
	RegW,
	MemW,
	PCWrite,
	RegWrite,
	MemWrite,
	WE4,
	WE4w
);
	input wire clk;
	input wire reset;
	input wire [3:0] Cond;
	input wire [3:0] ALUFlags;
	input wire [1:0] FlagW;
	input wire PCS;
	input wire NextPC;
	input wire RegW;
	input wire MemW;
	output wire PCWrite;
	output wire RegWrite;
	output wire MemWrite;
	wire [1:0] FlagWrite;
	wire [3:0] Flags;
	wire CondEx;
	wire CondEx2;
	wire impro;
	//nuevo
	input wire WE4w;
	output wire WE4;

	flopenr #(2) flagreg1(
		.clk(clk),
		.reset(reset),
		.en(FlagWrite[1]),
		.d(ALUFlags[3:2]),
		.q(Flags[3:2])
	);
	flopenr #(2) flagreg0(
		.clk(clk),
		.reset(reset),
		.en(FlagWrite[0]),
		.d(ALUFlags[1:0]),
		.q(Flags[1:0])
	);

	flopr #(1) ff(
        clk,
        reset,
        CondEx,
        CondEx2
    );


	condcheck cc(
		.Cond(Cond),
		.Flags(Flags),
		.CondEx(CondEx)
	);

	assign FlagWrite = FlagW & {2 {CondEx}};
	assign RegWrite = RegW & CondEx2;
	assign MemWrite = MemW & CondEx2;
	assign impro = PCS & CondEx2;
	assign PCWrite = NextPC | impro;
	assign WE4= WE4w & CondEx2;



endmodule

