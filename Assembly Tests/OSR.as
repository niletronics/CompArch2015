/ INSTRUCTION : OSR

*200
Main,	cla cll		/ Clear Accumulator, Link
		tad A		/ Add A to accumulator. ACC = 37.
		osr 		/ 
		dca C		/ C = 4114
		hlt			/ Halt
	
*1750				/ Place data at 1750
		A,	37		/ A = 37
		C,	0
$Main