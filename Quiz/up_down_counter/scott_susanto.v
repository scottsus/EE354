//----------------------------------------------------------------------------
//	Verilog modules for 
//  File: up_down_counter_Fall2022Quiz.v
//	Written by Gandhi Puvvada  
//  Date: 10/2/2022 
//---------------------------------------------------------------------------
`timescale 1 ns / 100 ps
module up_down_counter_Fall2022Quiz (CLK, EN, S_RST, M);

input CLK, EN, S_RST;
output [2:0] M; // M = Main Counter
reg [2:0] M; // M = Main Counter
reg UP; // Flag FF, UP == 1 means up-counting phase, UP == 0 means down-counting phase
reg REPEATED; // Flag REPEATED == 0 means not yet repeated; REPEATED == 1 means just repeated the first time;

always @(posedge CLK)
  begin : SPL_COUNTER 
	if (S_RST)
	  begin
		M <= 3'b000; UP <= 1'b1; REPEATED <= 1'b1;
	  end
		else
		  begin
			if (EN)
			  begin
				if (UP == 1) begin
				    if (M == 7) UP <= 0;
				    else if (M == 0) begin
				        if (REPEATED == 0) REPEATED <= 1;
				        else begin
				            M <= M + 1;
				            REPEATED <= 0;
				        end
				    end
				    else M<= M + 1;
				end
				else begin
				    if (M == 0) UP <= 1;
				    else if (M == 7) begin
				        if (REPEATED == 0) REPEATED <= 1;
				        else begin
				            M <= M - 1;
				            REPEATED <= 0;
				        end
				    end
				    else M <= M - 1;
				end
			  end
		  end 
	end 
	
endmodule // up_down_counter_Fall2022Quiz
						