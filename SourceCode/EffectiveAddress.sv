module CalcEA();
reg [0:11] mem [0:4095] ; ////there are total 4096 locations although Page 0 is common page & therfore there cant be any Instructions located.But autoindexing istructins ar loacated there(o'0010-o'0017)
reg [0:11] Inst;  // this is 12 bits always .. represent in octal.. this is content of PC
reg [0:11] PC;   // Inst = Contents of (PC)  ... range . Where PC can be one of those 4096 locations. Inst= mem [PC];
reg [0:11] EAddrs;
reg [0:11] PC_tp;
reg [0:11] PC_tp1;


initial
begin 
PC=12'o0104;
PC_tp= 12'o0017;
PC_tp1= 12'o4105;

mem [PC] = 12'o1617;
mem [PC_tp] = 12'o4104;
Inst= mem [PC];
EA(PC, Inst, EAddrs);
$display("EAddress is %o", EAddrs);
end



task EA;
input PC_temp;
input Inst_temp;
output EA_temp;

reg [0:11] PC_temp;
reg [0:11] Inst_temp;
reg [0:11] EA_temp;

reg [0:11] EA_interim;
reg [0:11] Inst_interim;
//integer [0:11] AutoIndex;

begin
	if (Inst_temp[3]==0 && Inst_temp[4]==0 )  // direct mode and page 0
		begin
		 EA_temp [0:4]  = 5'b00000;
		 EA_temp [5:11] = Inst_temp [5:11];
		end
	else if ((Inst_temp[3]==0 && Inst_temp[4]==1 )) // direct mode and current page
                begin
		 EA_temp [0:4]  = PC [0:4];
		 EA_temp [5:11] = Inst_temp [5:11];
		end
	else if (Inst_temp[3]== 1 ) //Indirect mode and page 0
             begin
		  if (Inst_temp[4]== 0)
		     begin
		 	EA_interim [0:4]  = 5'b0000;
		 	EA_interim [5:11] = Inst_temp [5:11];
		 	$display("EA interim %o",EA_interim);	// check if EA interim is in the range of 0010-0017
			if (EA_interim>=12'o0010 && EA_interim<= 12'o0017)
			       mem [EA_interim] = mem [EA_interim] +1;
	                   EA_temp = mem [EA_interim];
		      end
		  else if(Inst_temp[4]== 1)
		     begin
			EA_interim [0:4]  = PC [0:4];
		 	EA_interim [5:11] = Inst_temp [5:11];   // check if EA interim is in the range of 0010-0017
		 	if (EA_interim>=12'o0010 && EA_interim<= 12'o0017)
			    mem [EA_interim] = mem [EA_interim] +1;			      	
	                  EA_temp = mem [EA_interim];
		     end
	       end
                
end
endtask
endmodule
