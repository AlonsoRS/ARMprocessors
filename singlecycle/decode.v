module decode (
	Op,
	Funct,
	Rd,
	FlagW,
	PCS,
	RegW,
	MemW,
	MemtoReg,
	ALUSrc,
	ImmSrc,
	RegSrc,
	ALUControl,
	MULL_Identifier,  // nuevo input
	WE4w, //
	NewSource, //
	IsMul, //
	FP_identifier,
	FPControl,
	ResultControl,
	BIT_identifier,
	OP_identifier
);
	input wire [1:0] Op;
	input wire [5:0] Funct;
	input wire [3:0] Rd;
	input wire [3:0] MULL_Identifier; //nuevo
	output reg [1:0] FlagW;
	output wire PCS;
	output wire RegW;
	output wire MemW;
	output wire MemtoReg;
	output wire ALUSrc;
	output wire WE4w; //nueva senal
	output wire NewSource; //nuevo
	output wire [1:0] ImmSrc;
	output wire [1:0] RegSrc;
	output reg [3:0] ALUControl;
	reg [13:0] controls;
	wire Branch;
	wire ALUOp;
	//nuevo
	output wire IsMul; //
	output wire ResultControl;//
	output reg [1:0] FPControl;
	input wire [4:0] FP_identifier;
	input wire [3:0] BIT_identifier;
	input wire [3:0] OP_identifier;



	always @(*)
		casex (Op)
			2'b00:
				if (Funct[5])
					controls = 14'b 00001010010000;
				else if(FP_identifier == 5'b11111)
					controls= 14'b 00000010010101;
				else if (MULL_Identifier== 4'b1001 & Funct[3]) //umull y smull
					controls = 14'b 00000010011100;    // ALUOPnuevo 
				else if (MULL_Identifier== 4'b1001) //mull
					controls = 14'b 00000010010110;
				else
					controls = 14'b 00000010010000;
			2'b01:
				if (Funct[0])
					controls = 14'b 00011110000000;
				else
					controls = 14'b 10011101000000;
			2'b10: controls = 14'b 01101000100000;
			default: controls = 14'b xxxxxxxxxxxxxx; 
		endcase
	assign {RegSrc, ImmSrc, ALUSrc, MemtoReg, RegW, MemW, Branch, ALUOp,WE4w,NewSource,IsMul,ResultControl} = controls;
	always @(*)
		if (FP_identifier == 5'b 11111) begin
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
		end
		else if (MULL_Identifier== 4'b1001) begin
			case (Funct [3:1])
			3'b 000: ALUControl=4'b 0100; //MULL
			3'b 100: ALUControl=4'b 1000; //UMULL
			3'b	110: ALUControl=4'b 1100; //SMULL
			endcase
			FlagW[1]=Funct[0]; // nz
			FlagW[0]=1'b 0; //cv
		end
		else if (ALUOp) begin
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
		else begin
			ALUControl = 4'b0000; //
			FlagW = 2'b00;
		end
	assign PCS = ((Rd == 4'b1111) & RegW) | Branch;
endmodule