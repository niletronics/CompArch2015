/ INSTRUCTION : RTR

*200
Main,	cla cll		/ Clear Accumulator, Link
		tad A		/ Add A to accumulator. ACC = 37.
		rtr 		/ Rotate right ACC . ACC = 37. 0000000100101 => 1000000010010 => 0100000001001.  
		dca C		/ C = 2057
		hlt			/ Halt

*1150				/ Place data at 1050
		A,	37		/ A = 37
		C,	0
$Main