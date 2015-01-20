/ INSTRUCTION : TAD1

*200
Main,	cla cll		/ Clear Accumulator, Link
		tad A		/ Add A to accumulator. ACC = 8 = 0000000001000
		dca C		/ C = 8
		hlt			/ Halt
		jmp Main	/ Continue - Go to main

*300				/ Place data at 100
		A,	7		/ A = 7
		C,	0
$Main