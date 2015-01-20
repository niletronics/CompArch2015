/ INSTRUCTION : RTL

*200
Main,	cla cll		/ Clear Accumulator, Link
		tad A		/ Add A to accumulator. ACC = 45.
		rtl 		/ Rotate left twice ACC. 0000000101101 => 0000001011010 => 0000010110100.  Link = 0
		dca C		/ C = 180
		hlt			/ Halt

*700				/ Place data at 900
		A,	45		/ A = 45
		C,	0
$Main