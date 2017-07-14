`timescale 10ns/1ns
module Rx_Shift(clk,RXIn,StartRX2,LatchRXD0,LatchRXD1,ValidRXDIn,RXOut,Size,RXcount);
input clk;
input RXIn;
input StartRX2;
input [3:0] Size;
//integer Size1;
input [6:0] RXcount;
input LatchRXD0;
input LatchRXD1;
input ValidRXDIn;
output reg [31:0] RXOut;
reg [31:0] RXBuf0;
reg [31:0] RXBuf1;
//assign Size1 = Size-1;

always @(posedge clk)
begin
	if (StartRX2 == 1 && RXcount <= (Size*8))
	begin
		if (LatchRXD0==1 && ValidRXDIn==1)
		begin
		RXBuf0[(Size*8-1)-RXcount] = RXIn;
		end
		else if(LatchRXD0==1)
		RXBuf0[(Size*8-1)-RXcount] = RXIn;
		else if (LatchRXD1==1 && ValidRXDIn==1)
		begin
		RXBuf1[(Size*8-1)-RXcount] = RXIn;
		end
		else if(LatchRXD1==1)
		RXBuf1[(Size*8-1)-RXcount] = RXIn;
        end
	if(RXcount == 0)
	begin
		if(LatchRXD0 == 1)
			RXOut = RXBuf0;
		else if(LatchRXD1 == 1)
			RXOut = RXBuf1;
	end
end
endmodule

