/ INSTRUCTION : ISZ1

*200
Main,		cla cll		/ Clear Accumulator, Link
			tad A		/ Add A to accumulator. ACC = 2
Loop,		tad B		/ A + B = 5
			dca C		/ C = A + B = 5
			isz 
			jmp Loop
			tad B		/ ACC = 7
			dca C		/ C = 7
			hlt			/ Halt
			jmp Main	/ Continue - Go to main

*300				/ Place data at 100
		A,	2		/ A = 2
		B,	3		/ B = 3
		C,	0
$Main