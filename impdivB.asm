// x,y,q,r,flag,returnaddr are all global 
//(return is the return address of impdiv1), the rest are on the STACK

@16381
D=A
@SP
M=D // stack pointer = 16381

@9000
D=A
@x
M=D

@332
D=A
@y
M=D

@q
D=A

@rem
D=A

@flag
D=A

@CONT
D=A


// function call arguments assignment, all inserted to the stack, FROM RIGHT TO LEFT!:
@rem
D=A // D = &rem
@SP
AM=M-1 // SP = 16380 := *parrem
M=D // stack[1] = &rem

@q
D=A // D = &q
@SP
AM=M-1 //stack[2], SP =16379  := *parq
M=D //stack[2] = &q

@y
D=M
@SP
AM=M-1 //stack[3], SP = 16378 := pary
//A=M
M=D //stack[3] = pary

@x
D=M
@SP
AM=M-1 // stack[4], SP 16377 := parx
M=D //stack[4] = parx


@CONT
D=A
@SP
AM=M-1 // SP = 16376 := return
M=D // stack[5] = &return (return address is in stack[5])


@impdiv1
0;JMP // jump to func call

(CONT) // return here
// set function flag:
@flag
M=D // flag is returned to return variable

@5   // there are 4 call params, 1 return address, and 4 local variables in impdiv1
D=A
@SP
M=M+D // clear the stack (remove all 9 elements, internals and function arguments)

// end of program:
@end
0;JMP

// impdiv1:
(impdiv1)

// function internal variables assignment:
// insert the 4 (uninitialized) internal variables to the stack:
@SP
M=M-1 // j = SP[6], SP = 16372 new: 16375
M=M-1 // i = SP[7], SP = 16373 new: 16374
M=M-1 // pw = Sp[8], SP = 16374 new: 16373
M=M-1 // sum = SP[9], SP = 16375 new: 16372

// all internal variables are now on the stack, operations within the function (stack size is 9):
// at present, stack is of size 9, meaning, SP = 16372

// initial condition: pary != 0
@6    // pary: stack[3] 9-3 = 6
D=A
@SP
A=D+M // A -> pary or A -> SP[3]
D=M // D = pary
@denominator0
D;JEQ

// i = parx
@5   // parx = SP[4], add 5
D=A
@SP
A=D+M // A = 16372+5 = 16377 -> parx
D=M // D = parx
@SP
A=M+1 // SP[7] = i
A=A+1
M=D // i = parx

// j = pary
@6   // pary = SP[3], add 6
D=A
@SP
A=D+M // A->SP[3] = pary
D=M // D = pary
@SP
A=M+1 // A = 16372
A=A+1
A=A+1
M=D // SP[6] = j = pary

// sum = 0
@SP   // sum = SP
A=M
M = 0

(external_while)

// condition {

@6    // pary is SP[3] or 9-3
D=A
@SP 
A=D+M // A->SP[2] = pary
D=M   // D = pary

@SP   // i is at SP[7]
A=M+1 
A=A+1
D=M-D // access i and set D = i - D := i - pary

@end_external_while
D;JLT	

//			 } = while i>=pary, meaning, if i<pary, stop, i-pary<0 -> JMP

// extenal while assignments
@SP // j = SP[6] = SP now
A=M+1  // A -> SP[6] = j
A=A+1
A=A+1
M=1 // j = 1
@6 // pary = SP[3] = +6
D=A
@SP
A=D+M // A->pary
D=M   // D = pary
@SP   // access pw, pw = SP[8], 9-7=2
A=M+1
M=D  // pw = D = pary

(internal_while) // while 2 * pw <= i
@SP   // access pw, pw = SP[8], 9-7=2
A=M+1 // A=16372+2=16374 = &pw
D=M   // D=pw
D=D+M 
@SP    // i = SP[7]
A=M+1
A=A+1
D=D-M  // D = D - M = 2pw - i
@end_internal_while
D;JGT  // if 2*pw - i > 0, break

@SP
A=M+1 // A->SP[8]
D=M  // D = SP[8] = pw
M=M+D // pw = 2*pw = pw + pw

@SP // SP = j = SP[6]
A=M+1
A=A+1
A=A+1
D=M
M=M+D // j = j + j

@internal_while
0;JMP
(end_internal_while)

@SP // SP[6] = j
A=M+1 //A->memory[SP]
A=A+1
A=A+1
D=M //D=j

@SP   // SP[9] = sum
A=M
M=M+D // sum = sum + j


@SP  // SP[8]
A=M+1 // A->SP[8]
D=M // D = pw
@SP // i = SP[7]
A=M+1
A=A+1
M=M-D // i = i - pw

@external_while
0;JMP // iterate
(end_external_while)

// assign results to *parq, *parrem:


@SP  // sum = SP[9]
A=M
D=M  // D = sum
@SP // parq is &q which is SP[2], add 7
A=M+1
A=A+1
A=A+1
A=A+1
A=A+1
A=A+1
A=A+1 // A ->SP[2]
A=M  // Address is M, &q (as a double pointer)
M=D  // *parq = sum

@SP   // i = SP[7]
A=M+1
A=A+1
D=M   // D = SP[8] = i
@SP    // parrem is &r at SP[1], add 8
A=M+1
A=A+1
A=A+1
A=A+1
A=A+1
A=A+1
A=A+1
A=A+1
A=M
M=D  // *parrem = i

D=1    // D = 1 for flag
@freestack
0;JMP // free

(denominator0)
D=0   // flag = 0

(freestack)
@SP    // SP = 16372
M=M+1
M=M+1
M=M+1
AM=M+1    // A -> memory[SP] = 16376
A=M
0;JMP  // we jump back to "main"

(endfreestack)

(end)
@end
0;JMP