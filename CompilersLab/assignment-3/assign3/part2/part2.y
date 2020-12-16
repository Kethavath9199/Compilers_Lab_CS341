%{
void yyerror (char *s);
int yylex();
#include <stdio.h>     /* C declarations used in actions */
#include <stdlib.h>
#include <ctype.h>
%}
         /* Yacc definitions */
%start start
%token SELECT PROJECT CARTESIAN_PRODUCT EQUI_JOIN NEWLINE NAME OPEN LESS_THAN GREAT_THAN EQUAL LOGICAL COMMA ARITHMETIC STR CLOSE NUMBER CMP DOT


%%

/* descriptions of expected inputs     corresponding actions (in C) */

start: stmtlist
stmtlist:	stmt		
			|stmt stmtlist 
			
			

stmt:		SELECT LESS_THAN conditionlist1 GREAT_THAN OPEN NAME CLOSE  NEWLINE  {printf("Valid syntax\n");}
			| PROJECT LESS_THAN attributelist GREAT_THAN OPEN NAME CLOSE  NEWLINE {printf("Valid syntax\n");}
			| OPEN NAME CLOSE join  NEWLINE {printf("Valid syntax\n");}
			| error NEWLINE {yyerrok;}

join:		CARTESIAN_PRODUCT OPEN NAME CLOSE
			|EQUI_JOIN LESS_THAN conditionlist2 GREAT_THAN OPEN NAME CLOSE

conditionlist1:	NAME condition1
				|NAME condition1 LOGICAL conditionlist1

condition1 :	 CMP expression1
				| GREAT_THAN expression1
				| LESS_THAN expression1
				| EQUAL expression1
				| EQUAL STR
expression1	:	idnum1 ARITHMETIC expression1
				|OPEN expression1 CLOSE
				|idnum1

idnum1:			NAME
				|NUMBER
				|ARITHMETIC NUMBER

conditionlist2:	NAME DOT NAME condition2 
				|NAME DOT NAME condition2 LOGICAL conditionlist2

condition2 :	CMP expression2
				| GREAT_THAN expression2
				| LESS_THAN expression2
				| EQUAL expression2
expression2	:	idnum2 ARITHMETIC expression2
				|OPEN expression2 CLOSE
				|idnum2

idnum2:			NAME DOT NAME
				|NUMBER
				|ARITHMETIC NUMBER

attributelist :	NAME
				|NAME COMMA attributelist



%%                     /* C code */


int main (void) {
	
	return yyparse ( );
}

void yyerror (char *s) {fprintf (stderr, "Invalid Syntax\n");}