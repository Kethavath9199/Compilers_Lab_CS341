#include <stdio.h>

#define EOI		0	/* End of input			*/
#define SEMI		1	/* ; 				*/
#define PLUS 		2	/* + 				*/
#define TIMES		3	/* * 				*/
#define LP		4	/* (				*/
#define RP		5	/* )				*/
#define NUM_OR_ID	6	/* Decimal Number or Identifier */
#define EQUAL 7 /* = */
#define LESSTHEN 8 // <
#define GREATERTHEN 9 // >
#define MINUS 10 // -
#define DIVIDE 11 /* / */
#define IF			12   /*	if              */
#define THEN 		13   /* then            */
#define WHILE 		14   /* while           */
#define DO 			15   /* do              */
#define BEGIN 		16   /* begin           */
#define END			17   /* end				*/
#define ID 			18   /* Identifier		*/
#define COL 		19   /*	:				*/

extern char *yytext_new;		/* in lex.c			*/
extern int yyleng_new;
extern int yylineno_new;

void SymbolTable();
void advance();
void chechtoken(int);
FILE *outputfile;

