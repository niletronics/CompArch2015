`include "defines.v"

module tb();

integer file,c,r;
integer PC,i;
reg [11:0] my_memory [0:4096];

initial begin
PC = 0;
$display("------------ISA Simulator---------------");
file = $fopen("add01.mem","r");
// checking if file is not empty or invalid
if(file == `NULL) begin
		//disable fileblock;
		$display("Error reading file");
	          end
	else begin	
		$readmemh("add01.mem", my_memory);
		for(i=50;i<150;i=i+1)
		begin
		   if(my_memory[i]!==12'hxxx)
		   $display("%d %h",i,my_memory[i]);
		end
	     end
end //fileblock
endmodule
