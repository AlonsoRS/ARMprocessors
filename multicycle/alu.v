module alu(a, b, ALUControl, Result, ALUFlags, Result2);
  input [31:0] a, b;
  input [3:0] ALUControl; //
  output reg [31:0] Result;
  output wire [3:0] ALUFlags;
  output reg [31:0] Result2;
  reg [63:0] aux;
  reg signed [63:0] tempAUX;
  reg signed [31:0] tempA;
  reg signed [31:0] tempB;
  reg tempCARRY;
  reg tempOVERFLOW;
  wire [32:0] sum;
  wire neg, zero, carry, overflow;

  
  
  assign sum = a + (ALUControl[0]? ~b:b) + ALUControl[0]; //2's complement

  always @(*)
    begin
      casex (ALUControl[3:0]) 
        4'b000?: Result=sum; //suma o resta
        4'b0010: Result=a&b; //and
				4'b0011: Result=a|b; //or
        4'b 0100: Result = a*b;// mull
        4'b 1000: begin // umull
          aux = a * b; 
          Result2= aux[63:32];
          Result= aux[31:0];
        end 
        4'b 1100: begin // smull
          tempA=a;
          tempB=b;
          tempAUX= tempA*tempB;
          Result2= tempAUX[63:32];
          Result= tempAUX[31:0];
          
        end 

    	endcase    
    end


  always @(*) begin
    if(ALUControl == 4'b 0100 || ALUControl == 4'b1000 || ALUControl == 4'b1100) begin
    tempCARRY=0;
    tempOVERFLOW=0;
    end
    else begin
    tempCARRY = (ALUControl[1]==1'b0) & sum[32];
    tempOVERFLOW = (ALUControl[1]==1'b0) & ~(a[31] ^ b[31] ^ ALUControl[0]) & (a[31] ^ sum[31]);
    end

  end
  
  //flags
  assign neg = Result[31]; // para umull y smull,
  assign zero = (Result == 32'b0); 
  assign carry = tempCARRY;
  assign overflow = tempOVERFLOW;

  
  assign ALUFlags= {neg, zero, carry, overflow};
  
endmodule





//testbench: alu_tb