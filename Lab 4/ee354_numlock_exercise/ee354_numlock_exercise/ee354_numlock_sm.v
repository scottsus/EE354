/////////////////////////////////////////////////
// Design Name: ee354_numlock_sm
// Authors: Scott Susanto
/////////////////////////////////////////////////

`timescale 1ns / 1ps

module ee354_numlock_sm(Clk, reset, U, Z, q_I, q_G1get, q_G1, q_G10get, q_G10, q_G101get, 
        q_G101, q_G1011get, q_G1011, q_Opening, q_Bad, Unlock);

    input   Clk, reset, U, Z;
    output q_I, q_G1get, q_G1, q_G10get, q_G10, q_G101get, 
        q_G101, q_G1011get, q_G1011, q_Opening, q_Bad, Unlock;
    reg[10:0] state;

    // State Machine variables
    assign {q_Bad, q_Opening, q_G1011, gG1011get, q_G101, q_G101get,
        q_G10, q_G10get, g_G1, q_G1get, q_I} = state;
    assign Unlock = q_Opening;

    localparam
        QInit		=   11'b00000000001,
	    QG1get		=   11'b00000000010,
	    QG1			=   11'b00000000100,
	    QG10get		=   11'b00000001000,
	    QG10		=   11'b00000010000,
	    QG101get	=   11'b00000100000,
	    QG101		=   11'b00001000000,
		QG1011get 	= 	11'b00010000000,
		QG1011 		= 	11'b00100000000,
		QOpening 	= 	11'b01000000000,
		QBad 		= 	11'b10000000000,
	    UNK			=   11'bXXXXXXXXXXX;

    // Timer variables
    reg [3:0] timerout_count;
	wire timerout;
	assign timerout = (timerout_count[3] & timerout_count[2] & timerout_count[1] & timerout_count[0]);
    
    // Controlling the timer
    always @ (posedge Clk, posedge reset)
    begin
        if (reset)
            timerout_count = 0;
        else
            begin
                if (state == QOpening)
                    timerout_count <= timerout_count + 1;
                else
                    timerout_count <= 0;
            end
    end

    // Next State Logic and State Machine
    always @ (posedge Clk, posedge reset)
    begin
        if (reset)
            state <= QInit;
        else
        begin
            case (state)
            QInit:
                if (U && (~Z))
                    state <= QG1get;
            QG1get:	
                if (~U)
                    state <= QG1;
            QG1:	
                if ((~U) && Z)
                    state <= QG10get;
                else if (U)
                    state <= QBad;
            QG10get:
                if (~Z)
                    state <= QG10;
            QG10:	
                if (U && (~Z))
                    state <= QG101get;
                else if (Z)
                    state <= QBad;
            QG101get:	
                if (~U)
                    state <= QG101;
            QG101:	
                if (U && (~Z))
                    state <= QG1011get;
                else if (Z)
                    state <= QBad;
            QG1011get: 
                if (~U)
                    state <= QG1011;
            QG1011:
                state <= QOpening;
            QOpening:
                if (timerout)
                    state <= QInit;
            QBad:
                if (~U && ~Z)
                    state <= QInit;
            default:
                state <= UNK;
            endcase
        end
    end

    // Output Function Logic
    assign Unlock = q_Opening;

endmodule