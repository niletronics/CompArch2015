/ INSTRUCTION : SMA

*200
Main,	cla cll		/ Clear Accumulator, Link
		tad A		/ Add A to accumulator. ACC = 37.
		rar 		/ Rotate right ACC . ACC = 37. 0000000100101 => 1000000010010 = 4114. 
		sma			/ Skip next instruction since MSB of ACC = 1 implies 2's complement minus accumulator
		tad B		/ Add B to accumulator ACC = 4116
		dca C		/ C = 4114
		hlt			/ Halt
	
*2450				/ Place data at 1050
		A,	37		/ A = 37
		B,	2
		C,	0
$Main