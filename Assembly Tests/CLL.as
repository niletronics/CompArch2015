/ INSTRUCTION : CLL

*200
Main,	cla cll		/ Clear Accumulator, Link
		tad A		/ Add A to accumulator. ACC = 37.
		rar 		/ Rotate right ACC . ACC = 37. 0000000100101 => 1000000010010 = 4114.  
		cll			/ Clear link. Link = 0, ACC = 0000000010010 = 18
		dca C		/ C = 18
		hlt			/ Halt

*1550				/ Place data at 1550
		A,	37		/ A = 37
		C,	0
$Main