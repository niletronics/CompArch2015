/ INSTRUCTION : SNA

*200
Main,	cla cll		/ Clear Accumulator, Link
		tad A		/ Add A to accumulator. ACC = 45 = 0000000101101.
		sna			/ ACC != 0. Next instruction skipped.
		tad B		/ Add B to accumulator ACC = 47
		dca C		/ C = 45
		hlt			/ Halt

*2350				/ Place data at 2350
		A,	45		/ A = 45
		B,	2
		C,	0
$Main