/ INSTRUCTION : CIA

*200
Main,	cla cll		/ Clear Accumulator, Link
		tad A		/ Add A to accumulator. ACC = 325 = 0000011010101.
		cia 		/ Complement and increment acc. ACC = 1111100101010 + 1 = 1111100101011 = 17453
		dca C		/ C = 17453
		hlt			/ Halt

*1450				/ Place data at 1450
		A,	325		/ A = 325
		C,	0
$Main