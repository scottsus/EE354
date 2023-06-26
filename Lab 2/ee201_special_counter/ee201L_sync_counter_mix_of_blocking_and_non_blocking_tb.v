// File: ee201L_sync_counter_mix_of_blocking_and_non_blocking_tb.v
// Gandhi Puvvada 3/10/2009, 11/22/2010, 9/4/2011
//----------------------------------------------------------------------------

`timescale 1 ns / 100 ps

module ee201L_sync_counter_with_jump_tb ;

reg clk_tb, clr_tb, load_tb, jump_tb, en_tb;
reg [4:0] BA_tb; // Branch Address (load value)
wire [4:0] Q_tb;

integer  Clk_cnt;

`define CLK_PERIOD 20

// instantiation of UUT
// module ee201L_sync_counter_with_jump (clk, clr, load, jump, en, BA, Q);
	ee201L_sync_counter_with_jump UUT (clk_tb, clr_tb, load_tb, jump_tb, en_tb, BA_tb, Q_tb);
		  
initial
  begin  : CLK_GENERATOR
    clk_tb = 1'b1;
    forever
       begin
	  #((`CLK_PERIOD )/ 2) clk_tb = ~clk_tb;
       end 
  end


initial
  begin  : CLK_COUNTER
    Clk_cnt = 0;
    forever
       begin
	      #(`CLK_PERIOD) Clk_cnt = Clk_cnt + 1;
       end 
  end

initial
  begin  : STIMULUS
	// clear the counter initially
	 clr_tb = 1'b1; load_tb = 1'bx; jump_tb = 1'bx;  en_tb = 1'bx; BA_tb = 5'bxxxxx;
	 
	 # (2.1 * `CLK_PERIOD); 
	// After 2 clocks (and a little after 0.1 of the clock period), confirm the superiority of clear over the rest of the controls
	 clr_tb = 1'b1; load_tb = 1'bx; jump_tb = 1'bx;  en_tb = 1'bx; BA_tb = 5'bxxxxx;
	 # (1.0 * `CLK_PERIOD); 
	 clr_tb = 1'b1; load_tb = 1'b1; jump_tb = 1'bx;  en_tb = 1'bx; BA_tb = 5'b00111;
	 # (1.0 * `CLK_PERIOD); 
	 clr_tb = 1'b1; load_tb = 1'b0; jump_tb = 1'b1;  en_tb = 1'bx; BA_tb = 5'bxxxxx;	 
	 # (1.0 * `CLK_PERIOD); 
	 clr_tb = 1'b1; load_tb = 1'b0; jump_tb = 1'b0;  en_tb = 1'b1; BA_tb = 5'b00110;	 
	 # (1.0 * `CLK_PERIOD); 
	 clr_tb = 1'b1; load_tb = 1'b1; jump_tb = 1'b1;  en_tb = 1'b1; BA_tb = 5'b00110;
	 
	// A variety of mixed transaction (excluding jump) 
	 # (1.0 * `CLK_PERIOD); clr_tb = 1'b0; load_tb = 1'b1; jump_tb = 1'bx;  en_tb = 1'bx; BA_tb = 5'b00101;
	 # (1.0 * `CLK_PERIOD); clr_tb = 1'b1; load_tb = 1'bx; jump_tb = 1'bx;  en_tb = 1'bx; BA_tb = 5'bxxxxx;
	 
	 
	 # (3.0 * `CLK_PERIOD); 
	 clr_tb = 1'b0; load_tb = 1'b1; jump_tb = 1'bx;  en_tb = 1'bx; BA_tb = 5'b00100;	
	 # (2.0 * `CLK_PERIOD); 
	 clr_tb = 1'b0; load_tb = 1'b0; jump_tb = 1'b0;  en_tb = 1'b1; BA_tb = 5'bxxxxx;
	 # (19.0 * `CLK_PERIOD); 
	 clr_tb = 1'b1; load_tb = 1'bx; jump_tb = 1'b0;  en_tb = 1'bx; BA_tb = 5'bxxxxx;
	 # (1.0 * `CLK_PERIOD); 
	 clr_tb = 1'b0; load_tb = 1'b1; jump_tb = 1'b0;  en_tb = 1'bx; BA_tb = 5'b00101;
	 # (1.0 * `CLK_PERIOD); 
	 clr_tb = 1'b1; load_tb = 1'bx; jump_tb = 1'b0;  en_tb = 1'bx; BA_tb = 5'bxxxxx;
	 # (1.0 * `CLK_PERIOD); 
	 clr_tb = 1'b0; load_tb = 1'b1; jump_tb = 1'b0;  en_tb = 1'bx; BA_tb = 5'b00100;	
	 # (2.0 * `CLK_PERIOD); 
	 clr_tb = 1'b0; load_tb = 1'b0; jump_tb = 1'b0;  en_tb = 1'b1; BA_tb = 5'bxxxxx;
	 # (6.0 * `CLK_PERIOD); 
	 clr_tb = 1'b1; load_tb = 1'bx; jump_tb = 1'bx;  en_tb = 1'bx; BA_tb = 5'bxxxxx;

	// Below we are testing the "JUMP" operation by loading a test value into the counter and jumping from there.
	// Initially we load 5'b00000 and keep jumping from there for 8 clocks (8 clocks corresponding to the 8 "=>" in line below). 
	// You see that we go from 0 => 14 => 15 => 16 => 17 => 18 => 19 => 20 => 20


	 # (1.0 * `CLK_PERIOD); 
	// load 5'b00000
	 clr_tb = 1'b0; load_tb = 1'b1; jump_tb = 1'bx;  en_tb = 1'bx; BA_tb = 5'b00000;
	 # (1.0 * `CLK_PERIOD); $display ("\nLoaded count = %d \n", Q_tb);
	// start jumping 
	 clr_tb = 1'b0; load_tb = 1'b0; jump_tb = 1'b1;  en_tb = 1'bx; BA_tb = 5'bxxxxx;
	 # (1.0 * `CLK_PERIOD); $display ("Jumped to count = %d", Q_tb);
	 # (1.0 * `CLK_PERIOD); $display ("Further jumped to count = %d", Q_tb); 
	 # (1.0 * `CLK_PERIOD); $display ("Further jumped to count = %d", Q_tb); 
	 # (1.0 * `CLK_PERIOD); $display ("Further jumped to count = %d", Q_tb); 
	 # (1.0 * `CLK_PERIOD); $display ("Further jumped to count = %d", Q_tb); 
	 # (1.0 * `CLK_PERIOD); $display ("Further jumped to count = %d", Q_tb); 
	 # (1.0 * `CLK_PERIOD); $display ("Further jumped to count = %d", Q_tb); 
	 # (1.0 * `CLK_PERIOD); $display ("Further jumped to count = %d", Q_tb); 
	 $display ("Initial JUMP test completed. \n \n");
	 // enabled counter to increment causing roll-over
	 clr_tb = 1'b0; load_tb = 1'b0; jump_tb = 1'b0;  en_tb = 1'b1; BA_tb = 5'bxxxxx;
	 // After 3 clocks, it remains stay-put for 2 clocks
	 # (3.0 * `CLK_PERIOD);
	 clr_tb = 1'b0; load_tb = 1'b0; jump_tb = 1'b0;  en_tb = 1'b0; BA_tb = 5'bxxxxx;
	 # (2.0 * `CLK_PERIOD); 

// Students: Try to replace the following 21 nearly identical paragraphs with a "for loop".	 
	 
	// load 5'b00000
	 clr_tb = 1'b0; load_tb = 1'b1; jump_tb = 1'bx;  en_tb = 1'bx; BA_tb = 5'b00000;
	 # (1.0 * `CLK_PERIOD); $write ("Loaded count = %d", Q_tb);
	// jump 
	 clr_tb = 1'b0; load_tb = 1'b0; jump_tb = 1'b1;  en_tb = 1'bx; BA_tb = 5'bxxxxx;
	 # (1.0 * `CLK_PERIOD); $display (".        Jumped to count = %d", Q_tb);

	// load 5'b00001
	 clr_tb = 1'b0; load_tb = 1'b1; jump_tb = 1'bx;  en_tb = 1'bx; BA_tb = 5'b00001;
	 # (1.0 * `CLK_PERIOD); $write ("Loaded count = %d", Q_tb);
	// jump 
	 clr_tb = 1'b0; load_tb = 1'b0; jump_tb = 1'b1;  en_tb = 1'bx; BA_tb = 5'bxxxxx;
	 # (1.0 * `CLK_PERIOD); $display (".        Jumped to count = %d", Q_tb);

	// load 5'b00010
	 clr_tb = 1'b0; load_tb = 1'b1; jump_tb = 1'bx;  en_tb = 1'bx; BA_tb = 5'b00010;
	 # (1.0 * `CLK_PERIOD); $write ("Loaded count = %d", Q_tb);
	// jump 
	 clr_tb = 1'b0; load_tb = 1'b0; jump_tb = 1'b1;  en_tb = 1'bx; BA_tb = 5'bxxxxx;
	 # (1.0 * `CLK_PERIOD); $display (".        Jumped to count = %d", Q_tb);

	// load 5'b00011
	 clr_tb = 1'b0; load_tb = 1'b1; jump_tb = 1'bx;  en_tb = 1'bx; BA_tb = 5'b00011;
	 # (1.0 * `CLK_PERIOD); $write ("Loaded count = %d", Q_tb);
	// jump 
	 clr_tb = 1'b0; load_tb = 1'b0; jump_tb = 1'b1;  en_tb = 1'bx; BA_tb = 5'bxxxxx;
	 # (1.0 * `CLK_PERIOD); $display (".        Jumped to count = %d", Q_tb);

	// load 5'b00100
	 clr_tb = 1'b0; load_tb = 1'b1; jump_tb = 1'bx;  en_tb = 1'bx; BA_tb = 5'b00100;
	 # (1.0 * `CLK_PERIOD); $write ("Loaded count = %d", Q_tb);
	// jump 
	 clr_tb = 1'b0; load_tb = 1'b0; jump_tb = 1'b1;  en_tb = 1'bx; BA_tb = 5'bxxxxx;
	 # (1.0 * `CLK_PERIOD); $display (".        Jumped to count = %d", Q_tb);

	// load 5'b00101
	 clr_tb = 1'b0; load_tb = 1'b1; jump_tb = 1'bx;  en_tb = 1'bx; BA_tb = 5'b00101;
	 # (1.0 * `CLK_PERIOD); $write ("Loaded count = %d", Q_tb);
	// jump 
	 clr_tb = 1'b0; load_tb = 1'b0; jump_tb = 1'b1;  en_tb = 1'bx; BA_tb = 5'bxxxxx;
	 # (1.0 * `CLK_PERIOD); $display (".        Jumped to count = %d", Q_tb);

	// load 5'b00110
	 clr_tb = 1'b0; load_tb = 1'b1; jump_tb = 1'bx;  en_tb = 1'bx; BA_tb = 5'b00110;
	 # (1.0 * `CLK_PERIOD); $write ("Loaded count = %d", Q_tb);
	// jump 
	 clr_tb = 1'b0; load_tb = 1'b0; jump_tb = 1'b1;  en_tb = 1'bx; BA_tb = 5'bxxxxx;
	 # (1.0 * `CLK_PERIOD); $display (".        Jumped to count = %d", Q_tb);

	// load 5'b00111
	 clr_tb = 1'b0; load_tb = 1'b1; jump_tb = 1'bx;  en_tb = 1'bx; BA_tb = 5'b00111;
	 # (1.0 * `CLK_PERIOD); $write ("Loaded count = %d", Q_tb);
	// jump 
	 clr_tb = 1'b0; load_tb = 1'b0; jump_tb = 1'b1;  en_tb = 1'bx; BA_tb = 5'bxxxxx;
	 # (1.0 * `CLK_PERIOD); $display (".        Jumped to count = %d", Q_tb);

	// load 5'b01000
	 clr_tb = 1'b0; load_tb = 1'b1; jump_tb = 1'bx;  en_tb = 1'bx; BA_tb = 5'b01000;
	 # (1.0 * `CLK_PERIOD); $write ("Loaded count = %d", Q_tb);
	// jump 
	 clr_tb = 1'b0; load_tb = 1'b0; jump_tb = 1'b1;  en_tb = 1'bx; BA_tb = 5'bxxxxx;
	 # (1.0 * `CLK_PERIOD); $display (".        Jumped to count = %d", Q_tb);

	// load 5'b01001
	 clr_tb = 1'b0; load_tb = 1'b1; jump_tb = 1'bx;  en_tb = 1'bx; BA_tb = 5'b01001;
	 # (1.0 * `CLK_PERIOD); $write ("Loaded count = %d", Q_tb);
	// jump 
	 clr_tb = 1'b0; load_tb = 1'b0; jump_tb = 1'b1;  en_tb = 1'bx; BA_tb = 5'bxxxxx;
	 # (1.0 * `CLK_PERIOD); $display (".        Jumped to count = %d", Q_tb);

	// load 5'b01010
	 clr_tb = 1'b0; load_tb = 1'b1; jump_tb = 1'bx;  en_tb = 1'bx; BA_tb = 5'b01010;
	 # (1.0 * `CLK_PERIOD); $write ("Loaded count = %d", Q_tb);
	// jump 
	 clr_tb = 1'b0; load_tb = 1'b0; jump_tb = 1'b1;  en_tb = 1'bx; BA_tb = 5'bxxxxx;
	 # (1.0 * `CLK_PERIOD); $display (".        Jumped to count = %d", Q_tb);

	// load 5'b01011
	 clr_tb = 1'b0; load_tb = 1'b1; jump_tb = 1'bx;  en_tb = 1'bx; BA_tb = 5'b01011;
	 # (1.0 * `CLK_PERIOD); $write ("Loaded count = %d", Q_tb);
	// jump 
	 clr_tb = 1'b0; load_tb = 1'b0; jump_tb = 1'b1;  en_tb = 1'bx; BA_tb = 5'bxxxxx;
	 # (1.0 * `CLK_PERIOD); $display (".        Jumped to count = %d", Q_tb);

	// load 5'b01100
	 clr_tb = 1'b0; load_tb = 1'b1; jump_tb = 1'bx;  en_tb = 1'bx; BA_tb = 5'b01100;
	 # (1.0 * `CLK_PERIOD); $write ("Loaded count = %d", Q_tb);
	// jump 
	 clr_tb = 1'b0; load_tb = 1'b0; jump_tb = 1'b1;  en_tb = 1'bx; BA_tb = 5'bxxxxx;
	 # (1.0 * `CLK_PERIOD); $display (".        Jumped to count = %d", Q_tb);

	// load 5'b01101
	 clr_tb = 1'b0; load_tb = 1'b1; jump_tb = 1'bx;  en_tb = 1'bx; BA_tb = 5'b01101;
	 # (1.0 * `CLK_PERIOD); $write ("Loaded count = %d", Q_tb);
	// jump 
	 clr_tb = 1'b0; load_tb = 1'b0; jump_tb = 1'b1;  en_tb = 1'bx; BA_tb = 5'bxxxxx;
	 # (1.0 * `CLK_PERIOD); $display (".        Jumped to count = %d", Q_tb);

	// load 5'b01110
	 clr_tb = 1'b0; load_tb = 1'b1; jump_tb = 1'bx;  en_tb = 1'bx; BA_tb = 5'b01110;
	 # (1.0 * `CLK_PERIOD); $write ("Loaded count = %d", Q_tb);
	// jump 
	 clr_tb = 1'b0; load_tb = 1'b0; jump_tb = 1'b1;  en_tb = 1'bx; BA_tb = 5'bxxxxx;
	 # (1.0 * `CLK_PERIOD); $display (".        Jumped to count = %d", Q_tb);

	// load 5'b01111
	 clr_tb = 1'b0; load_tb = 1'b1; jump_tb = 1'bx;  en_tb = 1'bx; BA_tb = 5'b01111;
	 # (1.0 * `CLK_PERIOD); $write ("Loaded count = %d", Q_tb);
	// jump 
	 clr_tb = 1'b0; load_tb = 1'b0; jump_tb = 1'b1;  en_tb = 1'bx; BA_tb = 5'bxxxxx;
	 # (1.0 * `CLK_PERIOD); $display (".        Jumped to count = %d", Q_tb);
	 
	 
	// load 5'b10000
	 clr_tb = 1'b0; load_tb = 1'b1; jump_tb = 1'bx;  en_tb = 1'bx; BA_tb = 5'b10000;
	 # (1.0 * `CLK_PERIOD); $write ("Loaded count = %d", Q_tb);
	// jump 
	 clr_tb = 1'b0; load_tb = 1'b0; jump_tb = 1'b1;  en_tb = 1'bx; BA_tb = 5'bxxxxx;
	 # (1.0 * `CLK_PERIOD); $display (".        Jumped to count = %d", Q_tb);

	// load 5'b10001
	 clr_tb = 1'b0; load_tb = 1'b1; jump_tb = 1'bx;  en_tb = 1'bx; BA_tb = 5'b10001;
	 # (1.0 * `CLK_PERIOD); $write ("Loaded count = %d", Q_tb);
	// jump 
	 clr_tb = 1'b0; load_tb = 1'b0; jump_tb = 1'b1;  en_tb = 1'bx; BA_tb = 5'bxxxxx;
	 # (1.0 * `CLK_PERIOD); $display (".        Jumped to count = %d", Q_tb);

	// load 5'b10010
	 clr_tb = 1'b0; load_tb = 1'b1; jump_tb = 1'bx;  en_tb = 1'bx; BA_tb = 5'b10010;
	 # (1.0 * `CLK_PERIOD); $write ("Loaded count = %d", Q_tb);
	// jump 
	 clr_tb = 1'b0; load_tb = 1'b0; jump_tb = 1'b1;  en_tb = 1'bx; BA_tb = 5'bxxxxx;
	 # (1.0 * `CLK_PERIOD); $display (".        Jumped to count = %d", Q_tb);

	// load 5'b10011
	 clr_tb = 1'b0; load_tb = 1'b1; jump_tb = 1'bx;  en_tb = 1'bx; BA_tb = 5'b10011;
	 # (1.0 * `CLK_PERIOD); $write ("Loaded count = %d", Q_tb);
	// jump 
	 clr_tb = 1'b0; load_tb = 1'b0; jump_tb = 1'b1;  en_tb = 1'bx; BA_tb = 5'bxxxxx;
	 # (1.0 * `CLK_PERIOD); $display (".        Jumped to count = %d", Q_tb);

	// load 5'b10100
	 clr_tb = 1'b0; load_tb = 1'b1; jump_tb = 1'bx;  en_tb = 1'bx; BA_tb = 5'b10100;
	 # (1.0 * `CLK_PERIOD); $write ("Loaded count = %d", Q_tb);
	// jump 
	 clr_tb = 1'b0; load_tb = 1'b0; jump_tb = 1'b1;  en_tb = 1'bx; BA_tb = 5'bxxxxx;
	 # (1.0 * `CLK_PERIOD); $display (".        Jumped to count = %d", Q_tb);


	end
  
endmodule // ee201L_sync_counter_tb;

//----------------------------------------------------------------------------