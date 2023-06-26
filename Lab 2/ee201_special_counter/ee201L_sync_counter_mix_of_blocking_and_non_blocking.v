// File: ee201L_sync_counter_mix_of_blocking_and_non_blocking.v
// Gandhi Puvvada 3/10/2009, 11/22/2010, 4/10/2011, 9/4/2011

// This code is written to show the need for blocking assignments in 
// producing the next count value, if this next count value is 
// rather strangely computed.
//---------------------------------------------------------------------------
// This problem is clearly a made-up problem to make the computation of the
// next count (Q_next) fairly complicated, necessitating the use of blocking
// assignments and progressive computation in the next-state logic (logic 
// upstream to the count register).

// It is a truncated 5-bit UP counter. It counts from 0 to 20 and rolls back to zero.
// It has a synchronous clear control (clr), a load control and a count-enable (en) control
// as before. In addition, it has a special JUMP control and it is defined as follows.
// The order of priority is clear (clr), load, jump, and finally enable.

// Suppose clear and load are deasserted and JUMP is asserted. Then count-enable is a dont care.
// When the JUMP is asserted, the counter should jump to the midpoint M or a little 
// beyond the midpoint M as detailed below. The midpoint M is middle point between 
// the current count and 20 (the highest value).
// Example: current count is 12. Distance from 20 is 8. Half is 4. 
// So the midpoint M is at 16 (12+4 = 16).
// But what if the difference is an ODD number. Then you need to jump by 
// either the "floor" or the "ceiling" of the half of the difference depending
// on whether the difference is less than ten or more than ten respectively.
// Mr. Bruin: What if the difference is 10?
// Mr. Trojan: Well then the question of "floor" or "ceiling" does not arise!
// Miss Bruin: You also said, "or a little beyond the midpoint M".
// Mr. Trojan: Yes, yes, I was about to tell and was interrupted by Mr. Bruin.
// After calculating the midpoint M, a bonus to the jump by a constant of 4 is allowed
// if this bonus addition does not cause wrapping around (due to going beyond 20).

// To do the above we need to find the difference from 20 using "blocking" assignment
// so that (there is no delta-T delay and) we can use the same to find if it is ODD,
// and if so, if it is greater than or less than 10. And also find the floor or 
// ceiling of half of the difference. We copy the current count Q into a variable Q_next 
// and apply this midpoint jump to the Q_next using blocking assignments. Then we should 
// check to see that this is at least 4 or more away from 20 before applying the extra bonus of 4.
// Finally the value gathered in Q_next shall be conveyed to Q using non-blocking assignment
// so that we do not cause a RACE condition elsewhere.

// JUMP has higher priority over enable (en). And suppose clear and load are inactive.
// So if JUMP is true, and if the current count is 19, 
// it will end up remaining at 19 (because of the floor rule and no bonus rule).
// And if JUMP is true, and if the current count is 20,
// it will end up remaining at 20. 
//---------------------------------------------------------------------------
// Besides blocking and non-blocking assignments, we demonstrate through this example,
// another basic fact in the sequential language portion of an HDL coding.
// A later assignment to the same variable over-rides an earlier assignment.
//---------------------------------------------------------------------------
/*
   Recommendations to remember: Use intermediate variables such as "diff" and "Q_next"  
   to compute and further compute the needed values using blocking assignments.
   It is not necessary to assign to the final Q only once. You can assign the most common 
   value (the default value), and if needed over-ride this default assignment with a new 
   assignment. 
   It is a bad practice to assign to the same variable sometimes using blocking assignment 
   operator and sometimes using non-blocking assignment.
   All physical registers should be assigned using non-blocking assignment only to avoid
   RACE elsewhere. 
   All items assigned using non-blocking assignments in a clocked always block cause register 
   inference by the synthesis tool. While physical registers are also inferred when a reg variable
   is accessed before it is assigned (using blocking assignment) in a clocked process, 
   we should not use this side-effect to infer physical registers.
*/
//---------------------------------------------------------------------------
/*
Table showing current Q and Q_next when JUMP == 1 i.e. ((en == 1'bX) && (jump == 1'b1) && (load == 1'b0) && (clr == 1'b0)) .
	 Q		increase		Q_next
	 0		10+4 = 14		14
	 1		10+4 = 14		15
	 2		 9+4 = 13		15
	 3		 9+4 = 13		16
	 4		 8+4 = 12		16
	 5		 8+4 = 12		17
	 6		 7+4 = 11		17
	 7		 7+4 = 11		18
	 8		 6+4 = 10		18
	 9		 6+4 = 10		19
	10		 5+4 =  9		19
	11		 4+4 =  8		19
	12		 4+4 =  8		20
	13		 3+4 =  7  		20
	14 		 3+0 =  3		17
	15    	 2+0 =  2 		17
	16		 2+0 =  2 		18
	17		 1+0 =  1 		18
	18 		 1+0 =  1 		19
	19 		 0+0 =  0 		19
	20 		 0+0 =  0 		20

*/
//---------------------------------------------------------------------------
`timescale 1 ns / 100 ps

module ee201L_sync_counter_with_jump (clk, clr, load, jump, en, BA, Q);

input clk, clr, load, jump, en;
input [4:0] BA; // Branch Address (load value)
output [4:0] Q;
reg [4:0] Q;

// synthesis translate_off
reg [4*8:1] Operation; // A 4-character operation string for displaying operation (clr or load or jump or inc or stay) in text mode in the waveform
// synthesis translate_on
// The above two special comments "synthesis translate_off" and "synthesis translate_on" hide the lines between these comments from the synthesis tool.  

// synthesis translate_off
wire [3:0] Control;
assign Control = {clr, load, jump, en};
always @(*)
	begin
		casex ({clr, load, jump, en})
			4'b0000: Operation = "STAY"; // Counter remains stayput
			4'b1xxx: Operation = "CLR "; // Counter clears
			4'b01xx: Operation = "LOAD"; // Counter loads
			4'b001x: Operation = "JUMP"; // Counter jumps
			4'b0001: Operation = "INCR"; // Counter increments			
		    default: Operation = "UNKN"; // Unexpected Unknown operation
		endcase
	end	
// synthesis translate_on

  always @(posedge clk)

	begin : COUNT_BLOCK
	
	  reg [4:0] Q_next, diff;
	  
		if (en)
			begin
				Q <= Q +1;
				if (Q == 20) 
					begin
						Q <= 5'b00000;
					end
			end	
		if (jump)
			begin
				Q_next = Q; // notice blocking assignment
				diff  = 20 - Q_next; // (20 - Q) also works
				if (diff[0] == 0) // if the difference is even
					begin
						Q_next = Q_next + { 1'b0 , diff[4:1] };
					end
				else
					begin
						if (diff < 10)
							begin
								Q_next = Q_next + { 1'b0 , diff[4:1] };
							end
						else
							begin
								Q_next = Q_next + { 1'b0 , diff[4:1] } + 1'b1;
							end
					end
				if ( (20 - Q_next) 	>= 4)
					begin
						Q_next = Q_next + 4; // bonus 4
					end
				Q <= Q_next; // notice the non-blocking assignment
			end
		if (load)
			begin
				Q <= BA;
			end
		if (clr)
			begin
				Q <= 5'b00000;
			end

	end

endmodule
//---------------------------------------------------------------------------