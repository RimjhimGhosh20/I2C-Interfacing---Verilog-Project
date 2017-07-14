
module tx_controller(clk,DataAck,cstx,ICount,LoadTXBuf0,LoadTXBuf1,ShiftTXBuf0,ShiftTXBuf1,LoadTXCount,DecTXCount, validdata,TXCount,ReadyData);

input clk, cstx, DataAck;
input [2:0]ICount;
input [6:0]TXCount;
output reg LoadTXBuf0,LoadTXBuf1,ShiftTXBuf0,ShiftTXBuf1,LoadTXCount,DecTXCount,validdata;
reg [3:0] PS, NS;
output reg ReadyData; 

localparam IDLE=4'b0000, PRELOADBUF0=4'b0001, LOADBUF1=4'b0010, 
	   EMPTYBUF0=4'b0011, EMPTYLastBitBUF0=4'b0100, LOADBUF0=4'b0101,
	   EMPTYBUF1=4'b0110, EMPTYLastBitBUF1=4'b0111, STOP=4'b1000;
reg init;
initial 
begin
	PS = IDLE; 
        NS = IDLE;
	LoadTXBuf0 = 0;
	LoadTXBuf1 = 0;
	ShiftTXBuf0 = 0;
	ShiftTXBuf1 = 0;
	LoadTXCount = 0;
	DecTXCount = 0;
	validdata = 0;
end

always @(posedge clk)
begin
   PS = NS;
   if (cstx == 0)
	NS <= IDLE;
   else
   case(PS)
 	IDLE: begin
		     if(cstx)
		     begin    
	             NS <= PRELOADBUF0;
		     end
	      end
	PRELOADBUF0: begin
	    	     NS <= LOADBUF1;
		     LoadTXBuf0 <= 1;
	    	     LoadTXCount <= 1;
		     init <=1;
	    	     end
	LOADBUF1: begin
		  if(DataAck == 1 || init == 1)
		  begin
	    	  NS <= EMPTYBUF0;
		  LoadTXBuf0 <= 0;
		  LoadTXBuf1 <= 1;
		  ShiftTXBuf0 <= 1;
		  DecTXCount <= 1;
		  ReadyData <=1;
         	  LoadTXCount <= 0;
		  init <= 0;
		  end
	    	  end
	EMPTYBUF0: begin
		   LoadTXBuf1 <= 0;
		   validdata <= 1;
		   if(ICount==0)
		   begin
			validdata <= 0;
		   	ShiftTXBuf0 <= 0;
		   	DecTXCount <= 0;		
		   end
		   if(DataAck == 0)
		   begin
		   	NS <= STOP;		   
		   end
		   else if(DataAck == 1)
		   begin
			validdata <= 1;
		   	ShiftTXBuf0 <= 1;
		   	DecTXCount <= 1;
		   end
		   else
			NS <= EMPTYBUF0;
		   if(TXCount == 1)
		   	NS <= EMPTYLastBitBUF0;
		   end
	EMPTYLastBitBUF0: begin
			 NS <= LOADBUF0;
	   		 validdata <= 0;
			 LoadTXCount <= 0;
			 DecTXCount <= 0;
			 ShiftTXBuf0 <= 0;
			 ReadyData <=1;	
	   		 end
	LOADBUF0: begin
		  if(DataAck == 1)
		  begin
		  NS <= EMPTYBUF1;
		  validdata <= 0;
	    	  LoadTXBuf0 <= 1;
		  ShiftTXBuf1 <= 1;
		  DecTXCount <= 1;
		  LoadTXCount <= 0;
		  ReadyData <=1;
		  end
	          end
	EMPTYBUF1: begin
		   validdata <= 1;
		   LoadTXBuf0 <= 0;
		   if(ICount==0)
		   begin
			validdata <= 0;
		   	ShiftTXBuf1 <= 0;
		   	DecTXCount <= 0;
		   end
		   if(DataAck == 0)
		   begin
		   NS <= STOP;
		   end		   
		   else if(DataAck == 1)
		   begin
			validdata <= 1;
		   	ShiftTXBuf1 <= 1;
		   	DecTXCount <= 1;
		   end
		   else
			NS <= EMPTYBUF1;
		   if(TXCount == 1)
		   	NS <= EMPTYLastBitBUF1;
		    end
	EMPTYLastBitBUF1: begin
			  NS <= LOADBUF1;
	    		  validdata <= 0;			  
			  DecTXCount <= 0;
			  ReadyData <=1;
	    		  end
	STOP: begin
			NS <= STOP;
			validdata <= 0;
	      end
	default : begin
		
		NS <= IDLE;
		
		end
	endcase
end
endmodule

