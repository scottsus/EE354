//----------------------------------------------------------------------------
//	Verilog modules for 
//  File: up_down_counter_Fall2022Quiz_tb.v
//	Written by Gandhi Puvvada  
//  Date: 10/2/2022 
//---------------------------------------------------------------------------
`timescale 1 ns / 100 ps

// module up_down_counter_Fall2022Quiz (CLK, EN, S_RST, M);

module up_down_counter_Fall2022Quiz_tb;

reg CLK_tb, S_RST_tb, EN_tb;
wire [2:0] M_tb; // the main 3-bit counter
wire UP_tb; 
wire REPEATED_tb; 


integer  CLK_cnt;

`define CLK_PERIOD 10

// instantiation of UUT
// module up_down_counter_Fall2022Quiz (CLK, EN, S_RST, M);

	up_down_counter_Fall2022Quiz UUT (CLK_tb, EN_tb, S_RST_tb, M_tb);

initial
  begin  : CLK_GENERATOR
    CLK_tb = 1'b1;
    forever
       begin
	  #((`CLK_PERIOD )/ 2) CLK_tb = ~CLK_tb;
       end 
  end


initial
  begin  : CLK_COUNTER
    CLK_cnt = 0;
    forever
       begin
	      #(`CLK_PERIOD) CLK_cnt = CLK_cnt + 1;
       end 
  end

initial
  begin  : STIMULUS
     S_RST_tb = 1'b1; 
	 EN_tb = 1'b0; 
	 #23;
	 S_RST_tb = 1'b0;
	 EN_tb = 1'b0; 
	 #20;
	 EN_tb = 1'b1; 
  end
  
assign UP_tb = UUT.UP;
assign REPEATED_tb = UUT.REPEATED;


endmodule // Counter_tb
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------