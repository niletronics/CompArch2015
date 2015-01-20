/ INSTRUCTION : RAR

*200
Main,	cla cll		/ Clear Accumulator, Link
		tad A		/ Add A to accumulator. ACC = 37.
		rar 		/ Rotate right ACC . ACC = 37. 0000000100101 => 1000000010010. 
		dca C		/ C = 4114
		hlt			/ Halt
	
*1050				/ Place data at 1050
		A,	37		/ A = 37
		C,	0
$Main