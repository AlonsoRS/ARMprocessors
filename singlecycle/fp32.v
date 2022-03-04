module fp(a, b, ALUControl, Result);
  input [31:0] a, b;
  input ALUControl; // 0 = Suma // 1 = MultiplicaciÃ³n
  output reg [31:0] Result;

  reg[31:0] exponente_a;
  reg [31:0] mantissa_a;

  reg[31:0] exponente_b;
  reg[31:0] mantissa_b;

  reg[31:0] temp1;
  reg[999:0] temp4;
  reg[31:0] temp3;
  reg[31:0] temp2;
  wire [31:0] inicial;
  wire [31:0] exponente;
  wire [31:0] matissa;

  assign inicial   = 32'b00000000100000000000000000000000;
  assign exponente = 32'b01111111100000000000000000000000;
  assign matissa   = 32'b00000000011111111111111111111111;

  always @(*)
    begin
      if(ALUControl) begin
        exponente_a = exponente & a;
        exponente_b = exponente & b;
        exponente_a = exponente_a>>23;
        exponente_b = exponente_b>>23; 
        mantissa_a = a & matissa;
        mantissa_b = b & matissa;
        mantissa_a = mantissa_a | inicial;
        mantissa_b = mantissa_b | inicial;
        temp1 = exponente_a + exponente_b - 7'b1111110;
        temp4 = mantissa_a * mantissa_b;
        while(temp4 > 24'b100000000000000000000000)begin
          temp4 = temp4 >> 1;
        end
        temp4 = temp4 << 1;
        temp2 = temp4;
        temp2 = temp2 [22:0];
        temp1 = temp1<<23;
        temp2 = temp1 | temp2;
        Result = temp2;
        Result [31] = a[31]^b[31]; // Para saber si es negativo
      end 
      else begin
        exponente_a=exponente & a; 
        exponente_b=exponente & b; 
        mantissa_a=a & matissa; 
        mantissa_b=b & matissa;
        exponente_a = exponente_a>>23;
        exponente_b = exponente_b>>23; 
        mantissa_a = mantissa_a | inicial;
        mantissa_b = mantissa_b | inicial;
        if(exponente_a>exponente_b)begin
            temp1=exponente_a-exponente_b;
            mantissa_b=mantissa_b>>temp1;
            temp2=mantissa_a+mantissa_b;
            temp1=exponente_a;
        end
        else begin
          temp1=exponente_b-exponente_a;
          mantissa_a=mantissa_a>>temp1;
          temp2=mantissa_a+mantissa_b;
          temp1=exponente_b;
        end
        temp3 = temp2;
        temp3 = temp3>>23; 
        if(temp3>=2) begin
          temp2=temp2>>1;
          temp1=temp1+32'b00000000000000000000000000000001;
        end
      temp1=temp1<<23;
      temp2=temp2 & matissa;
      temp2=temp1 | temp2;
      Result=temp2;
        end
    
    end

  
endmodule