

// CALCULATOR.ASM
//==========================================================
	.orig	x3000


// MAIN SUBROUTINE
//---------------------------------------------------------- 
MAIN	JSR TEST

	//Insert additional tests here...
//	AND R2 R2 #0	// 
//	ADD R1 R2 #15	// R1 = 15 (example data)
//	ADD R2 R2 #15	// R2 = 15 (example data)
//	JSR PLUS	// R0 = R1 + R2
//	JSR PRINT	// Should print "30"
//	
//	JSR PAUSE	// Pause until a key is pressed
	//--------------------------------------------------
	
	JSR STOP	// Halt the processor


// SAMPLE ARITHMETIC SUBROUTINES (IMPRACTICAL TO USE)
//==========================================================

// NEGATION...
//  Precondition: R1 = x
// Postcondition: R0 = -x
//                Registers R1 through R7 remain unchanged
NEG	NOT R0 R1
	ADD R0 R0 #1
	RET


// ADDITION...
//  Precondition: R1 = x
//                R2 = y
// Postcondition: R0 = x + y
//                Registers R1 through R7 remain unchanged
PLUS	ADD R0 R1 R2
	RET


// BASIC ARITHMETIC SUBROUTINES
//==========================================================

// SUBTRACTION...
//  Precondition: R1 = x
//                R2 = y
// Postcondition: R0 = x - y
//                Registers R1 through R7 remain unchanged
SUB	// todo
	
	ST	R2, SUBR2
	NOT	R2, R2
	ADD	R2, R2, #1
	ADD	R0, R1, R2
	LD	R2, SUBR2
	RET
	
//DATA FOR THE SUBTRACTION SUBROUTINE
SUBR2 .fill	#0

// MULTIPLICATION...
//  Precondition: R1 = x
//                R2 = y
// Postcondition: R0 = x * y
//                Registers R1 through R7 remain unchanged
MULT	// todo
	
	ST	R1, ORIGR1
	ST	R2, ORIGR2

	ADD	R2, R2, #0
	BRp	POSR2

	//IF NEG R2 
	NOT	R1, R1
	ADD	R1, R1, #1
	NOT	R2, R2
	ADD	R2, R2, #1
	

POSR2   AND	R0, R0, #0
	ADD	R2, R2, #0
	BRz	RESETT
	BRnp	LOOP
	
LOOP	ADD	R0, R0, R1
	ADD	R2, R2, #-1 //NEGATING
	BRp	LOOP

RESETT	LD	R1, ORIGR1
	LD	R2, ORIGR2
	

	RET
	
	

	
// DATA FOR THE MULTIPLY SUBROUTINE...
ORIGR1	.fill	#0
ORIGR2	.fill	#0




// DIVISION...
//  Precondition: R1 = x
//                R2 = y
// Postcondition: R0 = x / y
//                Registers R1 through R7 remain unchanged
//                Prints error message if y == 0
DIV	// todo
	
	ST	R1, DIVr1
	ST	R2, DIVr2
	ST	R3, DIVr3
	ST	R7, DIVr7
	
	AND	R3, R3, #0
	ADD	R3, R3, #1
	ADD	R1, R1, #0
	BRzp	DFIXr2

DFIXr1	NOT	R1, R1
	ADD	R1, R1, #1
	NOT	R3, R3
	ADD	R3, R3, #1

DFIXr2	ADD	R2, R2, #0
	BRnz	DERROR

	NOT	R2, R2
	ADD	R2, R2, #1
	NOT	R3, R3
	ADD	R3, R3, #1

DERROR	ADD	R2, R2, #0
	BRnp	DLOOP
	LEA	R0, ERRMSG
	PUTS
	AND	R0, R0, #0
	

DLOOP	ADD	R0, R0, #1
	ADD	R1, R1, R2
	BRzp	DLOOP

	ADD	R0, R0, #-1
	NOT	R2, R2
	ADD	R2, R2, #1
	ADD	R1, R1, R2
	
	ADD	R3, R3, #0
	BRnz 	DRET
	NOT	R0, R0
	ADD	R0, R0, #1

DRET	ST	R1, DIVMOD
	LD	R1, DIVr1
	LD	R2, DIVr2
	LD	R3, DIVr3
	LD	R7, DIVr7

	RET


// DATA FOR THE DIVISION SUBROUTINE...

DIVr1	.fill	#0
DIVr2	.fill	#0
DIVr3	.fill	#0
DIVr7	.fill	#0
DIVMOD	.fill	#0


ERRMSG	.stringz	"Hi you have an error bye"


// MODULUS...
//  Precondition: R1 = x
//                R2 = y
// Postcondition: R0 = x % y
//                If y == 0, prints and error message and sets R0 = 0
//                Registers R1 through R7 remain unchanged
MOD	// todo
	
	ST	R7, MODr7
	
	JSR	DIV
	LD	R0, DIVMOD
	ADD	R1, R1, #0
	BRzp	MODRET
	NOT	R0, R0
	ADD	R0, R0, #1

MODRET	LD	R7, MODr7
	RET
	

	RET
// DATA FOR THE MODULUS SUBROUTINE...

MODr7	.fill	#0

// SUBROUTINES FOR PRINTING INTEGERS
//==========================================================

// PRINT A NUMBER...
//  Precondition: R0 = a 16-bit integer value 
// Postcondition: R0 is printed to the console in decimal
//                Registers R0 through R7 remain unchanged
PRINT	ST R0 R0PRINT	// R0PRINT = R0 (saves R0)
	ST R7 R7PRINT	// R7PRINT = R7 (saves return address)
	
////////// ---------------------------- REPLACE THIS SECTION
	JSR TODIGIT	// !!!only good for printing single digits!!!
	OUT		// print(R0)
	
	LD R0 NEWLINE	// 
	OUT		// print('\n')
////////// ---------------------------- REPLACE THIS SECTION
	
	LD R0 R0PRINT	// R0 = R7PRINT (restores R0)
	LD R7 R7PRINT	// R7 = R7PRINT (restores return address)
	RET		//
	
// DATA FOR THE PRINT SUBROUTINE...
R0PRINT	.blkw #1	// Allocates space for saving R0 in PRINT
R7PRINT	.blkw #1	// Allocates space for saving R7 in PRINT
HYPHEN	.fill #45	// ASCII Digit '-'
NEWLINE	.fill #10	// ASCII '\n'


// CONVERT A NUMERICAL VALUE TO A DIGIT CHARACTER...
//  Precondition: R0 = a positive, single-digit integer value
// Postcondition: R0 = the ASCII character for the digit originally in R0
//                All other registers remain unchanged
TODIGIT	ST R1 R1DIGIT	// R1DIGIT = R1 (saves R1 into memory)
	LD R1 DIGIT0	// R1 = '0'
	ADD R0 R0 R1	// R0 = R0 + '0'
	LD R1 R1DIGIT	// R1 = R1DIGIT (restores R1 from memory)
	RET		//
	
// DATA FOR THE TODIGIT SUBROUTINE...
R1DIGIT	.blkw #1	// Allocates space for saving R1 in TODIGIT
DIGIT0	.fill #48	// ASCII Digit '0'


// ADVANCED ARITHMETIC SUBROUTINES
//==========================================================

// EXPONENTIATION...
//  Precondition: R1 = x
//                R2 = y, where y >= 0
// Postcondition: R0 = Math.pow(x,y)
//                Registers R1 through R7 remain unchanged
POW	// todo
	
	RET
	
// DATA FOR THE EXPONENTIATION SUBROUTINE...



// FACTORIAL...
//  Precondition: R1 = x, where x >= 0
// Postcondition: R0 = x!
//                Registers R1 through R7 remain unchanged
FACT	// todo
	
	RET
	
// DATA FOR THE FACTORIAL SUBROUTINE...



// CUSTOM ROUTINE...Define an operation of your choice.
//  Precondition: ... insert your precondition here ...
// Postcondition: ... insert your postcondition here ...
//
//      todo
//
	
// DATA FOR YOUR CUSTOM SUBROUTINE...



//==========================================================
// ******** DO NOT ALTER ANYTHING BELOW THIS POINT ********
//==========================================================


// SUBROUTINE FOR TESTING EACH ARITHMETIC OPERATION
//----------------------------------------------------------
TEST	ST R7 R7TEST	// R7TEST = R7 (saves return address)
	
	LEA R0 START	//
	PUTS		// Output "START OF TESTS" message
	//--------------------------------------------------
	
	LD R2 ZERO	// 
	ADD R1 R2 #4	// R1 = 4 (example data)
	ADD R2 R2 #5	// R2 = 5 (example data)
	JSR PLUS	// R0 = R1 + R2
	JSR PRINT	// Should print "9"
	
	JSR PAUSE	// Pause until a key is pressed
	//--------------------------------------------------
	
	LD R2 ZERO	// 
	ADD R1 R2 #12	// R1 = 12 (example data)
	ADD R2 R2 #4	// R2 = 4 (example data)
	JSR SUB		// R0 = R1 - R2
	JSR PRINT	// Should print "8"
	
	LD R2 ZERO	// 
	ADD R1 R2 #-8	// R1 = -8 (example data)
	ADD R2 R2 #5	// R2 = 5 (example data)
	JSR SUB		// R0 = R1 - R2
	JSR PRINT	// Should print "-13" (or "#" until PRINT is complete)
	
	LD R2 ZERO	// 
	ADD R1 R2 #10	// R1 = 10 (example data)
	ADD R2 R2 #-6	// R2 = -6 (example data)
	JSR SUB		// R0 = R1 - R2
	JSR PRINT	// Should print "16" (or "@" until PRINT is complete)
	
	LD R2 ZERO	// 
	ADD R1 R2 #-9	// R1 = -9 (example data)
	ADD R2 R2 #-3	// R2 = -3 (example data)
	JSR SUB		// R0 = R1 - R2
	JSR PRINT	// Should print "-6" (or "*" until PRINT is complete)
	
	JSR PAUSE	// Pause until a key is pressed
	//--------------------------------------------------
	
	LD R2 ZERO	// 
	ADD R1 R2 #8	// R1 = 8 (example data)
	ADD R2 R2 #3	// R2 = 3 (example data)
	JSR MULT	// R0 = R1 * R2
	JSR PRINT	// Should print "24" (or "H" until PRINT is complete)
	
	LD R2 ZERO	// 
	ADD R1 R2 #4	// R1 = 4 (example data)
	ADD R2 R2 #-3	// R2 = -3 (example data)
	JSR MULT	// R0 = R1 * R2
	JSR PRINT	// Should print "-12" (or "$" until PRINT is complete)
	
	LD R2 ZERO	// 
	ADD R1 R2 #-2	// R1 = -2 (example data)
	ADD R2 R2 #5	// R2 = 5 (example data)
	JSR MULT	// R0 = R1 * R2
	JSR PRINT	// Should print "-10" (or "&" until PRINT is complete)
	
	LD R2 ZERO	// 
	ADD R1 R2 #-5	// R1 = -5 (example data)
	ADD R2 R2 #-6	// R2 = -6 (example data)
	JSR MULT	// R0 = R1 * R2
	JSR PRINT	// Should print "30" (or "N" until PRINT is complete)
	
	LD R2 ZERO	// 
	ADD R1 R2 #0	// R1 = 0 (example data)
	ADD R2 R2 #3	// R2 = 3 (example data)
	JSR MULT	// R0 = R1 * R2
	JSR PRINT	// Should print "0"
	
	LD R2 ZERO	// 
	ADD R1 R2 #7	// R1 = 7 (example data)
	ADD R2 R2 #0	// R2 = 0 (example data)
	JSR MULT	// R0 = R1 * R2
	JSR PRINT	// Should print "0"
	
	LD R2 ZERO	// 
	ADD R1 R2 #0	// R1 = 0 (example data)
	ADD R2 R2 #0	// R2 = 0 (example data)
	JSR MULT	// R0 = R1 * R2
	JSR PRINT	// Should print "0"
	
	JSR PAUSE	// Pause until a key is pressed
	//--------------------------------------------------
	
	LD R2 ZERO	// 
	ADD R1 R2 #11	// R1 = 11 (example data)
	ADD R2 R2 #4	// R2 = 4 (example data)
	JSR DIV		// R0 = R1 / R2
	JSR PRINT	// Should print "2"
	JSR MOD		// R0 = R1 % R2
	JSR PRINT	// Should print "3"
	
	JSR PAUSE	// Pause until a key is pressed
	
	LD R2 ZERO	// 
	ADD R1 R2 #-12	// R1 = -12 (example data)
	ADD R2 R2 #4	// R2 = 4 (example data)
	JSR DIV		// R0 = R1 / R2
	JSR PRINT	// Should print "-3" (or "-" until PRINT is written)
	JSR MOD		// R0 = R1 % R2
	JSR PRINT	// Should print "0"
	
	JSR PAUSE	// Pause until a key is pressed
	
	LD R2 ZERO	// 
	ADD R1 R2 #13	// R1 = 13 (example data)
	ADD R2 R2 #-2	// R2 = -2 (example data)
	JSR DIV		// R0 = R1 / R2
	JSR PRINT	// Should print "-6" (or "*" until PRINT is written)
	JSR MOD		// R0 = R1 % R2
	JSR PRINT	// Should print "1"
	
	JSR PAUSE	// Pause until a key is pressed
	
	LD R2 ZERO	// 
	ADD R1 R2 #-9	// R1 = -9 (example data)
	ADD R2 R2 #-4	// R2 = -4 (example data)
	JSR DIV		// R0 = R1 / R2
	JSR PRINT	// Should print "2"
	JSR MOD		// R0 = R1 % R2
	JSR PRINT	// Should print "-1" (or "/" until PRINT is written)
	
	JSR PAUSE	// Pause until a key is pressed
	
	LD R2 ZERO	// 
	ADD R1 R2 #0	// R1 = 0 (example data)
	ADD R2 R2 #4	// R2 = 4 (example data)
	JSR DIV		// R0 = R1 / R2
	JSR PRINT	// Should print "0"
	JSR MOD		// R0 = R1 % R2
	JSR PRINT	// Should print "0"
	
	JSR PAUSE	// Pause until a key is pressed
	
	LD R2 ZERO	// 
	ADD R1 R2 #11	// R1 = 11 (example data)
	ADD R2 R2 #0	// R2 = 0 (example data)
	JSR DIV		// R0 = R1 / R2
	JSR PRINT	// Should display error message
	JSR MOD		// R0 = R1 % R2
	JSR PRINT	// Should display error message
	
	JSR PAUSE	// Pause until a key is pressed
	//--------------------------------------------------
	
	LD R2 ZERO	// 
	ADD R1 R2 #3	// R1 = 3 (example data)
	ADD R2 R2 #5	// R2 = 5 (example data)
	JSR POW		// R0 = R1 ^ R2
	JSR PRINT	// Should print "243" (or "#  " until PRINT is written)
	
	JSR PAUSE	// Pause until a key is pressed
	//--------------------------------------------------
	
	LD R1 ZERO	// 
	ADD R1 R1 #7	// R1 = 7 (example data)
	JSR FACT	// R0 = R1!
	JSR PRINT	// Should print "5040" (or "à!!" until PRINT is written)
	
	JSR PAUSE	// Pause until a key is pressed
	//--------------------------------------------------
	
	LD R7 R7TEST	// R7 = R7TEST (restores R7 from memory)
	RET
	
// DATA FOR THE MAIN SUBROUTINE
R7TEST	.blkw #1
START	.stringz "===== START OF TESTS =====\n"
ZERO	.fill #0


// SUBROUTINE FOR PAUSING (DO NOT ALTER)
//----------------------------------------------------------
PAUSE	ST R0 R0PAUSE	// R0PAUSE = R0 (saves R0 into memory)
	ST R7 R7PAUSE	// R7PAUSE = R7 (saves R7 into memory)
	LEA R0 CONTMSG	// 
	PUTS		// Output the prompt to continue
	GETC		// Wait for user response to prompt
	LD R7 R7PAUSE	// R7 = R7PAUSE (restores R7 from memory)
	LD R0 R0PAUSE	// R0 = R0PAUSE (restores R0 from memory)
	RET
	
R0PAUSE .blkw #1	// Allocates space for saving R0 in PAUSE
R7PAUSE .blkw #1	// Allocates space for saving R7 in PAUSE
CONTMSG	.stringz "----- Press [SPACE] for the next test -----\n"


// SUBROUTINE FOR HALTING THE PROCESSOR (DO NOT ALTER)
//----------------------------------------------------------
STOP	LEA R0 END	// 
	PUTS		// Output "END OF TESTS" message
	AND R0 R0 #0	// 
	LD R1 STATUS	// Load address of system status register
	STR R0 R1 #0	// Halt the processor
	
STATUS	.fill xFFFE
END	.stringz "====== END OF TESTS ======\n"

	.end
