module controller_tb;
    reg clk;
    reg reset;
    reg [31:12] Instr;
    reg [3:0] ALUFlags;
    wire PCWrite;
    wire MemWrite;
    wire RegWrite;
    wire IRWrite;
    wire AdrSrc;
    wire [1:0] RegSrc;
    wire [1:0] ALUSrcA;
    wire [1:0] ALUSrcB;
    wire [1:0] ResultSrc;
    wire [1:0] ImmSrc;
    wire [1:0] ALUControl;
    wire [1:0] FlagW;
    wire PCS;
    wire NextPC;
    wire RegW;
    wire MemW;
	reg notInstr;
    controller c(
        .clk(clk),
        .reset(reset),
        .Instr(Instr[31:12]),
        .ALUFlags(ALUFlags),
        .PCWrite(PCWrite),
        .MemWrite(MemWrite),
        .RegWrite(RegWrite),
        .IRWrite(IRWrite),
        .AdrSrc(AdrSrc),
        .RegSrc(RegSrc),
        .ALUSrcA(ALUSrcA),
        .ALUSrcB(ALUSrcB),
        .ResultSrc(ResultSrc),
        .ImmSrc(ImmSrc),
        .ALUControl(ALUControl)
    );
	always begin
        clk <= 1;
        #(1)
            ;
        clk <= 0;
        #(1)
            ;
    end
    initial begin
        reset <= 1;
        #(1)
            ;
        reset <= 0;
    end

    always @(negedge clk)begin
        Instr='hE5802; // Se declara la instrucción
        ALUFlags=0;
        $display(Instr[20]);
        #10
		$finish;
    end

initial begin
    $dumpfile("Sim.vcd");
    $dumpvars;
    end

endmodule