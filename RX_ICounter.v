`timescale 10ns/1ns
module RX_Icounter(clk, Sack, RIcount, DecRXCount);

input clk;
input DecRXCount;
input Sack;
output reg [2:0] RIcount;

always @(posedge clk)
begin
	if(DecRXCount==1)
		begin	
			RIcount = RIcount - 1;
		end
	else if(DecRXCount==0)
		begin
			RIcount = 7;
		end	
end
endmodule




