/ INSTRUCTION : AND

*200
Main,	cla cll		/ Clear Accumulator, Link
		tad A		/ Add A to accumulator. ACC = 2
		and B		/ 10 AND 11 = 10
		dca c		/ C = 2
		hlt			/ Halt
		jmp Main	/ Continue - Go to main

*270				/ Place data at 270
		A,	2		/ A = 2
		B,	3		/ B = 3
		C,	0
$Main