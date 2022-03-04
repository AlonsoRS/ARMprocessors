module fp16(a,b,ALUControl,Result);
    input [15:0] a,b;
    input ALUControl;
    output reg [15:0] Result;
    reg[15:0] exponente_a;
    reg [15:0] mantissa_a;

    reg[15:0] exponente_b;
    reg[15:0] mantissa_b;

    reg[15:0] temp1;
    reg[15:0] temp2;
    reg[999:0] temp4;

    reg[15:0] temp3;
    wire [15:0] inicial;
    wire [15:0] exponente;
    wire [15:0] matissa;

    assign inicial   = 16'b0000010000000000;
    assign exponente = 16'b0111110000000000;
    assign matissa   = 16'b0000001111111111;
always @(*)
    begin
      if(ALUControl) begin
        exponente_a = exponente & a;
        exponente_b = exponente & b;
        exponente_a = exponente_a>>10;
        exponente_b = exponente_b>>10; 
        mantissa_a = a & matissa;
        mantissa_b = b & matissa;
        mantissa_a = mantissa_a | inicial;
        mantissa_b = mantissa_b | inicial;
        temp1 = exponente_a + exponente_b - 4'b1110;
        temp4 = mantissa_a * mantissa_b;
        while(temp4 > 11'b10000000000)begin
          temp4 = temp4 >> 1;
        end
        temp4 = temp4 << 1;
        temp2 = temp4;
        temp2 = temp2 [9:0];
        temp1 = temp1<<10;
        temp2 = temp1 | temp2;
        Result = temp2;
        Result [15] = a[15]^b[15]; // Para saber si es negativo
      end
      else begin
        exponente_a=exponente & a; 
        exponente_b=exponente & b; 
        mantissa_a=a & matissa; 
        mantissa_b=b & matissa;
        exponente_a = exponente_a>>10;
        exponente_b = exponente_b>>10; 
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
        temp3 = temp3>>10; 
        if(temp3>=2) begin
          temp2=temp2>>1;
          temp1=temp1+16'b0000000000000001;
        end
      temp1=temp1<<10;
      temp2=temp2 &matissa;
      temp2=temp1 | temp2;
      Result=temp2;
        end
    end

  
endmodule
