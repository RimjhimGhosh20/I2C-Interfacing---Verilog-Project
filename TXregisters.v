`timescale 1ns / 1ps
module TXcntrl_reg(address, data, write, Ready, burst, size);

input [3:0]address; 		//to create a 4 bit address space
input [31:0]data;		//to provode the burst and size data
input write;			//signal to indicate to write the data to registers
reg [3:0]register[31:0];	//registers to store burst and size length
output reg Ready;
reg [1:0] PS,NS;
localparam loadBurst=2'b00, loadSize=2'b01;
output reg [6:0]burst;
output reg [3:0]size;

always@(*)
begin
if(write)
begin
PS=NS;
case(PS)
loadBurst:
	begin
	if(data==1||data==2||data==4||data==8||data==16||data==32||data==64)
	begin
	register[address] = data;
	burst = register[address];				
	NS = loadSize;
	end
	end
loadSize:
	begin
	if(data==1||data==2||data==4)
	begin
	register[address] = data;
	size = register[address];
	Ready = 1;
	end
	end
default:
	begin
	NS = loadBurst;
	end
endcase
end
end
endmodule 