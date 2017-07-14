
`timescale 10ns/1ns
module RxAddressIn(clk,Start,WR,RXIn,ValidRxDIn,Address,StartRX1,AddAck,RXOut);

input clk;
input Start;
      reg [6:0]address;
      output reg WR;
      input RXIn;
      input ValidRxDIn;
      output reg [6:0]Address;
      output reg StartRX1;
      output reg AddAck;
      output reg [31:0]RXOut;
reg[2:0] PS,NS;

localparam CheckValidData=3'b000,ShiftAddress=3'b001,
    LastShift=3'b010,VerifyAddress=3'b011, ACKZero=3'b100;
integer i;

initial 
begin
PS=ShiftAddress;
i=0;
address=7'h01;
end

always @(posedge clk)
begin
PS=NS;
if (Start)
begin
case(PS)
	//CheckValidData:
		//begin
//$display("CheckValidData%d",i);
  			//if(ValidRxDIn)begin
      				//NS<=ShiftAddress;
//$display("ValidRxDIn=1");
//end
			//else
				//NS<=CheckValidData; 	
			//end 
	ShiftAddress:
		begin
if(ValidRxDIn)begin
			if(i<7)
			 begin
    				NS <= ShiftAddress;
    				Address[i]<= RXIn;
				i <= i+1;
		$display("ShiftAddress%d",i);
			 end
			else
			 begin
   				RXOut <= Address;
				WR <= RXIn;
				NS <= VerifyAddress;	  	
			 end
		end 
end
	VerifyAddress:
			begin
  			   	if(RXOut == address)
				begin
				if(WR == 1)
				 begin
				  AddAck <= 1;
				  StartRX1 <=1;
				  NS <= ACKZero;
				end
				end
				else
				AddAck <= 0;
			end
	ACKZero:
        		begin
				AddAck <= 1'hz;
			end
	default:
 		NS<=ShiftAddress;
	endcase 
	end
	end
endmodule 