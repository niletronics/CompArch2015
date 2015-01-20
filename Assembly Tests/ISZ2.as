/ INSTRUCTION : ISZ2

*200
Main,	cla cll		/ Clear Accumulator, Link
		isz
		hlt			/ Halt

*2750				/ Place data at 2750
		A,	45		/ A = 45
		B,	2
		C,	0
$Main