`timescale 10ns/1ns
module slaveaddress(input clk,
      input Ready,
      input SlaveAck,
      input WriteBit,
      input [6:0]SlaveAddress,
      output reg StartTX,
      output reg ReadyBit,
      output reg validaddr,
      output reg start,
      output reg AOut);
reg[1:0] PS,NS;
reg [6:0]SlaveReg;
localparam LoadAddress=2'b00,ShiftAddress=2'b01,
    LastShift=2'b10,CheckSAck=2'b11;
integer i;

initial 
begin
PS=LoadAddress;
i=7;
end

always @(posedge clk)
begin
PS=NS;
if (Ready==1)
begin
case(PS)
LoadAddress:
begin
	start <= 1;			//start signal to start the i2c
  	SlaveReg<=SlaveAddress;
      	NS<=ShiftAddress;  	
end 
ShiftAddress:
begin
if(i>0)
begin
	validaddr <= 1;			//signal to inform that validaddr data is being sent.
    	NS<=ShiftAddress;
    	AOut<=SlaveReg[0];
    	SlaveReg <= {1'b0,SlaveReg[6:1]};
	i = i-1;
end
else
begin
   	NS<=LastShift;
   	AOut=WriteBit;
end
end
LastShift:
begin
	validaddr <= 0;			//end of validaddr data from transmitter
        NS<=CheckSAck;
end 
CheckSAck:
begin
if(SlaveAck==1)
begin
     	StartTX <= 1;
     	ReadyBit <= 0;
end
end 
default:
 	NS<=LoadAddress;
endcase 
end
end
endmodule 