/ INSTRUCTION : RAL

*200
Main,	cla cll		/ Clear Accumulator, Link
		tad A		/ Add A to accumulator. ACC = 37.
		ral 		/ Rotate left ACC. 0000000100101 => 0000001001010.  Link = 0
		dca C		/ C = 74
		hlt			/ Halt
		
*770				/ Place data at 890
		A,	37		/ A = 37
		C,	0
$Main