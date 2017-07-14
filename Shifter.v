`timescale 10ns/1ns
module TxShift(clk,TXIn,CSTX,ShiftTXBuf0,ShiftTXBuf1,LoadTXBuf0,LoadTXBuf1,DOut);
input clk;
input [31:0]TXIn;
input CSTX;
input ShiftTXBuf0;
input ShiftTXBuf1;
input LoadTXBuf0;
input LoadTXBuf1;
output reg DOut;

reg [31:0] TXBuf0;
reg [31:0] TXBuf1;

always @(posedge clk)
begin
	if (CSTX)
	begin
		if (LoadTXBuf0==1)
		begin
		TXBuf0<=TXIn;
		end
 		else if (LoadTXBuf1==1)
		begin
		TXBuf1<=TXIn;
		end
     
		if (ShiftTXBuf0==1)// & ShiftTXBuf1!=1 & PassTXBuf==0)
		begin
		DOut<=TXBuf0[0];
		TXBuf0={1'b0,TXBuf0[30:1]};
		end      
		else if (ShiftTXBuf1==1)// & ShiftTXBuf0!=1 & PassTXBuf==1)
		begin
		DOut<=TXBuf1[0];
		TXBuf1={1'b0,TXBuf1[30:1]};
		end  	
	end 	
end
endmodule

