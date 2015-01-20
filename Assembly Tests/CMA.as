/ INSTRUCTION : CMA

*200
Main,	cla cll		/ Clear Accumulator, Link
		tad A		/ Add A to accumulator. ACC = 29 = 0000000011101.
		cma 		/ Complement acc. ACC = 0111111100010 = 4066
		dca C		/ C = 4066
		hlt			/ Halt

*1350				/ Place data at 1350
		A,	29		/ A = 29
		C,	0
$Main