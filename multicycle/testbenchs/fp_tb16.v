`timescale 1ns/1ns
module fp_tb;
  reg [15:0] a,b;
  reg ALUControl;
  reg clk, reset;
  reg [96:0] testvector[1000:0];
  wire [15:0] Result;
  reg [15:0] Result_expected; // to compare y output
  reg [15:0] vectornum; // check testvector number
  reg [15:0] errors; // error counter
  
  fp16 fp_dut(.a(a), .b(b), .ALUControl(ALUControl), .Result(Result));
	
  always// always execute
  	begin
    	clk=1; #5; clk=0; #5;   //period? Tc= 10
  	end
  
  initial // one exec 
    begin
      $readmemh("testvector2.tv",testvector); //read in hexa
      errors=0;
      vectornum=0;
      reset=1; #17;reset=0;
    end
  
always @(posedge clk)
    begin
      Result_expected = testvector[vectornum][15:0];
      a = testvector[vectornum][31:16];
      b = testvector[vectornum][47:32];
      ALUControl = testvector[vectornum][48];
    end
  
  always @(negedge clk)
    begin
      if (~reset)
        begin 
          if ((Result !== Result_expected))  // ===, == 
      			begin
            	$display("testvector: %h",testvector[vectornum]);
            	$display("Vectornum: %d",vectornum);
            	$display("Error input a: %h",{a});
            	$display("Error input b: %h",{b});
            	$display("Error input ALUControl: %h",{ALUControl});
            	$display("output Result:%h, Result_expected:%b",Result,Result_expected);
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