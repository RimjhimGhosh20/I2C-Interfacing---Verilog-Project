
module final(clk, address, data, write, WriteBit, SlaveAddress, reset, TXIn);
//Transmitter
input clk;
input [3:0]address; 		//to create a 4 bit address space
input [31:0]data;		//to provode the burst and size data
input write;
input [31:0] TXIn;
input WriteBit;
input reset;
input [6:0]SlaveAddress;
wire AddAck, DAck;
wire Ready, StartTX, SDA, validaddr, validdata, start, AOut, DOut, LoadTXBuf0, LoadTXBuf1, ShiftTXBuf0, ShiftTXBuf1,LoadTXCount, DecTXCount;
wire [3:0] size;
wire [6:0] burst;
wire [2:0] icount;
wire [6:0] TXCount;
wire ReadyData, i2c_scl, i2c_sda;
wire ready;
wire Loadtxcount;
wire RXAddrIn, RXDataIn, SlaveAck, DataAck;
//wire validRXDin;

//Receiver
wire RXIn;
wire ValidRXDin;
wire [6:0] RXcount;
wire StartRX;
wire StartRX1;
wire [2:0]RIcount;
wire LatchRXD0,LatchRXD1,DecRXCount,ValidRXDout;
wire Start;
wire WR;
wire Address;

//Transmitter Modules
TXcntrl_reg f1(.address(address), .data(data), .write(write), .Ready(Ready), .burst(burst), .size(size));
slaveaddress f2(.clk(clk), .Ready(Ready), .SlaveAck(SlaveAck), .WriteBit(WriteBit), .SlaveAddress(SlaveAddress),.StartTX(StartTX), .validaddr(validaddr), .start(start), .ReadyBit(ReadyBit), .AOut(AOut));
tx_controller f3(.clk(clk),.DataAck(DataAck),.cstx(StartTX),.ICount(icount),.LoadTXBuf0(LoadTXBuf0),.LoadTXBuf1(LoadTXBuf1),.ShiftTXBuf0(ShiftTXBuf0),.ShiftTXBuf1(ShiftTXBuf1),.LoadTXCount(LoadTXCount),.DecTXCount(DecTXCount), .validdata(validdata),.TXCount(TXCount),.ReadyData(ReadyData));
I_counter f4(.clk(clk), .DataAck(DataAck), .Icount(icount), .DecTXCount(DecTXCount), .Loadtxcount(LoadTXCount));
counterTX f5(.clk(clk), .TXcount(TXCount), .LoadTXCount(LoadTXCount), .DecTXCount(DecTXCount),.Burst(burst), .Size(size));
TxShift f6(.clk(clk),.TXIn(TXIn),.CSTX(StartTX),.ShiftTXBuf0(ShiftTXBuf0),.ShiftTXBuf1(ShiftTXBuf1),.LoadTXBuf0(LoadTXBuf0),.LoadTXBuf1(LoadTXBuf1),.DOut(DOut));
i2c f7(.clk(clk), .reset(reset), .start(start), .i2c_scl(i2c_scl), .i2c_sda(i2c_sda), .DataAck(DataAck), .SlaveAck(SlaveAck), .AddAck(AddAck), .DAck(DAck), .AOut(AOut), .DOut(DOut), .ready(ready), .RXAddrIn(RXAddrIn), .RXDataIn(RXDataIn), .ValidRXDin(ValidRXDin), .validaddr(validaddr), .validdata(validdata));

//Receiver

counterRX r1(.clk(clk),.RXcount(RXcount),.DecRXCount(DecRXCount),.Burst(burst),.Size(size));
RxController r2(.clk(clk),.StartRX(StartRX1),.ValidRXDIn(ValidRXDin),.LatchRXD0(LatchRXD0),.LatchRXD1(LatchRXD1),
		     .DecRXCount(DecRXCount),.ValidRXDout(ValidRXDout),.RXcount(RXcount),.RIcount(RIcount),.SDA(SDA),.DAck(DAck));
RxAddressIn r3(.clk(clk),.Start(ready),.WR(WR),.RXIn(RXAddrIn),.ValidRxDIn(ValidRXDin),.Address(Address),.StartRX1(StartRX1),.AddAck(AddAck),.RXOut(RXOut));
Rx_Shift r4(.clk(clk),.RXIn(RXDataIn),.StartRX2(StartRX1),.LatchRXD0(LatchRXD0),.LatchRXD1(LatchRXD1),.ValidRXDIn(ValidRXDin),.RXOut(RXOut),.Size(size),.RXcount(RXcount));
RX_Icounter r5(.clk(clk), .Sack(SAckBit), .RIcount(RIcount),.DecRXCount(DecRXCount));

endmodule

