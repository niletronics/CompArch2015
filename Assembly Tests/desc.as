/ ============================================================

/ Bubble Sort Program for PDP8

/ Written by Jon Andrews on 15/03/2000

/ ============================================================

/ This program sorts the array of numbers below

/ so that they are in descending order

/

/ This program should be assembler with the pdp8 PAL assembler

/ For use on the PDP8-FPGA you will need to run the assembler

/ listing (bubble.lst) through 'asmtomem bubble' This converts

/ the memory format to one which will work on the Xilinx Board

/ ============================================================


 *0200

Main, CLA CLL / start by clearing acc

TAD LOOPO / load outer loop counter

OUTER, SNA / if outer loop counter zero then need to hlt

JMP FINISH / jmp to halt when outer loop couter zero

CLA / clear ready to load ACC with counter

TAD LOOPI / load inner loop counter

JMP INNER / jump into inner loop

OUTERE, TAD LOOPO / load outer loop counter

IAC / increment inner loop counter

DCA LOOPO / store back incremented outer loop counter

TAD ORG1 / load in ORG1

DCA ADDR1 / store 1 into addr1

TAD ORG2 / load in ORG2

DCA ADDR2 / store 2 into addr2

TAD ORG3

DCA LOOPI / store 7771 back it LOOPI - effective reset

TAD LOOPO / load outer loop counter back into ACC

JMP OUTER / jump back into outer loop

INNER, SNA / if LOOPI is zero inner loop finished

JMP OUTERE / jump to end out outer loop

/ do subtraction by complement, inc and add

CLA CLL / clear ACC ready for next value

TAD I ADDR1 / load first variable

CMA IAC / complement ACC and increment

TAD I ADDR2 / load second variable

SMA / skip if result negative

JMP RPOS / if result is positive, write back in rpos

INNERE, ISZ ADDR1 / increment address of var1

ISZ ADDR2 / increment address of var2

CLA CLL

TAD LOOPI / load inner loop counter

IAC / increment inner loop counter

DCA LOOPI / store back incremented inner loop counter

CLL

TAD LOOPI / load loop counter back into ACC

JMP INNER / jump back to beginning of inner loop

RPOS, CLA CLL

TAD I ADDR1 / load in var1

DCA TEMP / store var1 into temporary location

TAD I ADDR2 / load in var2

DCA I ADDR1 / store var2 into location of var1

TAD TEMP / load temp back in

DCA I ADDR2 / store back into location of var2

JMP INNERE

FINISH, HLT / Halt the CPU




*0001

K1, 0001 / data block to sort /0001

K2, 0010 /0008

K3, 0005 /0005

K4, 0013 /000B

K5, 0100 /0040

K6, 0204 /0084

K7, 0504 /0144

K8, 0030 /0018

*0030

NUM, 0010 / number of elements to sort

ADDR1, 0001 / var1 memory location

ADDR2, 0002 / var2 memory location

LOOPO, 7771 / outer loop count - count towards zero

LOOPI, 7771 / inter loop count - count towards zero

TEMP, 0000 / temp location to do swap in

ORG1, 0001 / starting values for addr1

ORG2, 0002 / starting values for addr2

ORG3, 7771 / starting values for loopi

$MAIN
