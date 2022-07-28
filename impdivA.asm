//X =9000
@9000
D=A
@x
M=D
//Y =332
@332
D=A
@y
M=D
//x=parx
@x
D=M
@parx
M=D
//y=pary
@y
D=M
@pary
M=D
//parq=&q
@q
D=A
@parq
M=D
//parrem=&rem
@rem
D=A
@parrem
M=D
//flag=impdiv1(x,y,&q,&rem);
@CONT1
D=A
@RETURNADDRESS
M=D

// jump to "routine" impdiv1
@impdiv1
0;JMP

// send flag (impdiv1 return value) here
(CONT1)
@flag
M=D
@END
0;JMP

// impdiv1 function
(impdiv1)
@pary // if denominator is 0
D=M
@Zeroresult // jump here
D;JEQ

@parx
D=M
@i
M=D
@pary
D=M
@j
M=D
@sum
M=0
@TEST  // outer while conditions
0;JMP

(WHILE) // outer while
@j
M=1
@pary
D=M
@pw
M=D
@TEST2
0;JMP

(WHILE2) // inner while
@pw
D=M
M=M+D
@j
D=M
M=M+D
@TEST2
0;JMP

(AFTERWHILE2)  // after inner while, sum += j, i-=pw
@j
D=M
@sum
M=M+D
@pw
D=M
@i
M=M-D
@TEST
0;JMP

(AFTERWHILE) // after outer while, *parq = sum;
  	     //		           *parrem = i;

@sum
D=M
@parq
A=M
M=D
@i
D=M
@parrem
A=M
M=D
@RESULTONE
0;JMP

(TEST) // outer while entry condition
@i
D=M
@pary
D=D-M
@WHILE
D;JGE
@AFTERWHILE
0;JMP

(TEST2) // inner while entry condition
@pw
D=M
D=D+M
@i
D=M-D
@WHILE2
D;JGE
@AFTERWHILE2
0;JMP

(Zeroresult) // case: denominator is 0, return 0
@0
D=A
@GOBACK
0;JMP

(RESULTONE) // case: denominator is non 0, return 1
@1
D=A
(GOBACK)
@RETURNADDRESS
A=M
0;JMP

(END)  // end of program - infinite loop
@END
0;JMP

