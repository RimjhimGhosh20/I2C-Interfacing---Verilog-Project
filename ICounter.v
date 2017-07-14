`timescale 10ns/1ns
module I_counter(clk, DataAck, Icount, DecTXCount, Loadtxcount);

input clk;
input DecTXCount;
input DataAck;
output reg [2:0] Icount;
reg [2:0]count;
input Loadtxcount;

always @(posedge clk)
begin
	if(Loadtxcount)
	begin
		count = 8;
	end
	if(DataAck==1 && DecTXCount==1)
		begin	
			count = 8;
		end
	else if(DecTXCount==1)
		begin
			count = count-1;
			Icount = count;
		end	
end
endmodule



