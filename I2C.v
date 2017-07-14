
module i2c(clk, reset, start, i2c_scl, i2c_sda, SlaveAck, DataAck, AddAck, DAck, AOut, DOut, ready, RXAddrIn, RXDataIn, ValidRXDin, validaddr, validdata);
input clk;
input reset;
input start;
input AOut, DOut;
output reg SlaveAck,DataAck;
output reg RXAddrIn, RXDataIn;
input validaddr, validdata;
output reg ValidRXDin;
input AddAck, DAck;
output wire i2c_scl;
output reg i2c_sda;
output reg ready;
reg i2c_scl_enable = 0;
reg indata;
reg[6:0] count;
reg[7:0] state;

localparam IDLE = 0, START = 1, ADDR=2, AACK=3, DATA = 4, DACK=5, STOP = 6;

assign i2c_scl = (i2c_scl_enable == 0) ? 1 : ~clk;

always@(negedge clk)
begin
	if(reset)
	begin
	i2c_scl_enable <= 0;
	end
	else
	begin
	if((state == IDLE) || (state == STOP) || (state == START))
	begin
	i2c_scl_enable <= 0;
	end
	else
	begin
	i2c_scl_enable <= 1;
	end
	end
end

always@(posedge clk)
begin
if(reset)
begin
	state <= 0;
	i2c_sda <= 1;
	count <= 0;
end
else
begin
	case(state)
	IDLE: 
	begin
		i2c_sda <= 1;
		if(start)
		begin
		ready <= 1;
		count <= 8;
		state <= ADDR;
		end
		else
		state <= IDLE;
	end
	ADDR:
	begin
		i2c_sda <= 0;
		if(validaddr)
		begin
			SlaveAck <= 1'hz;
			ValidRXDin = 1;
			RXAddrIn <= AOut;		//Data from Trasnmitter
			if(count == 0)		
			state <= AACK;
			else
			begin
			state <= ADDR;
			count <= count - 1;
			end
			if(start == 0)
			state <= STOP;
		end
		else if(validaddr ==0 && count==0)
			state<=AACK;		
	end
	AACK:
	begin
		ValidRXDin <= 0;
		if(AddAck)
		begin		
		SlaveAck <= AddAck;			//Ack from Receiver		 
		state <= DATA;
		count <= 7;
		end		
		else if(AddAck == 0)
		state <= STOP;		
	end
	DATA:
	begin
		if(validdata)
		begin
			DataAck <= 1'hz;
			ValidRXDin = 1;
			i2c_sda <= DOut;
			RXDataIn <= i2c_sda;		//Data from Trasnmitter
			if(count == 0)		
			state <= DACK;
			else
			begin
			state <= DATA;
			count <= count - 1;
			end

			if(start == 0)
			begin
			ValidRXDin <= 0;
			state <= STOP;
			end
		end
	end
	DACK:
	begin
		ValidRXDin <= 0;
		if(DAck)
		begin		
		DataAck <= DAck;			//Ack from Receiver
		state <= DATA;
		count <= 7;
		end		
		else if(DAck == 0)
		state <= STOP;
	end
	STOP:
	begin
		ready <= 0;
		i2c_sda <= 1;
	end
	endcase
end

end
endmodule
