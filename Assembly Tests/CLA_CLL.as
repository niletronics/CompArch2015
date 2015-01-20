/ INSTRUCTION : CLA_CLL

*200
Main,	tad A		/ Add A to accumulator. ACC = 2
		cla cll		/ Clear Accumulator, Link
		hlt			/ Halt
		jmp Main	/ Continue - Go to main

*700				/ Place data at 700
		A,	2		/ A = 2
$Main