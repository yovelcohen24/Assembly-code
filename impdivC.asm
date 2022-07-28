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

// BP:

@BP
D=M
@SP
M=M-1
A=M
M=D   // SP = 16375 = memory[BP]

// initialize BP = SP
@SP
D=M
@BP
M=D  // BP = 16375

// BP

// function internal variables assignment:
// insert the 4 (uninitialized) internal variables to the stack:
@SP
M=M-1 // j = SP[6], SP = 16374
M=M-1 // i = SP[7], SP = 16373
M=M-1 // pw = Sp[8], SP = 16372
M=M-1 // sum = SP[9], SP = 16371

// all internal variables are now on the stack, operations within the function (stack size is 10):
// at present, stack is of size 10, meaning, SP = 16371

// initial condition: pary != 0
@3    // pary: stack[3] 9-3 = 6
D=A
@BP   // pary = BP + 3
A=D+M // A -> pary or A -> SP[3]
D=M // D = pary
@denominator0
D;JEQ

// i = parx
@2   // parx = SP[4], add 5
D=A
@BP
A=D+M // A = 16372+5 = 16377 -> parx
D=M // D = parx

@BP
A=M-1 // BP -2  SP[7] = i
A=A-1
M=D // i = parx

// j = pary
@3   // pary = SP[3], add 6
D=A
@BP
A=D+M // A->SP[3] = pary
D=M // D = pary

@BP
A=M-1 // A = 16372
M=D   // BP - 1 = SP[6] = j = pary

// sum = 0
@4
D=A
@BP   // sum = BP - 4 = SP
A=M-D
M = 0

(external_while)

// condition {

@3    // pary is SP[3] or 9-3
D=A
@BP 
A=D+M // A->SP[2] = pary
D=M   // D = pary

@BP   // i is at SP[7] = BP - 2
A=M-1 
A=A-1
D=M-D // access i and set D = i - D := i - pary

@end_external_while
D;JLT	

//			 } = while i>=pary, meaning, if i<pary, stop, i-pary<0 -> JMP

// extenal while assignments
@BP // j = SP[6] = BP - 1 now
A=M-1  // A -> SP[6] = j
M=1 // j = 1

@3 // pary = SP[3] = +6
D=A
@BP
A=D+M // A->pary
D=M   // D = pary

@BP   // access pw, pw = SP[8] = BP - 3
A=M-1
A=A-1
A=A-1
M=D  // pw = D = pary

(internal_while) // while 2 * pw <= i
@3
D=A
@BP   // access pw, pw = SP[8]
A=M-D // A=16375-3 = &pw
D=M   // D=pw
D=D+M // D = 2pw

@BP    // i = SP[7]
A=M-1
A=A-1
D=D-M  // D = D - M = 2pw - i
@end_internal_while
D;JGT  // if 2*pw - i > 0, break

@3
D=A
@BP
A=M-D // A->BP-3
D=M  // D = SP[8] = pw
M=M+D // pw = 2*pw = pw + pw

@BP // j = BP - 1
A=M-1
D=M
M=M+D // j = j + j

@internal_while
0;JMP
(end_internal_while)

@BP // BP - 1 = j
A=M-1 //A->memory[SP]
D=M //D=j

@BP   // SP[9] = sum
A=M-1
A=A-1
A=A-1
A=A-1 // BP - 4 = sum
M=M+D // sum = sum + j

@3
D=A
@BP   // pw = BP - 3
A=M-D // A->BP - 3
D=M   // D = pw
@BP   // i = BP - 2
A=M-1
A=A-1
M=M-D // i = i - pw

@external_while
0;JMP // iterate
(end_external_while)

// assign results to *parq, *parrem:

@4
D=A
@BP  // sum = BP - 4
A=M-D // A-> sum
D=M  // D = sum
@BP // parq is &q which is SP[2], add 7
A=M+1
A=A+1
A=A+1
A=A+1 // A ->SP[2]
A=M  // Address is M, &q (as a double pointer)
M=D  // *parq = sum

@BP   // i = BP - 2
A=M-1
A=A-1
D=M   // D = SP[8] = i
@BP    // parrem is &r at SP[1], add 8
A=M+1
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

// free local variables from SP and set BP to Stack[SP]
//  SP = SP + 4;
@SP
M=M+1
M=M+1
M=M+1
M=M+1

// Preserve D
A=M-1
M=D
A=A+1//16375
BP = Old BP
BP = Stack[BP];
A=M
D=M
@BP
M=D
//return D;
//Restore D
@SP
A=M-1
D=M   // D = "old" D
// A = Return address
@SP

M=M+1   // SP = CONT
A=M//16376
A=M//
// Return
0;JMP

(endfreestack)

(end)
@end
0;JMP