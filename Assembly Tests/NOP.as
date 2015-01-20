/ INSTRUCTION : NOP

*200
Main,	cla cll		/ Clear Accumulator, Link
		nop
		hlt			/ Halt

*2650				/ Place data at 2650
		A,	45		/ A = 45
		B,	2
		C,	0
$Main