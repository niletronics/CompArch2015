/ INSTRUCTION : TAD2

*200
Main,	cla cll		/ Clear Accumulator, Link
		tad A		/ Add A to accumulator. ACC = 4104 = 1000000001000
					/ Carry generated, link complemented, ACC = 0000000001000 = 8
		dca C		/ C = 8
		hlt			/ Halt
		jmp Main	/ Continue - Go to main

*300				/ Place data at 100
		A,	4104	/ A = 4104
		C,	0
$Main