/ INSTRUCTION : JMP

*200
Main,	cla cll		/ Clear Accumulator, Link
		tad A		/ Add A to accumulator. ACC = 12
		dca C		/ C = 12
		hlt			/ Halt
		jmp Main	/ Continue - Go to main

*600				/ Place data at 600
		A,	12		/ A = 12
		C,	0
$Main