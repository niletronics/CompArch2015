task Group2MicroInstructions;   
begin
if(my_memory[PC][8] == 0) begin
	if(my_memory[PC][5] == 1'b1 && AC[0] == 1'b1)   	//Skip Minus Accumulator
		PC = PC + 1'b1;
	if(my_memory[PC][6] == 1'b1 && AC == 0) 			//Skip Zero Accumulator
		PC = PC + 1'b1;
	if(my_memory[PC][7] == 1'b1 && LinkBit == 1'b1)  	//Skip Nonzero Link
		PC = PC + 1'b1;
end
     
	
if(my_memory[PC][8] == 1'b1) begin										//AND subgroup
	if(my_memory[PC] == 12'b111_101_001_000 && AC[0] == 1'b0)			//Skip Positive Accumulator
		PC = PC + 1'b1;
	if(my_memory[PC] == 12'b111_100_101_000 && AC != 12'b000_000_000_000)		//Skip Nonzero Accumulator
		PC=PC + 1'b1;  
	if(my_memory[PC] == 12'b111_100_011_000 && LinkBit == 1'b0)			//Skip on Zero Link
		PC=PC + 1'b1;   
    if(my_memory[PC] == 12'b111_101_101_000) begin     					//SPA or SNA
		if((AC[0] == 1'b0) && (AC != 0))
			PC=PC + 1'b1;   
	end
	if(my_memory[PC] == 12'b111_101_011_000) begin     					//SPA or SZL
		if((AC[0] == 1'b0) && (LinkBit == 1'b0))
			PC=PC + 1'b1; 
		end 
        
		if(my_memory[PC] == 12'b111_101_111_000) begin						//SPA or SNA or SZL
			if((AC[0] == 1'b0) && (AC != 0) && (LinkBit == 1'b0)) //SPA or SNA or SZL
				PC=PC + 1'b1; 
		end
		if(my_memory[PC] == 12'b111_100_111_000) begin //SNA or SZL
			if((AC != 0) && (LinkBit == 1'b0))
                      PC=PC + 1'b1; 
		end
end 
                
if(my_memory[PC] == 12'b111_100_001_000)    //Skip Always
	PC = PC + 1'b1;                       
if(my_memory[PC][4] == 1'b1)             //Clear Accumulator
	AC = 0;
if(my_memory[PC] == 12'b111_100_000_100)    //OR Accumulator with Switch Register
	AC = (AC | SR);
if(my_memory[PC] == 12'b111_100_000_010)    // Halt
	exit = 1'b1; // Exit to be defined
end                       
endtask