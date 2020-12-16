%{
#include "A3P2.tab.h"
%}
%option yylineno


%%
"SELECT"				return SELECT;
"PROJECT"				return PROJECT;
"CARTESIAN_PRODUCT"	    return CARTESIAN_PRODUCT;
"EQUI_JOIN"				return EQUI_JOIN;
"<="|">="		        return CMP;
"<"						return LESS_THAN;
">"						return GREAT_THAN;
"("                     return OPEN;
")"                     return CLOSE;
"="|"!="				return EQUAL;

[\+\-\*/]               return ARITHMETIC;
(\".*\")                return STR;
"AND"|"OR"				return LOGICAL;
","						return COMMA;
[_a-zA-Z][_a-zA-Z0-9]*	return NAME;
[0-9]+                  return NUMBER;
[\n]					return NEWLINE;
"."						return DOT;
.						;


%%

int yywrap(void)
{
	return 1;
}


