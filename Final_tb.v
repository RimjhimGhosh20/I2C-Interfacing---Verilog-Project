`timescale 10ns/1ns
module final_tb;

reg clk;
reg [3:0]address;
reg [31:0]data;
reg [31:0]TXIn;
reg write;
reg WriteBit;
reg [6:0]SlaveAddress;
reg reset;


final f1(clk, address, data, write, WriteBit, SlaveAddress, reset, TXIn);

initial
begin

clk = 1;
reset =1;
write = 0;
#5 write = 1; reset =0;
#5 address = 4;		//address to store burst
   data = 32'h2;		//burst length

#10 address = 8;	//address to store size
    data = 32'h4;	//size length
#10
SlaveAddress = 1;
WriteBit=1;

#160 TXIn <= 7;
#10 TXIn <= 15;
end


always
begin
#5 clk = ~clk;
end

endmodule

