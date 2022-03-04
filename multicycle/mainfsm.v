module mainfsm (
    clk,
    reset,
    Op,
    Funct,
    IRWrite,
    AdrSrc,
    ALUSrcA,
    ALUSrcB,
    ResultSrc,
    NextPC,
    RegW,
    MemW,
    Branch,
    ALUOp,
    MULL_Identifier,
    WE4w,
    ResultControl,
    FP_identifier
);
    input wire clk;
    input wire reset;
    input wire [1:0] Op;
    input wire [5:0] Funct;
    output wire IRWrite;
    output wire AdrSrc;
    output wire [1:0] ALUSrcA;
    output wire [1:0] ALUSrcB;
    output wire [1:0] ResultSrc;
    output wire NextPC;
    output wire RegW;
    output wire MemW;
    output wire Branch;
    output wire ALUOp;
    reg [3:0] state;
    reg [3:0] nextstate;
    reg [14:0] controls;
    localparam [3:0] FETCH = 0;
    localparam [3:0] BRANCH = 9;
    localparam [3:0] DECODE = 1;
    localparam [3:0] EXECUTEI = 7;
    localparam [3:0] EXECUTER = 6;
    localparam [3:0] MEMADR = 2;
    localparam [3:0] UNKNOWN = 10;
    localparam [3:0] ALUWB = 8;
    localparam [3:0] MEMRD = 3;
    localparam [3:0] MEMWR = 5;
    localparam [3:0] MEMWB = 4;

    //nuevo

    input wire [3:0] MULL_Identifier;
    output wire WE4w;
    output wire ResultControl;
    input wire [4:0] FP_identifier;

    

    // state register
    always @(posedge clk or posedge reset)
        if (reset)
            state <= FETCH;
        else
            state <= nextstate;
    

    // ADD CODE BELOW
    // Finish entering the next state logic below.  We've completed the 
    // first two states, FETCH and DECODE, for you.

    // next state logic
    always @(*)
        casex (state)
            FETCH: nextstate = DECODE;
            DECODE:
                case (Op)
                    2'b00:
                        if (Funct[5])
                            nextstate = EXECUTEI;
                        else
                            nextstate = EXECUTER;
                    2'b01: nextstate = MEMADR;
                    2'b10: nextstate = BRANCH;
                    default: nextstate = UNKNOWN;
                endcase
            EXECUTER:
                nextstate = ALUWB;
            EXECUTEI:
                nextstate = ALUWB;
            MEMADR:
                if(Funct[0])
                    nextstate=MEMRD;
                else
                    nextstate=MEMWR;
            MEMRD:
                nextstate=MEMWB;
            
            default: nextstate = FETCH;
        endcase

    // ADD CODE BELOW
    // Finish entering the output logic below.  We've entered the
    // output logic for the first two states, FETCH and DECODE, for you.

    // state-dependent output logic

    //NUEVO: se anadio un bit
    always @(*)
        case (state)
            FETCH: controls = 15'b100010100110000;
            DECODE: controls = 15'b000000100110000;
            // 0 0 0 0 0 0 10 01 10 0;
            EXECUTER: 
            if(FP_identifier == 5'b 11111 & !Funct[5] )
                controls = 15'b000000100000101;
            else
                controls = 15'b000000100000100;
            // 0 0 0 0 0 0 10 00 00 1;
            EXECUTEI: controls = 15'b000000100001100;
            // 0 0 0 0 0 0 10 00 01 1;
            ALUWB: 
                if(MULL_Identifier== 4'b1001 & Funct[3] & !Funct[5])
                    controls = 15'b000100000000110;
                else
                    controls = 15'b000100000000100;
            // 0 0 0 0 0 0 10 00 00 1;
            MEMADR: controls = 15'b000000100001000;
            // 0 0 0 0 0 0 10 00 01 0;
            MEMWR: controls =  15'b001001000001000;
            //0 0 1 0 0 1 00 00 01 0;
            MEMRD: controls = 15'b000001000001000;

            MEMWB: controls = 15'b000101010001000;
            // 0 0 0 0 0 1 00 00 01 0;

            BRANCH: controls = 15'b010000101001000;
            // 0 0 0 0 0 0 10 01 10 0;

            default: controls = 15'bxxxxxxxxxxxxxxx;
        endcase
    assign {NextPC, Branch, MemW, RegW, IRWrite, AdrSrc, ResultSrc, ALUSrcA, ALUSrcB, ALUOp, WE4w,ResultControl} = controls;
endmodule