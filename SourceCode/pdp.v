`include "defines.v"
module pdp();
integer file,fileout;
integer i;
reg [0:31]a;
reg [0:11]PC,AC,MQ,MB,CPMA,SR;
reg [0:2] IR;
reg LinkBit;
reg [0:11] my_memory [0:4096];
reg [0:4] page;
reg [0:6] offset;

parameter AND = 3'd0,
	  TAD= 3'd1,
	  ISZ= 3'd2, 
	  DCA= 3'd3,
	  JMS= 3'd4,
	  JMP= 3'd5,
	  IO= 3'd6,
	  M_INSTRUCTIONS= 3'd7;
initial 
begin
PC = 0;
$display("------------ISA Simulator---------------");
initialize();
page=PC[0:4];
offset=PC[5:11];
fileout=$fopen("output.txt","w");
while(my_memory[PC]!=12'hf02)
	begin
	$display("%h",my_memory[PC]);
	
	IR=my_memory[PC][0:2];
	case(IR)
	   AND: begin
		$display("works");
		end
	   TAD: begin
		$display("works");
		end
	   ISZ: begin
		$display("works");
		end
	   DCA: begin
		$display("works");
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
		end
		




	endcase
	PC=PC+1;
	end
end
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
	decaddr=5000;

end
endtask
//---------------------------------------------------------------------------------------------------------------------------------------------
task initialize;
integer temp,b;
begin
file = $fopen("add01.mem","r");
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

end
endtask
//---------------------------------------------------------------------------------------------------------------------------------------------
task MemoryRead;
input [0:1] i_m;

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
	            CPMA= my_memory[my_memory[{5'b00000,offset}]+1];  	// 3 MEMORY ACCESS?????// confirm correctness
		else
		    CPMA= my_memory[my_memory[{page,offset}]+1];
           end
        else
	   begin
		if(i_m[1]==0)
		    begin
		    CPMA=my_memory[{5'b00000,offset}];// 2 memory references for these 
	            $fwrite(fileout,"%d %h",0,{5'b00000,offset});
                    end
		else
		    begin
		    CPMA=my_memory[{page,offset}];// 2 memory references for these 
	            $fwrite(fileout,"%d %h",0,{page ,offset});
		    end
	   end
	end

MB=my_memory[CPMA];

$fwrite(fileout,"%d %h",0,CPMA);
end
endtask
//---------------------------------------------------------------------------------------------------------------------------------------------
//task MemoryWrite;



//endtask
endmodule
