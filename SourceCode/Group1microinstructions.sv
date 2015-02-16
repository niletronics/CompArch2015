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


task Group1MicroInstructions;
begin
if(my_memory[PC] ==? 12'b111_000_000_000) begin	NOP <=1'b1; $display("NOP");end else NOP <=1'b0;
if(my_memory[PC] ==? 12'b111_01?_???_???) begin	CLA <=1'b1; $display("CLA");end else CLA <=1'b0;
if(my_memory[PC] ==? 12'b111_0?1_???_???) begin	CLL <=1'b1; $display("CLL");end else CLL <=1'b0;
if(my_memory[PC] ==? 12'b111_0??_1??_???) begin	CMA <=1'b1; $display("CMA");end else CMA <=1'b0;
if(my_memory[PC] ==? 12'b111_0??_?1?_???) begin	CML <=1'b1; $display("CML");end else CML <=1'b0;
if(my_memory[PC] ==? 12'b111_0??_???_??1) begin	IAC <=1'b1; $display("IAC");end else IAC <=1'b0;
if(my_memory[PC] ==? 12'b111_0??_??1_?0?) begin	RAR <=1'b1; $display("RAR");end else RAR <=1'b0;
if(my_memory[PC] ==? 12'b111_0??_???_10?) begin	RAL <=1'b1; $display("RAL");end else RAL <=1'b0;
if(my_memory[PC] ==? 12'b111_0??_??1_?1?) begin	RTR <=1'b1; $display("RTR");end else RTR <=1'b0;
if(my_memory[PC] ==? 12'b111_0??_???_11?) begin	RTL <=1'b1; $display("RTL");end else RTL <=1'b0;

if(NOP) 
if(CLA) AC= 12'b0;        // priority_1
if(CLL) LinkBit= 1'b0;

if(CMA) AC= ~AC;          // priority_2
if(CML) LinkBit= ~LinkBit;

if(IAC) AC= AC+1;         // priority_3

if(RAR) begin LinkBit= AC [11]; AC= {LinkBit,AC[0:10]}; end  //priority_4
if(RAL) begin LinkBit= AC [0];  AC= {AC[1:11],LinkBit}; end

if(RTR) begin LinkBit= AC [10]; AC= {AC[11], LinkBit, AC[0:9]}; end //priority_5
if(RTL) begin LinkBit= AC [1];  AC= {AC[2:11], LinkBit, AC[0]}; end   



endtask
