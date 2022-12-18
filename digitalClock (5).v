`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:09:50 06/02/2022 
// Design Name: 
// Module Name:    digitalClock 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module digitalClock(input clk, output reg [6:0] display,output reg [3:0] bank,output reg dp);
//TEST CLOCK///////////////////////////////////////////////////////////////////////////////////////////////////////////////
reg [31:0] testcount;
initial testcount=0;

reg testclk;
initial testclk=0;

always @(posedge clk)
begin
if (testcount<10000000) testcount<=testcount+1;
else
	begin
		testcount<=0;
		testclk<=~testclk;
	end
end

//50Hz clock///////////////////////////////////////////////////////////////////////////////////////////////////////////////

reg [19:0] count1;
initial count1=0;

reg clkout50;

always @(posedge clk)
begin
count1<=count1+1;
clkout50<=count1[19];
end

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//clock with time period 2 sec i.e f=0.5Hz/////////////////////////////////////////////////////////////////////////////////
reg  [31:0] count2;
//initial count2=0;

reg clkout0;
initial clkout0=0;

always @(posedge clkout50)
begin
count2<=0;
if (count2<48) count2<=count2+1;      // 49 CHANGED TO 48      
else 
	begin
		count2<=0;
		clkout0<=~clkout0;
	end
end

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//clock with freq//1Hz/////////////////////////////////////////////////////////////////////////////////////////////////////
reg [31:0] count3;
initial count3=0;                     

reg clkout1;                     
initial clkout1=0;

always @(posedge clkout50)                   
begin
if (count3<24) count3<=count3+1;                     
else
	begin
		count3<=0;
		clkout1<=~clkout1;                     
	end
end                  
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/////////////DP ON OFF//////////////////////////////////////////////////////////////////////////////////////////////////////
reg k;
initial k=0;
initial dp=0;
always @(posedge clkout1)
begin
	k<=~k;
end
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//SECOND AND MINUTE DRIVER//////////////////////////////////////////////////////////////////////////////////////////////////

reg [31:0] second;
//initial second=0;

reg minutedriver;
initial minutedriver=0;

always @(posedge clkout0)
begin
second<=0;
if (second<13) second<=second+1;     // 28 TO 13
else
	begin
		second<=0;
		minutedriver<=~minutedriver; // MINUTE DRIVER HAS TIME PERIOD OF 2 MIN
	end
end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//MINUTE////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

reg [3:0] temp1;
reg [3:0] temp0;
reg hourdriver;

initial temp1=0;
initial temp0=0;


reg [3:0] temp11;
reg [3:0] temp10;

initial temp10=0;
initial temp11=0;


always @(posedge testclk)
//always @(posedge minutedriver)
begin

if (temp1==4'b0101 & temp0==4'b1001)
	begin
		temp0<=4'b0000;
		temp1<=4'b0000;
		if (temp11==4'b0010 & temp10==4'b0011)///////
		begin
			temp10<=4'b0000;
			temp11<=4'b0000;
		end
		else
		begin
		if (temp10<4'b1001) temp10<=temp10+1; 
		else 
		begin
			temp10<=temp10+4'b0111;
			if (temp11<4'b0010) temp11<=temp11+1;
			else 
				begin 
					temp11<=0;
					temp10<=0;
				end
		end
		end///////////////////////////////////////////
	end
else
begin
if (temp0<4'b1001) temp0<=temp0+1; 
else 
	begin
		temp0<=temp0+4'b0111;
		if (temp1<4'b0101) temp1<=temp1+1;
		else 
			begin 
				temp1<=0;
				temp0<=0;
			end
	end
end
end

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//HOURS DRIVER ///////////////////////////////////////////////////////////////////////////////////////////////////////////
/*
reg [3:0] temp11;
reg [3:0] temp10;

initial temp10=0;
initial temp11=0;

always @(posedge hourdriver)
begin
if (temp11==4'b0010 & temp10==4'b0011)
	begin
		temp10<=4'b0000;
		temp11<=4'b0000;
	end
else
begin
if (temp10<4'b1001) temp10<=temp10+1; 
else 
	begin
		temp10<=temp10+4'b0111;
		if (temp11<4'b0010) temp11<=temp11+1;
		else 
			begin 
				temp11<=0;
				temp10<=0;
			end
	end
end
end

always @(negedge hourdriver)
begin
if (temp11==4'b0010 & temp10==4'b0011)
	begin
		temp10<=4'b0000;
		temp11<=4'b0000;
	end
else
begin
if (temp10<4'b1001) temp10<=temp10+1; 
else 
	begin
		temp10<=temp10+4'b0111;
		if (temp11<4'b0010) temp11<=temp11+1;
		else 
			begin 
				temp11<=0;
				temp10<=0;
			end
	end
end
end
*/
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


//DISPLAY CONTROL COUNTER//////////////////////////////////////////////////////////////////////////////////////////////////
reg [24:0] countd;
initial countd=0;
always @(posedge clk)
begin
countd<=countd+1;
end
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


//BANK CONTROL/////////////////////////////////////////////////////////////////////////////////////////////////////////////
reg [3:0] tempd;
//initial tempd=0;
always @(*)
begin
case(countd[12:9])
4'b0000:
begin
bank<=4'b0001;
tempd<=temp0;
dp=1;
end
4'b0010:
begin
bank<=4'b0010;
tempd<=temp1;
dp=1;
end
4'b0011:
begin
bank<=4'b0100;
tempd<=temp10;
dp=k;
end
4'b0100:
begin
bank<=4'b1000;
tempd<=temp11;
dp=1;
end
endcase
end
//DISPLAY/////////////////////////////////////////////////////////////////////////////////////////////////////////////
always @(tempd)
begin
case(tempd)
0:display=7'b0000001;
1:display=7'b1001111;
2:display=7'b0010010;
3:display=7'b0000110;
4:display=7'b1001100;
5:display=7'b0100100;
6:display=7'b0100000;
7:display=7'b0001111;
8:display=7'b0000000;
9:display=7'b0000100;
10:display=7'b0001000;
11:display=7'b1100000;
12:display=7'b0110001;
13:display=7'b1000010;
14:display=7'b0110000;
15:display=7'b0111000;
endcase
end
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 
 
 
endmodule
