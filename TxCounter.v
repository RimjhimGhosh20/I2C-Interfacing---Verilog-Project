
`timescale 10ns/1ns
module counterTX(clk, TXcount, LoadTXCount, DecTXCount, Burst, Size);
input clk;
input LoadTXCount, DecTXCount;
input [6:0]Burst;
input [3:0]Size;
output reg [6:0] TXcount;
integer size1,burst,size;

always@(posedge clk)
begin
//if(Burst == (1||2||4||8||16||32||64)  && Size==(1||2||4) )
//begin
	$display("Reached here");
	if(LoadTXCount)
	begin
		burst = Burst;
		size = Size;
		size1 = size*8;
	end
	if(size1==0 && LoadTXCount==0 && DecTXCount==1)
	begin
		burst =burst-1;
		size1 = size*8;
	end
	if(burst!=0 && LoadTXCount==0 && DecTXCount==1)
	begin
		size1=size1-1;
		TXcount = size1;
	end
end
//end
endmodule


