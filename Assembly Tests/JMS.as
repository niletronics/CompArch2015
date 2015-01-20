/ INSTRUCTION : JMS

*200
Main,	cla cll		/ Clear Accumulator, Link
		tad A		/ Add A to accumulator. ACC = 2
		jms Next	
Done:	jmp Exit

Next:	tad B		/ A AND B = 2
		dca C		/ C = 2
		jmp Done
Exit:	hlt			/ Halt

*500				/ Place data at 500
		A,	2		/ A = 2
		B,	3		/ B = 3
		C,	0
$Main