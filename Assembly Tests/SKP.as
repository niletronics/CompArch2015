/ INSTRUCTION : SKP

*200
Main,	cla cll		/ Clear Accumulator, Link
		tad A		/ Add A to accumulator. ACC = 45 = 0000000101101.
		skp			/ tad B instruction skipped. ACC should remain 45
		tad B		/ Add B to accumulator ACC = 47
		dca C		/ C = 45
		hlt			/ Halt

*1750				/ Place data at 1850
		A,	45		/ A = 45
		B,	2
		C,	0
$Main