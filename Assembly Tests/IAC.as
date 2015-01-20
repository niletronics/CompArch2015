/ INSTRUCTION : IAC

*200
Main,	cla cll		/ Clear Accumulator, Link
		tad A		/ Add A to accumulator. ACC = 2
		iac 		/ Increment ACC. ACC = 3
		dca C		/ C = 3
		hlt			/ Halt

*700				/ Place data at 800
		A,	2		/ A = 2
		C,	0
$Main