
/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     SELECT = 258,
     PROJECT = 259,
     CARTESIAN_PRODUCT = 260,
     EQUI_JOIN = 261,
     NEWLINE = 262,
     NAME = 263,
     OPEN = 264,
     LESS_THAN = 265,
     GREAT_THAN = 266,
     EQUAL = 267,
     LOGICAL = 268,
     COMMA = 269,
     ARITHMETIC = 270,
     STR = 271,
     CLOSE = 272,
     NUMBER = 273,
     CMP = 274,
     DOT = 275
   };
#endif
/* Tokens.  */
#define SELECT 258
#define PROJECT 259
#define CARTESIAN_PRODUCT 260
#define EQUI_JOIN 261
#define NEWLINE 262
#define NAME 263
#define OPEN 264
#define LESS_THAN 265
#define GREAT_THAN 266
#define EQUAL 267
#define LOGICAL 268
#define COMMA 269
#define ARITHMETIC 270
#define STR 271
#define CLOSE 272
#define NUMBER 273
#define CMP 274
#define DOT 275




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif

extern YYSTYPE yylval;

