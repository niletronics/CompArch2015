/ INSTRUCTION : SPA

*200
Main,	cla cll		/ Clear Accumulator, Link
		tad A		/ Add A to accumulator. ACC = 45 = 0000000101101.
		spa			/ tad B instruction skipped. ACC should remain 45 since MSB of ACC = 0
		tad B		/ Add B to accumulator ACC = 47
		dca C		/ C = 45
		hlt			/ Halt

*2550				/ Place data at 2550
		A,	45		/ A = 45
		B,	2
		C,	0
$Main