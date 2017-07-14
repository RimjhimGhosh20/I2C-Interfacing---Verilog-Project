
module RxController(clk, StartRX,ValidRXDIn,LatchRXD0,LatchRXD1,
		     DecRXCount,ValidRXDout,RXcount,RIcount,SDA,DAck);

input clk, StartRX, ValidRXDIn;
input [2:0]RIcount;
input [6:0]RXcount;
output reg LatchRXD0,LatchRXD1,DecRXCount, 
	   ValidRXDout,SDA,DAck;
reg [2:0] PS, NS;

localparam IDLE=3'b000, CountDown0=3'b001, ValidDout1=3'b010, 
	   CountDown1=3'b011, ValidDout0=3'b100,CheckSDA=3'b101;
reg init;
initial 
begin
	init = 1;
	PS = CountDown0; 
        NS = CountDown0;
	LatchRXD0 = 0;
	LatchRXD1 = 0;
	DecRXCount = 0;
	ValidRXDout = 0;
end

always @(posedge clk)
begin
   PS = NS;
   if (StartRX == 0)
	NS <= CountDown0;
   else if (StartRX == 1)
    begin 
   	case(PS)
	CountDown0: 
		begin
			if(ValidRXDIn)
			begin
				LatchRXD0 = 1;
	    	     		LatchRXD1 = 0;
			     	ValidRXDout<=0;
			     	DecRXCount = 1;	
			end					     	
			if(RXcount == 1)
			begin
				NS<=ValidDout0;
			end
			else if(RXcount!=0)
		        begin
	    	        	NS <= CountDown0;
				if (RIcount==1)
				begin
				NS<=CheckSDA;
				end	
			
				else if (RIcount!=0)
				begin
		     		SDA=1'hz;
		     		DAck<=1'hz;
		     		end
	    		end			
		end
	ValidDout0: 
		begin
		  DAck<=1;
		  DecRXCount <= 0;
		  NS <= CountDown1;
		  LatchRXD0 <= 0;
		  LatchRXD1 <= 0;
		  ValidRXDout <= 1;
		end
	CountDown1: 
		begin
	 	DAck<=1'hz;
		if (ValidRXDIn)
		begin
		   LatchRXD0 <= 0;
		   LatchRXD1 <= 1;
		   ValidRXDout <= 0;
		   DecRXCount <= 1;
		end	
			if(RXcount == 1)
			begin
				NS<=ValidDout1;
			end
		    	if(RXcount!=0)
		    	begin
	    	       		 NS <= CountDown1;
				 if (RIcount==1)
				 begin
				 	NS<=CheckSDA;
				 end	
				
				 else if (RIcount!=0)
				 begin
		     			SDA<=1'hz;
		     			DAck<=1'hz;
		     		 end
		         end
			 else
			 begin
				DecRXCount <= 0;
				NS<=ValidDout1;
			 end	
		end
	ValidDout1: 
		begin
			 DAck<=1;
			 DecRXCount <= 0;
		 	 NS <= CountDown0;
		   	 LatchRXD0 <= 0;
		   	 LatchRXD1 <= 0;
		   	 ValidRXDout <= 1;	   		
	     	end
	CheckSDA:
		begin 
			SDA<=1;
			DAck<=1;
			DecRXCount <= 0;
			LatchRXD0 <= 0;
			LatchRXD1<=0;
			if (LatchRXD0==1)
			NS <= CountDown0;
			else if (LatchRXD1==1)
			NS <= CountDown1;
		end
	default : begin
		NS <= CountDown0;
		end
	endcase
   end
end
endmodule


