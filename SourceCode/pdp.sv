//ONE FROM GITHUB
`include "defines.v"
module pdp();
integer file,fileout;
integer i;
reg [0:31]a;
reg [0:11]PC,MQ,MB,CPMA,SR;
reg [0:11]AC;
reg [0:2] IR;
reg LinkBit,go;
reg [0:11] my_memory [0:4096];
reg [0:4] page;
reg [0:6] offset;
reg [0:1] i_m;// to store i and m bits of instruction
//----------------Register Declaration for InputOutputInst ---------------------//
reg KCF  =1'b0;	
reg KSF  =1'b0;
reg KCC  =1'b0;
reg KRS  =1'b0;
reg KRB  =1'b0;
reg TFL  =1'b0;
reg TSF  =1'b0;
reg TCF  =1'b0;
reg TPC  =1'b0;
reg TLS  =1'b0;
reg SKON =1'b0;
reg ION  =1'b0;
reg IOF  =1'b0;
//--------------------------Group 1 Microinstructions (Bit 3 = 0)
reg NOP = 1'b0;					//No Operation
reg CLA = 1'b0;					//CLear Accumulator (1)
reg CLL = 1'b0;					//CLear Link (1)
reg CMA = 1'b0;					//CoMplement Accumulator (2)
reg CML = 1'b0;					//CoMplement Link (2)
reg IAC = 1'b0;					//Increment ACumulator (3)
reg RAR = 1'b0;					//Rotate Accumulator and link Right (4)
reg RTR = 1'b0;					//Rotate accumulator and link Right Twice (4)
reg RAL = 1'b0;					//Rotate Accumulator and link Left (4)
reg RTL = 1'b0;					//Rotate Accumulator and link left Twice (4)
//-------Group 2 Microinstructions (Bit 3 = 1, Bit 11 = 0) 
reg SMA = 1'b0;					//Skip on Minus Accumulator (1)
reg SZA = 1'b0;					//Skip on Zero Accumulator (1)
reg SNL = 1'b0;					//Skip on Nonzero Link (1)
reg SPA = 1'b0;					//Skip on Positive Accumulator (1)
reg SNA = 1'b0;					//Skip on Nonzero Accumulator (1)
reg SZL = 1'b0;					//Skip on Zero Link (1)
reg SKP = 1'b0;					//SKiP always (1)
//reg CLA = 1'b0;					//CLear Accumulator (2)
reg OSR = 1'b0;					//Or Switch Register with accumulator (3)
reg HLT = 1'b0;					//HaLT (3)
//-------Group 3 Microinstructions (Bit 3 = 1, Bit 11 = 1) 
//reg CLA = 1'b0;					//CLear Accumulator (1)
reg MQL = 1'b0;					//Load MQ register from AC and Clear AC (2); C(MQ) <- C(AC); C(AC) <- 0;
reg MQA = 1'b0;					//Or AC with MQ register (2) ; C(AC) <- C(AC) Or C(MQ)
reg SWP = 1'b0;					//SWap AC and MQ registers (3)
reg CAM = 1'b0;					//Clear AC and MQ registers (3)
reg ORSubgroup =1'b0;			// Condition for ORSubGroup 1'b1 = True, 1'b0 = False
reg ANDSubgroup =1'b0;			// Condition for ANDSubgroup  1'b1 = True, 1'b0 = False


parameter AND = 3'd0,
	  TAD= 3'd1,
	  ISZ= 3'd2, 
	  DCA= 3'd3,
	  JMS= 3'd4,
	  JMP= 3'd5,
	  IO= 3'd6,
	  M_INSTRUCTIONS= 3'd7,
	  i_KCF = 12'o6030,				//Clear Keyboard Flag
      	  i_KSF = 12'o6031,					//Skip on Keyboard Flag set
      	  i_KCC = 12'o6032,					//Clear Keyboard flag and aCcum
          i_KRS = 12'o6034,					//Read Keyboard buffer Static A
          i_KRB = 12'o6036,					//Read Keyboard Buffer dynamic 
//          --------------------Printer (CRT) - Device #4
          i_TFL = 12'o6040,					//set prinTer FLag
          i_TSF = 12'o6041,					//Skip on prinTer Flag set
          i_TCF = 12'o6042,					//Clear prinTer Flag
          i_TPC = 12'o6044,					//load prinTer buffer with aCcu
          i_TLS = 12'o6046,					//Load prinTer Sequence ; Print
//          ------------------Interrupt System - Device #0
          i_SKON= 12'o6000,					//Skip if the interrupt system 
          i_ION = 12'o6001,					//Execute the next instruction 
          i_IOF = 12'o6002;					//Turn the interrupt system off

initial 
begin
$display("------------ISA Simulator---------------");
initializeVariables();
initialize();
page=PC[0:4];
offset=PC[5:11];
go=1'b1;
fileout=$fopen("output.txt","w");
while(my_memory[PC]!=12'hf02&&go==1'b1)
	begin
	$display("%h",my_memory[PC]);
	
	MemoryRead(0);// 0 indicates that we are fetching instruction and we write 1 when we want data
	effectiveAddress();// to calculate effective address
	case(IR)
	   AND: begin
		MemoryRead(1);// to get the contents of effective address
		AC=AC&MB;
		end
	   TAD: begin
		MemoryRead(1);
		{LinkBit,AC}={LinkBit,AC}+MB;
		end
	   ISZ: begin
		MemoryRead(1);
		MB=MB+1;
		MemoryWrite(MB);
		if(MB==0)
		    PC=PC+1;
		end
	   DCA: begin
		MemoryWrite(AC);
		AC=0;
		end
	   JMS: begin
		$display("works");
		end
	   JMP: begin
		$display("works");
		end
	   IO: begin
		$display("works");
		end
	   M_INSTRUCTIONS: begin
		$display("works");
		Group2MicroInstructions();
		end
		




	endcase
	PC=PC+1;
	end
end
//---------------------------------------------------------------------------------------------------------------------------------------------
task initializeVariables;
begin
a=0;
PC = 0;
MQ=0;
MB=0;
CPMA=0;
SR=0;
AC=0;
IR=0;
LinkBit=0;
page=0;
offset=0;
i_m=0;
end
endtask
//---------------------------------------------------------------------------------------------------------------------------------------------
task intaddress;
input [0:31]a1;
output decaddr;
integer decaddr,x,y,z,flag,address;
begin
flag=0;
if(a1[8:15]>47&&a1[8:15]<58)
	x=48;
else if(a1[8:15]>64&&a1[8:15]<71)
	x=55;
else if(a1[8:15]>96&&a1[8:15]<103)
	x=87;
else
	flag=1;
if(a1[16:23]>47&&a1[16:23]<58)
	y=48;
else if(a1[16:23]>64&&a1[16:23]<71)
	y=55;
else if(a1[16:23]>96&&a1[16:23]<103)
	y=87;
else
	flag=1;
if(a1[24:31]>47&&a1[24:31]<58)
	z=48;
else if(a1[24:31]>64&&a1[24:31]<71)
	z=55;
else if(a1[24:31]>96&&a1[24:31]<103)
	z=87;
else
	flag=1;

if(flag==0)
	begin
	decaddr=((a1[8:15]-x)*256)+((a1[16:23]-y)*16)+(a1[24:31]-z);
	//$display("dec address %d",decaddr);
	end
else
	decaddr=5000;// not a vaild address.
	
end
endtask
//---------------------------------------------------------------------------------------------------------------------------------------------
task initialize;
integer temp,b;
begin
file = $fopen("CLA1.mem","r");
// checking if file is not empty or invalid
if(file == `NULL) 
	begin
	$display("Error reading file");
	end
else 
	begin	
	$readmemh("add01.mem", my_memory);
	/*for(i=0;i<4095;i=i+1)  // to display contents of memory
	   begin
	   if(my_memory[i]!==12'hxxx)
           $display("%d %h",i,my_memory[i]);
	   end*/
	b=$fscanf(file,"%s",a);
	if(a[0:7]=="@")
	   begin
	   $display("yes");
	   intaddress(a,temp);
	   if(temp!=5000)
	      PC=temp;
	   else
	      $display("Invalid Address");
	   end
	else
	   PC=128;
	end
$display("PC is %d",PC);
// to do: close the filee.
end
endtask
//---------------------------------------------------------------------------------------------------------------------------------------------
task effectiveAddress;
begin
if(i_m==2'b00)
	CPMA={5'b00000,offset};
else if(i_m==2'b01)
	CPMA={page,offset};
else if(i_m[0]==1)
	begin
	if(offset>7'b0000111 && offset < 7'b0010000)
	   begin
		if(i_m[1]==0)
		    begin
	            CPMA= my_memory[my_memory[{5'b00000,offset}]+1];  	// 3 MEMORY ACCESS?????// confirm correctness
		    $fwrite(fileout,"%d %o \n",0,{5'b00000,offset});
		    $fwrite(fileout,"%d %o \n",0,my_memory[{5'b00000,offset}]);
		    end
		else
		    begin
		    CPMA= my_memory[my_memory[{page,offset}]+1];
		    $fwrite(fileout,"%d %o \n",0,{page ,offset});
		    $fwrite(fileout,"%d %o \n",0,my_memory[{page ,offset}]);

		    end
           end
        else
	   begin
		if(i_m[1]==0)
		    begin
		    CPMA=my_memory[{5'b00000,offset}];// 2 memory references for these 
	            $fwrite(fileout,"%d %o \n",0,{5'b00000,offset});
                    end
		else
		    begin
		    CPMA=my_memory[{page,offset}];// 2 memory references for these 
	            $fwrite(fileout,"%d %o \n",0,{page ,offset});
		    end
	   end
	end
end
endtask
//---------------------------------------------------------------------------------------------------------------------------------------------
task MemoryRead;
input i;
integer i;

begin
if(i==0)// instruction fetch
	begin
        IR=my_memory[PC][0:2];
	i_m=my_memory[PC][3:4];
	offset=my_memory[PC][5:11];// this offset will be used in effective address calculation
	page=PC[0:4];
	 $fwrite(fileout,"%d %o \n",2,PC);
	end
else
begin
MB=my_memory[CPMA];
$fwrite(fileout,"%d %o \n",0,CPMA);
end
end
endtask
//---------------------------------------------------------------------------------------------------------------------------------------------
task MemoryWrite;
input reg [0:11] out_data; 
begin
MB=out_data;
my_memory[CPMA]=MB;
$fwrite(fileout,"%d %o \n",1,CPMA);
end
endtask

task InputOutputInst;
begin

if(my_memory[PC] == i_KCF) begin KCF <=1'b1; /* $display("KCF "); */ end
if(my_memory[PC] == i_KSF) begin KSF <=1'b1; /* $display("KSF "); */ end
if(my_memory[PC] == i_KCC) begin KCC <=1'b1; /* $display("KCC "); */ end
if(my_memory[PC] == i_KRS) begin KRS <=1'b1; /* $display("KRS "); */ end
if(my_memory[PC] == i_KRB) begin KRB <=1'b1; /* $display("KRB "); */ end
                         
if(my_memory[PC] == i_TFL) begin TFL <=1'b1; /* $display("TFL "); */ end
if(my_memory[PC] == i_TSF) begin TSF <=1'b1; /* $display("TSF "); */ end
if(my_memory[PC] == i_TCF) begin TCF <=1'b1; /* $display("TCF "); */ end
if(my_memory[PC] == i_TPC) begin TPC <=1'b1; /* $display("TPC "); */ end
if(my_memory[PC] == i_TLS) begin TLS <=1'b1; /* $display("TLS "); */ end
                         
if(my_memory[PC]== i_SKON) begin SKON<=1'b1; /* $display("SKON"); */ end
if(my_memory[PC] == i_ION) begin ION <=1'b1; /* $display("ION "); */ end
if(my_memory[PC] == i_IOF) begin IOF <=1'b1; /* $display("IOF "); */ end
                                   
end
endtask

task Group2MicroInstructions;   
begin
	if(my_memory[PC] ==? 12'b111_1?0_001_??0) begin	SKP	<=1'b1; $display("SKP"); end else SKP	<=1'b0;
	if(my_memory[PC] ==? 12'b111_11?_???_??0) begin	CLA	<=1'b1; $display("CLA"); end else CLA	<=1'b0;
	if(my_memory[PC] ==? 12'b111_1??_???_1?0) begin	OSR	<=1'b1; $display("OSR"); end else OSR	<=1'b0;
	if(my_memory[PC] ==? 12'b111_1??_???_?10) begin	HLT	<=1'b1; $display("HLT"); end else HLT	<=1'b0;
	if(my_memory[PC] ==? 12'b111_1?1_??0_??0) begin	SMA	<=1'b1; $display("SMA"); end else SMA	<=1'b0;
	if(my_memory[PC] ==? 12'b111_1??_1?0_??0) begin	SZA	<=1'b1; $display("SZA"); end else SZA	<=1'b0;
	if(my_memory[PC] ==? 12'b111_1??_?10_??0) begin	SNL	<=1'b1; $display("SNL"); end else SNL	<=1'b0;
	if(my_memory[PC] ==? 12'b111_100_000_000) begin	NOP	<=1'b1; $display("NOP"); end else NOP	<=1'b0;
	if(my_memory[PC] ==? 12'b111_1?1_??1_??0) begin	SPA	<=1'b1; $display("SPA"); end else SPA	<=1'b0;
	if(my_memory[PC] ==? 12'b111_1??_1?1_??0) begin	SNA	<=1'b1; $display("SNA"); end else SNA	<=1'b0;
	if(my_memory[PC] ==? 12'b111_1??_?11_??0) begin	SZL	<=1'b1; $display("SZL"); end else SZL	<=1'b0;
	//Condition checking for SubGroup
	if((SMA && AC[0]==1'b1) || (SZA && AC == 12'b0) || (SNL && LinkBit==1'b1)) ORSubgroup <=1'b1;
	if((SPA && AC[0]==1'b0) && (SNA && AC != 12'b0) && (SZA && LinkBit==1'b0)) ANDSubgroup <=1'b1;
	
	if(ORSubgroup || ANDSubgroup || SKP) PC++; 						//OR SubGroup, later combining common case
	//if(ANDSubgroup) PC++;						// AND SubGroup
	//if(SKP) PC++;								// Priority(1)
	if(CLA) AC = 12'b0;							// Priority (2)
	if(OSR) AC = (AC | SR);						// Priority (3)
	if(HLT) go = 1'b1;									// Priority (3) //Assuming HLT should be executed as the last instruction 
end
endtask


endmodule