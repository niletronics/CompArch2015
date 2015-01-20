/ INSTRUCTION : CML

*200
Main,	cla cll		/ Clear Accumulator, Link
		tad A		/ Add A to accumulator. ACC = 65 = 0000001000001.
		cml 		/ Complement link. ACC = 1000001000001 = 4161
		dca C		/ C = 4161
		hlt			/ Halt

*1250				/ Place data at 1250
		A,	65		/ A = 65
		C,	0
$Main