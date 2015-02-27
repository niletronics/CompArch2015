//ONE FROM GITHUB
`include "defines.v"
module pdp();
/*import "DPI-C" function void cfun_kcf(int,int);
import "DPI-C" function void cfun_ksf(int,int);
import "DPI-C" function void cfun_kcc(int,int);
import "DPI-C" function void cfun_krs(int,int);
import "DPI-C" function void cfun_krb(int,int);
import "DPI-C" function void cfun_tfl(int,int);
import "DPI-C" function void cfun_tsf(int,int);
import "DPI-C" function void cfun_tcf(int,int);
import "DPI-C" function void cfun_tpc(int,int);
import "DPI-C" function void cfun_tls(int,int);
import "DPI-C" function void cfun_skon(int,int);
import "DPI-C" function void cfun_ion(int,int);
import "DPI-C" function void cfun_iof(int,int);
*/
integer file,fileout;
integer i,clk;
integer c_and,c_tad,c_isz,c_dca,c_jms,c_jmp,c_io,c_micro,c_total;
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
//      --------------------Printer (CRT) - Device #4
      i_TFL = 12'o6040,					//set prinTer FLag
      i_TSF = 12'o6041,					//Skip on prinTer Flag set
      i_TCF = 12'o6042,					//Clear prinTer Flag
      i_TPC = 12'o6044,					//load prinTer buffer with aCcu
      i_TLS = 12'o6046,					//Load prinTer Sequence ; Print
//      ------------------Interrupt System - Device #0
      i_SKON= 12'o6000,					//Skip if the interrupt system 
      i_ION = 12'o6001,					//Execute the next instruction 
      i_IOF = 12'o6002,					//Turn the interrupt system off
	//------------------Group 3 instructions
	i_CLA = 12'o7601,
	i_MQL = 12'o7421, 
	i_MQA = 12'o7501,
	i_SWP = 12'o7521,
	i_CAM = 12'o7621;

initial 
begin
$display("------------ISA Simulator---------------");
initializeVariables();
initialize();
page=PC[0:4];
offset=PC[5:11];
go=1'b1;

fileout=$fopen("output.txt","w");
while(go==1'b1&&PC!=`EOMemory)
	begin
	//$display("%h",my_memory[PC]);
	
	MemoryRead(`instruction);// 0 indicates that we are fetching instruction and we write 1 when we want data
	
	case(IR)
	   AND: begin
		c_and=c_and+1;
		effectiveAddress();// to calculate effective address
		MemoryRead(`data);// to get the contents of effective address
		AC=AC&MB;
		clk=clk+2;
		`ifdef SHOW
		$display("PC is %o and AC is %o",PC,AC);
		`endif
		end
	   TAD: begin
		c_tad=c_tad+1;
		effectiveAddress();// to calculate effective address
		MemoryRead(`data);
		{LinkBit,AC}={LinkBit,AC}+MB;
		clk=clk+2;
		`ifdef SHOW
		$display("PC is %o and AC is %o",PC,AC);
		`endif
		end
	   ISZ: begin
		c_isz=c_isz+1;
		effectiveAddress();// to calculate effective address
		MemoryRead(`data);
		MB=MB+1;
		MemoryWrite(MB);
		if(MB==0)
		    PC=PC+1;
		clk=clk+2;
		end
	   DCA: begin
		c_dca=c_dca+1;
		effectiveAddress();// to calculate effective address
		MemoryWrite(AC);
		AC=0;
		clk=clk+2;
		end
	   JMS: begin
	   	c_jms=c_jms+1;
		effectiveAddress();	
		MemoryWrite(PC+1);
		clk=clk+2;
		$display("works JMS");
		end
	   JMP: begin
		c_jmp=c_jmp+1;
		effectiveAddress();		
		clk=clk+1;
		$display("works JMP");
		end
	   IO: begin
		c_io=c_io+1;
		$display("works IO");
		end
	   M_INSTRUCTIONS: begin
		c_micro=c_micro+1;
		Group2MicroInstructions();
		Group1MicroInstructions();
		clk=clk+1;
		`ifdef SHOW
		$display("PC is %o and AC is %o",PC,AC);
		`endif
		end
endcase
if(IR==JMS)
	PC=CPMA+1;
else if(IR==JMP)
	PC=CPMA;
else
	PC=PC+1;
end
PC=PC-1;// As we are incrementing the PC after the instruction execution our PC gets incremented after hlt as well. So PC-1. 
summary();
end
//-----------------------------------------------------------------------------------------------------------------------------------------
task summary;
begin
c_total= c_and+c_tad+c_isz+c_dca+c_jms+c_jmp+c_io+c_micro;
$display("No. of AND instructions:%d",c_and);
$display("No. of TAD instructions:%d",c_tad);
$display("No. of ISZ instructions:%d",c_isz);
$display("No. of DCA instructions:%d",c_dca);
$display("No. of JMS instructions:%d",c_jms);
$display("No. of JMP instructions:%d",c_jmp);
$display("No. of IO instructions:%d",c_io);
$display("No. of MICRO instructions:%d",c_micro);
$display("No. of TOTAL instructions:%d",c_total);
$display("total clock cycles required are %d",clk);
$display("PC IS %o",PC);
$display("Last state of accumulator is %o",AC);
end

endtask
//---------------------------------------------------------------------------------------------------------------------------------------------
task initializeVariables;
begin
a=0;
clk=0;
c_and=0;c_tad=0;c_isz=0;c_dca=0;c_jms=0;c_jmp=0;c_io=0;c_micro=0;c_total=0;
//PC = 0;
//MQ=0;
//MB=0;
//CPMA=0;
//SR=0;
//AC=0;
//IR=0;
//LinkBit=0;
//page=0;
//offset=0;
//i_m=0;
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
string file_name;
begin
$value$plusargs("FILENAME=%s",file_name); // reading the file name from command line.
	if(file_name == "")  // command to write in trancript to run: vsim pdp +FILENAME="yourFileName.txt" and then run.
	$display("error- memory image file not provided please enter");
	$display("Read file=",file_name);
file = $fopen(file_name,"r");
// checking if file is not empty or invalid
if(file == `NULL) 
	begin
	$display("Error reading file");
	end
else 
	begin	
	$readmemh(file_name, my_memory);
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
	clk=clk+1;
	if(offset>7'b0000111 && offset < 7'b0010000 && i_m[1]==0)
	   begin
		    clk=clk+1;
	            CPMA= my_memory[my_memory[{5'b00000,offset}]+1];  	// 3 MEMORY ACCESS?????// confirm correctness
		    $fwrite(fileout,"%d %o \n",0,{5'b00000,offset});
		    $fwrite(fileout,"%d %o \n",0,my_memory[{5'b00000,offset}]);
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
//-----------------------------------------------------------------------------------------------------------------------------------------
task InputOutputInst;
begin

if(my_memory[PC] == i_KCF) begin KCF =1'b1; /* $display("KCF "); */ end
if(my_memory[PC] == i_KSF) begin KSF =1'b1; /* $display("KSF "); */ end
if(my_memory[PC] == i_KCC) begin KCC =1'b1; /* $display("KCC "); */ end
if(my_memory[PC] == i_KRS) begin KRS =1'b1; /* $display("KRS "); */ end
if(my_memory[PC] == i_KRB) begin KRB =1'b1; /* $display("KRB "); */ end
                         
if(my_memory[PC] == i_TFL) begin TFL =1'b1; /* $display("TFL "); */ end
if(my_memory[PC] == i_TSF) begin TSF =1'b1; /* $display("TSF "); */ end
if(my_memory[PC] == i_TCF) begin TCF =1'b1; /* $display("TCF "); */ end
if(my_memory[PC] == i_TPC) begin TPC =1'b1; /* $display("TPC "); */ end
if(my_memory[PC] == i_TLS) begin TLS =1'b1; /* $display("TLS "); */ end
                         
if(my_memory[PC]== i_SKON) begin SKON=1'b1; /* $display("SKON"); */ end
if(my_memory[PC] == i_ION) begin ION =1'b1; /* $display("ION "); */ end
if(my_memory[PC] == i_IOF) begin IOF =1'b1; /* $display("IOF "); */ end
/*if(KCF) cfun_kcf(int,int);
if(KSF) cfun_ksf(int,int);
if(KCC) cfun_kcc(int,int);
if(KRS) cfun_krs(int,int);
if(KRB) cfun_krb(int,int);
if(TFL) cfun_tfl(int,int);
if(TSF) cfun_tsf(int,int);
if(TCF) cfun_tcf(int,int);
if(TPC) cfun_tpc(int,int);
if(TLS) cfun_tls(int,int);
if(SKON) cfun_skon(int,int);
if(ION) cfun_ion(int,int);
if(IOF) cfun_iof(int,int);
*/
                                   
end
endtask
//-----------------------------------------------------------------------------------------------------------------------------------------
task Group2MicroInstructions;   
begin
	if(my_memory[PC] ==? 12'b111_1?0_001_??0) begin	SKP	=1'b1; $display("SKP"); end else SKP	=1'b0;
	if(my_memory[PC] ==? 12'b111_11?_???_??0) begin	CLA	=1'b1; $display("CLA"); end else CLA	=1'b0;
	if(my_memory[PC] ==? 12'b111_1??_???_1?0) begin	OSR	=1'b1; $display("OSR"); end else OSR	=1'b0;
	if(my_memory[PC] ==? 12'b111_1??_???_?10) begin	HLT	=1'b1; $display("HLT"); end else HLT	=1'b0;
	if(my_memory[PC] ==? 12'b111_1?1_??0_??0) begin	SMA	=1'b1; $display("SMA"); end else SMA	=1'b0;
	if(my_memory[PC] ==? 12'b111_1??_1?0_??0) begin	SZA	=1'b1; $display("SZA"); end else SZA	=1'b0;
	if(my_memory[PC] ==? 12'b111_1??_?10_??0) begin	SNL	=1'b1; $display("SNL"); end else SNL	=1'b0;
	if(my_memory[PC] ==  12'b111_100_000_000) begin	NOP	=1'b1; $display("NOP"); end else NOP	=1'b0;
	if(my_memory[PC] ==? 12'b111_1?1_??1_??0) begin	SPA	=1'b1; $display("SPA"); end else SPA	=1'b0;
	if(my_memory[PC] ==? 12'b111_1??_1?1_??0) begin	SNA	=1'b1; $display("SNA"); end else SNA	=1'b0;
	if(my_memory[PC] ==? 12'b111_1??_?11_??0) begin	SZL	=1'b1; $display("SZL"); end else SZL	=1'b0;
	//Condition checking for SubGroup
	if((SMA && AC[0]==1'b1) || (SZA && AC == 12'b0) || (SNL && LinkBit==1'b1)) ORSubgroup =1'b1;
	if((SPA && AC[0]==1'b0) && (SNA && AC != 12'b0) && (SZA && LinkBit==1'b0)) ANDSubgroup =1'b1;
	
	if(ORSubgroup || ANDSubgroup || SKP) PC++; 						//OR SubGroup, later combining common case
	//if(ANDSubgroup) PC++;						// AND SubGroup
	//if(SKP) PC++;							// Priority(1)
	if(CLA) AC = 12'b0;						// Priority (2)
	if(OSR) AC = (AC | SR);						// Priority (3)
	if(NOP) $display("NOP is encounter at PC = %h and Memory= %o",PC,my_memory[PC]);
	if(HLT) go = 1'b0;						// Priority (3) //Assuming HLT should be executed as the last instruction 
end
endtask
//-----------------------------------------------------------------------------------------------------------------------------------------
task Group1MicroInstructions;
begin
if(my_memory[PC] ==? 12'b111_000_000_000) begin	NOP = 1'b1; $display("NOP");end else NOP =1'b0;
if(my_memory[PC] ==? 12'b111_01?_???_???) begin	CLA = 1'b1; $display("CLA");end else CLA =1'b0;
if(my_memory[PC] ==? 12'b111_0?1_???_???) begin	CLL = 1'b1; $display("CLL");end else CLL =1'b0;
if(my_memory[PC] ==? 12'b111_0??_1??_???) begin	CMA = 1'b1; $display("CMA");end else CMA =1'b0;
if(my_memory[PC] ==? 12'b111_0??_?1?_???) begin	CML = 1'b1; $display("CML");end else CML =1'b0;
if(my_memory[PC] ==? 12'b111_0??_???_??1) begin	IAC = 1'b1; $display("IAC");end else IAC =1'b0;
if(my_memory[PC] ==? 12'b111_0??_??1_?0?) begin	RAR = 1'b1; $display("RAR");end else RAR =1'b0;
if(my_memory[PC] ==? 12'b111_0??_???_10?) begin	RAL = 1'b1; $display("RAL");end else RAL =1'b0;
if(my_memory[PC] ==? 12'b111_0??_??1_?1?) begin	RTR = 1'b1; $display("RTR");end else RTR =1'b0;
if(my_memory[PC] ==? 12'b111_0??_???_11?) begin	RTL = 1'b1; $display("RTL");end else RTL =1'b0;

if(NOP) $display("NOP ENCOUNTERED AT PC = %o and my_memory[PC]=%o",PC,my_memory[PC]);
if(CLA) begin
	AC = 12'b0;        // priority_1
	$display("CLA Executed CLA = %o", AC);
        end

if(CLL) LinkBit = 1'b0;

if(CMA) AC = ~AC;          // priority_2
if(CML) LinkBit = ~LinkBit;

if(IAC) AC= AC++;         // priority_3

if(RAR) begin $display("RAR Executed AC Pre = %o", AC); LinkBit= AC [11]; AC = {LinkBit,AC[0:10]}; $display("RAR Executed AC Aftervalue = %o", AC);  end  //priority_4
if(RAL) begin $display("RAL Executed AC Pre = %o", AC); LinkBit= AC [0];  AC = {AC[1:11],LinkBit}; $display("CLA Executed AC Aftervalue = %o", AC);  end
              
if(RTR) begin $display("RTR Executed AC Pre = %o", AC); LinkBit = AC [10]; AC = {AC[11], LinkBit, AC[0:9]}; end //priority_5
if(RTL) begin $display("RTL Executed AC Pre = %o", AC); LinkBit = AC [1];  AC = {AC[2:11], LinkBit, AC[0]}; end   

end
endtask

//-----------------------------------------------------------------------------------------------------------------------------------------
task Grp3MicroInstruction();
begin
integer Grp3Cnt;
if(my_memory[PC] == i_CLA ) begin	CLA =1'b1; $display("CLA"); end else CLA = 1'b0;
if(my_memory[PC] == i_MQL ) begin	MQL =1'b1; $display("MQL"); end else MQL = 1'b0;
if(my_memory[PC] == i_MQA ) begin	MQA =1'b1; $display("MQA"); end else MQA = 1'b0;
if(my_memory[PC] == i_SWP ) begin	SWP =1'b1; $display("SWP"); end else SWP = 1'b0;
if(my_memory[PC] == i_CAM ) begin	CAM =1'b1; $display("CAM"); end else CAM = 1'b0;

if(CLA) AC = 12'b0;	
if(MQL) begin 
	MQ [0:11] =  AC[0:11];
	AC [0:11] = 12'b0;
	end
if (MQA) AC = AC | MQ;
if (SWP) begin
	MQ <= AC;
	AC <= MQ;
	end
if (CAM) begin
	AC [0:11] = 12'b0;
	MQ [0:11] = 12'b0;
	end

if(CLA || MQL || MQA || SWP || CAM )
	Grp3Cnt++;
else 
	$display("Invalid Group 3 MircoInstruction at PC = %d \n Instruction = %o", PC, my_memory[PC]);
end
endtask

endmodule