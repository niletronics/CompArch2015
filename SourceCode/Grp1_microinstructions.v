module Group1();
reg [0:11] my_memory [0:4095];
reg [0:11] PC;
reg [0:11] Inst,AC;
reg LinkBit;

initial
begin 
if (Inst[3]==0)
	Group1_microinstructions(Inst);  // Increase the counter
$display ("Acmulator is %o, AC");
end

task Group1_microinstructions;
input Inst;

reg [0:11] Inst;

 if (Inst[4]==1)   //clear accumulator
    AC=0;
 else if (Inst[5]==1'b1)   // clear link bit
    LinkBit =0;
 else if (Inst[6]==1'b1)  // complement Accumulator
    AC=~AC;
 else if (Inst[7]==1'b1)  // complement link
    LinkBit=~LinkBit;
 else if (Inst[8]==1'b1)   // Rotate right 
   begin
	if (Inst[10]==1'b0)   //Rotate right by one position
	  begin
           LinkBit= AC [11];
           AC= {LinkBit,AC[0:10]};
	  end	
	else if (Inst[10]==1'b1)  //Rotate right by two position
	  begin
           LinkBit= AC [10];
           AC= {AC[11], LinkBit, AC[0:9]};
	  end
   end

 else if (Inst[9]==1'b1)   //Rotate left
   begin
	if (Inst[10]==1'b0)   //Rotate left by one position
	  begin
           LinkBit= AC [0];
           AC= {AC[1:11],LinkBit};
	  end	
	else if (Inst[10]==1'b1)  //Rotate right by two position
	  begin
           LinkBit= AC [1];
           AC= {AC[2:11], LinkBit, AC[0]};
	  end   
   end
 else if (Inst[11]==1'b1 )  // Increment Accumulator
   AC = AC+1 ;	
		
	


endtask


endmodule
