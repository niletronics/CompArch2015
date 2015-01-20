/ INSTRUCTION : DCA

*200
Main,	cla cll		/ Clear Accumulator, Link
		tad A		/ Add A to accumulator. ACC = 5
		dca C		/ C = 5, ACC = 0
		hlt			/ Halt
		jmp Main	/ Continue - Go to main

*400				/ Place data at 400
		A,	5		/ A = 5
		C,	0
$Main