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

if(CLA | MQL | MQA | SWP | CAM )
	Grp3Cnt++;
else 
	$display("Invalid Group 3 MircoInstruction at PC = %d \n Instruction = %o", PC, my_memory[PC]);

end
endtask

	










/*
parameter

i_CLA = 12'o7601,
i_MQL = 12'o7421, 
i_MQA = 12'o7501,
i_SWP = 12'o7521,
i_CAM = 12'o7621;
*/