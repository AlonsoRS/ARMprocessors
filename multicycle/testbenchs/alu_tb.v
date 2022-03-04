`timescale 1ns/1ns
module alu_tb();
  reg [31:0] a,b;
  wire [3:0] ALUFlags;
  reg [3:0] ALUControl;
  reg clk, reset;
  reg [101:0] testvector[1000:0];
  wire [31:0] Result;
  reg [31:0] Result_expected; // to compare y output
  reg [3:0] ALUFlags_expected;
  reg [31:0] vectornum; // check testvector number
  reg [31:0] errors; // error counter
  
  alu alu_dut(.a(a), .b(b), .ALUControl(ALUControl), .Result(Result), .ALUFlags(ALUFlags) );
	
  always// always execute
  	begin
    	clk=1; #5; clk=0; #5;   //period? Tc= 10
  	end
  
  initial // one exec 
    begin
      $readmemh("testvector.tv",testvector); //read in hexa
      errors=0;
      vectornum=0;
      reset=1; #17;reset=0;
    end
  
  always @(posedge clk)
    begin
      ALUFlags_expected = testvector[vectornum][3:0];
      Result_expected = testvector[vectornum][35:4];
      a = testvector[vectornum][67:36];
      b = testvector[vectornum][99:68];
      ALUControl = testvector[vectornum][101:100];
    end
  
  always @(negedge clk)
    begin
      if (~reset)
        begin 
          if ((Result !== Result_expected) || (ALUFlags_expected !== ALUFlags))  // ===, == 
      			begin
            	$display("testvector: %h",testvector[vectornum]);
            	$display("Vectornum: %d",vectornum);
            	$display("Error input a: %h",{a});
            	$display("Error input b: %h",{b});
            	$display("Error input ALUControl: %h",{ALUControl});
            	$display("output Result:%h, Result_expected:%b",Result,Result_expected);
            	$display("output ALUFlags:%h, ALUFlags_expected:%b",ALUFlags, ALUFlags_expected);
              errors=errors+1; 
            end
      	vectornum=vectornum+1;
      
          if (testvector[vectornum][0] === 1'bx)
            begin
              $display("total errors: %d",errors);
              $finish;
            end  
        end
    end
  
  initial begin
    $dumpfile("alu.vcd");
    $dumpvars;
  end
endmodule