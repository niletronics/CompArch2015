/*-----------------------------------------------Parameters-------------------------------------*/
//-------------------------------Keyboard - Device #3
parameter KCF = 12'o6030;					//Clear Keyboard Flag
parameter KSF = 12'o6031;					//Skip on Keyboard Flag set
parameter KCC = 12'o6032;					//Clear Keyboard flag and aCcumulator
parameter KRS = 12'o6034;					//Read Keyboard buffer Static AC4..AC11 <- AC4..AC11 OR Keyboard Buffer
parameter KRB = 12'o6036;					//Read Keyboard Buffer dynamic C(AC) <- 0; Keyboard Flag <- 0; AC4..AC11 <- AC4..AC11 OR Keyboard Buffer
//----------------------------Printer (CRT) - Device #4
parameter TFL = 12'o6040;					//set prinTer FLag
parameter TSF = 12'o6041;					//Skip on prinTer Flag set
parameter TCF = 12'o6042;					//Clear prinTer Flag
parameter TPC = 12'o6044;					//load prinTer buffer with aCcumulator and Print Printer Buffer <- AC4-11
parameter TLS = 12'o6046;					//Load prinTer Sequence ; Printer Flag <- 0; Printer Buffer <- AC4-11 
//--------------------------Interrupt System - Device #0
parameter SKON = 12'o6000;					//Skip if the interrupt system is on and turn the interrupt system off
parameter ION = 12'o6001;					//Execute the next instruction then turn the interrupt system on
parameter IOF = 12'o6002;					//Turn the interrupt system off
//--------------------------Group 1 Microinstructions (Bit 3 = 0)
parameter NOP = 12'o7000;					//No Operation
parameter CLA = 12'o7200;					//CLear Accumulator (1)
parameter CLL = 12'o7100;					//CLear Link (1)
parameter CMA = 12'o7040;					//CoMplement Accumulator (2)
parameter CML = 12'o7020;					//CoMplement Link (2)
parameter IAC = 12'o7001;					//Increment ACumulator (3)
parameter RAR = 12'o7010;					//Rotate Accumulator and link Right (4)
parameter RTR = 12'o7012;					//Rotate accumulator and link Right Twice (4)
parameter RAL = 12'o7004;					//Rotate Accumulator and link Left (4)
parameter RTL = 12'o7006;					//Rotate Accumulator and link left Twice (4)
//-------------------------Group 2 Microinstructions (Bit 3 = 1, Bit 11 = 0) 
parameter SMA = 12'o7500;					//Skip on Minus Accumulator (1)
parameter SZA = 12'o7440;					//Skip on Zero Accumulator (1)
parameter SNL = 12'o7420;					//Skip on Nonzero Link (1)
parameter SPA = 12'o7510;					//Skip on Positive Accumulator (1)
parameter SNA = 12'o7450;					//Skip on Nonzero Accumulator (1)
parameter SZL = 12'o7430;					//Skip on Zero Link (1)
parameter SKP = 12'o7410;					//SKiP always (1)
parameter CLA = 12'o7600;					//CLear Accumulator (2)
parameter OSR = 12'o7404;					//Or Switch Register with accumulator (3)
parameter HLT = 12'o7402;					//HaLT (3)
//-------------------------Group 3 Microinstructions (Bit 3 = 1, Bit 11 = 1) 
//parameter CLA = 12'o7601;					//CLear Accumulator (1)
parameter MQL = 12'o7421;					//Load MQ register from AC and Clear AC (2); C(MQ) <- C(AC); C(AC) <- 0;
parameter MQA = 12'o7501;					//Or AC with MQ register (2) ; C(AC) <- C(AC) Or C(MQ)
parameter SWP = 12'o7521;					//SWap AC and MQ registers (3)
parameter CAM = 12'o7621;					//Clear AC and MQ registers (3)

 
 
 
 
 
 
 
task Group2MicroInstructions;   
begin
if(my_memory[PC][8] == 1'b0) begin
	if(my_memory[PC][5] == 1'b1 && AC[0] == 1'b1)   	//Skip Minus Accumulator
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