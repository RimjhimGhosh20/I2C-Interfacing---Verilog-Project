
`timescale 10ns/1ns
module counterRX(clk, RXcount, DecRXCount, Burst, Size);

input clk;
input DecRXCount;
input [6:0]Burst;
input [3:0]Size;
output reg [6:0] RXcount;
integer size1, burst, size;
reg init;

initial
begin
	init = 1;
end

always@(posedge clk)
begin
	if (DecRXCount==0)
		begin
		if(Size >0 && init ==1)
		begin
		burst = Burst;
		size = Size*8-1;
//		size1 = size;
		RXcount = size;
		init = 0;
		end

		if(size==0)
		begin
		size = Size*8-1;
		RXcount = size;
		end		
		else
		begin
		size = RXcount;
		end

		end 
	if(size==0 && DecRXCount==1)
		begin
		burst = burst-1;
		size = Size*8;
		end
	if(burst!=0 && DecRXCount==1)
		begin
		size =size-1;
		RXcount = size;
		end
end
endmodule



