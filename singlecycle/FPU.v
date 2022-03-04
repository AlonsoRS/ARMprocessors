module FPU (a, b, ALUControl, Result);
  input wire [31:0] a, b;
  input wire [1:0] ALUControl;
  output wire [31:0] Result;
  wire [31:0]Result32;
  wire [15:0]tempResult16;
  wire [31:0] Result16;

  assign Result16={16'b0000000000000000,tempResult16};
  fp fp32(
    .a(a),
    .b(b),
    .ALUControl(ALUControl[1]),
    .Result(Result32)
    );
  fp16 fp16(
    .a(a),
    .b(b),
    .ALUControl(ALUControl[1]),
    .Result(tempResult16)   
  );

  mux2 #(32) decisivo(
    .d0(Result16),
    .d1(Result32),
    .s(ALUControl[0]),
    .y(Result)
  );
endmodule
