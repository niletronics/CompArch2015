integer file,fileout;
integer i,continue;
reg [0:31]a;
reg [0:11]PC,MQ,MB,CPMA,SR;
reg [0:11]AC;
reg [0:2] IR;
reg LinkBit;
reg [0:11] my_memory [0:4096];
reg [0:4] page;
reg [0:6] offset;
reg [0:1] i_m;// to store i and m bits of instruction

parameter AND = 3'd0,
	  TAD= 3'd1,
	  ISZ= 3'd2, 
	  DCA= 3'd3,
	  JMS= 3'd4,
	  JMP= 3'd5,
	  IO= 3'd6,
	  M_INSTRUCTIONS= 3'd7;
/*-----------------------------------------------Parameters-------------------------------------*/
//-------------------------------Keyboard - Device #3
parameter i_KCF = 12'o6030;					//Clear Keyboard Flag
parameter i_KSF = 12'o6031;					//Skip on Keyboard Flag set
parameter i_KCC = 12'o6032;					//Clear Keyboard flag and aCcumulator
parameter i_KRS = 12'o6034;					//Read Keyboard buffer Static AC4..AC11 <- AC4..AC11 OR Keyboard Buffer
parameter i_KRB = 12'o6036;					//Read Keyboard Buffer dynamic C(AC) <- 0; Keyboard Flag <- 0; AC4..AC11 <- AC4..AC11 OR Keyboard Buffer
//----------------------------Printer (CRT) - Device #4
parameter i_TFL = 12'o6040;					//set prinTer FLag
parameter i_TSF = 12'o6041;					//Skip on prinTer Flag set
parameter i_TCF = 12'o6042;					//Clear prinTer Flag
parameter i_TPC = 12'o6044;					//load prinTer buffer with aCcumulator and Print Printer Buffer <- AC4-11
parameter i_TLS = 12'o6046;					//Load prinTer Sequence ; Printer Flag <- 0; Printer Buffer <- AC4-11 
//--------------------------Interrupt System - Device #0
parameter i_SKON = 12'o6000;				//Skip if the interrupt system is on and turn the interrupt system off
parameter i_ION = 12'o6001;					//Execute the next instruction then turn the interrupt system on
parameter i_IOF = 12'o6002;					//Turn the interrupt system off
//--------------------------Group 1 Microinstructions (Bit 3 = 0)
reg NOP;					//No Operation
reg CLA;					//CLear Accumulator (1)
reg CLL;					//CLear Link (1)
reg CMA;					//CoMplement Accumulator (2)
reg CML;					//CoMplement Link (2)
reg IAC;					//Increment ACumulator (3)
reg RAR;					//Rotate Accumulator and link Right (4)
reg RTR;					//Rotate accumulator and link Right Twice (4)
reg RAL;					//Rotate Accumulator and link Left (4)
reg RTL;					//Rotate Accumulator and link left Twice (4)
//-------Group 2 Microinstructions (Bit 3 = 1, Bit 11 = 0) 
reg SMA;					//Skip on Minus Accumulator (1)
reg SZA;					//Skip on Zero Accumulator (1)
reg SNL;					//Skip on Nonzero Link (1)
reg SPA;					//Skip on Positive Accumulator (1)
reg SNA;					//Skip on Nonzero Accumulator (1)
reg SZL;					//Skip on Zero Link (1)
reg SKP;					//SKiP always (1)
reg CLA;					//CLear Accumulator (2)
reg OSR;					//Or Switch Register with accumulator (3)
reg HLT;					//HaLT (3)
//-------Group 3 Microinstructions (Bit 3 = 1, Bit 11 = 1) 
reg CLA;					//CLear Accumulator (1)
reg MQL;					//Load MQ register from AC and Clear AC (2); C(MQ) <- C(AC); C(AC) <- 0;
reg MQA;					//Or AC with MQ register (2) ; C(AC) <- C(AC) Or C(MQ)
reg SWP;					//SWap AC and MQ registers (3)
reg CAM;					//Clear AC and MQ registers (3)


task Group2MicroInstructions;   
if(my_memory[PC] ==? 111_1?0_001_??0)	SKP	<=1'b1;
if(my_memory[PC] ==? 111_11?_???_??0)	CLA	<=1'b1;
if(my_memory[PC] ==? 111_1??_???_1?0)	OSR	<=1'b1;
if(my_memory[PC] ==? 111_1??_???_?10)	HLT	<=1'b1;
										      

begin
if(my_memory[PC][8] == 1'b0) begin						// OR SubGroup
	if(my_memory[PC][5] == 1'b1 && AC[0] == 1'b1)   	//Skip Minus Accumulator
		i_sma = true
		PC = PC + 1'b1;
	if(my_memory[PC][6] == 1'b1 && AC == 0) 			//Skip Zero Accumulator
		PC = PC + 1'b1;
	if(my_memory[PC][7] == 1'b1 && LinkBit == 1'b1)  	//Skip Non-zero Link
		PC = PC + 1'b1;
end
     
	
if(my_memory[PC][8] == 1'b1) begin												//AND subgroup
	if(my_memory[PC] == 12'b111_101_001_000 && AC[0] == 1'b0)					//Skip Positive Accumulator
		PC = PC + 1'b1;
	if(my_memory[PC] == 12'b111_100_101_000 && AC != 12'b000_000_000_000)		//Skip Non-zero Accumulator
		PC=PC + 1'b1;  
	if(my_memory[PC] == 12'b111_100_011_000 && LinkBit == 1'b0)					//Skip on Zero Link
		PC=PC + 1'b1;   
    if(my_memory[PC] == 12'b111_101_101_000) begin     							//SPA or SNA
		if((AC[0] == 1'b0) && (AC != 0))
			PC=PC + 1'b1;   
	end
	if(my_memory[PC] == 12'b111_101_011_000) begin     							//SPA or SZL
		if((AC[0] == 1'b0) && (LinkBit == 1'b0))
			PC=PC + 1'b1; 
		end 
        
		if(my_memory[PC] == 12'b111_101_111_000) begin						//SPA or SNA or SZL
			if((AC[0] == 1'b0) && (AC != 0) && (LinkBit == 1'b0)) 			//SPA or SNA or SZL
				PC=PC + 1'b1; 
		end
		if(my_memory[PC] == 12'b111_100_111_000) begin 						//SNA or SZL
			if((AC != 0) && (LinkBit == 1'b0))
                      PC=PC + 1'b1; 
		end
end 
                
if(my_memory[PC] == 12'b111_100_001_000)    								//Skip Always
	PC = PC + 1'b1;                       
if(my_memory[PC][4] == 1'b1)            									//Clear Accumulator
	AC = 0;
if(my_memory[PC] == 12'b111_100_000_100)  									//OR Accumulator with Switch Register
	AC = (AC | SR);
if(my_memory[PC] == 12'b111_100_000_010)   									// Halt
	exit = 1'b1; // Exit to be defined
end                       
endtask