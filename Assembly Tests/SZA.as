/ INSTRUCTION : SZA

*200
Main,	cla cll		/ Clear Accumulator, Link
		tad A		/ Add A to accumulator. ACC = 45 = 0000000101101.
		cla			/ Clear accumulator
		sza			/ ACC = 0. Next instruction skipped.
		tad B		/ Add B to accumulator ACC = 2
		dca C		/ C = 0
		hlt			/ Halt

*2250				/ Place data at 2250
		A,	45d		/ A = 45
		C,	0
$Main