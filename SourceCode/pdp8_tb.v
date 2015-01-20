// ECE 586 Project


`include "defines.v"

module 
();

integer file,c,r;
integer PC;
reg [7:0] my_memory [0:255];

initial begin : fileblock
PC = 0;
$display("------------ISA Simulator---------------");
file = fopen("memory.list","r");

if(file == `NULL) begin
		disable fileblock;
		$display("Error reading file");
	end
	else begin	
		$readmemh("memory.list", my_memory);
		$display("%h,my_memory);
	end
end fileblock


endmodule
