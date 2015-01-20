/ INSTRUCTION : SZL

*200
Main,	cla cll		/ Clear Accumulator, Link
		tad A		/ Add A to accumulator. ACC = 45 = 0000000101101.
		szl			/ Link = 0. Next instruction skipped.
		tad B		/ Add B to accumulator ACC = 47
		dca C		/ C = 45
		hlt			/ Halt

*2150				/ Place data at 2150
		A,	45d		/ A = 45
		C,	0
$Main