#include "lex.h"

//standard header files
#include <string.h>
#include <stdlib.h>

#include <math.h>

#include <stdio.h>
#include <ctype.h>

#define adi 1;


struct Le_oken{
   int num;
   char s[1024];
};

int cnt = 0;
char* yytext_new = ""; //output (not '\0' terminated)
int yyleng_new   = 0;    //output length
int yylineno_new = 0;  //output line number

struct Le_oken table_asm[1024];



int lex(void){

   
   char        *current;

   static char input_buffer[1024];

   current = yytext_new + yyleng_new; //Skip current output
                                        

   while(10){       // Get next one         
      while(!*current){
         //Get the new lines, skip any leading
         //emptyspace in line,
         //till a blank less row is found.
         
         current = input_buffer;
         if(!gets(input_buffer)){

            *current = '\0' ;

            return EOI;
         }
         ++yylineno_new;
         while(isspace(*current))
            ++current;
      }
      for(; *current; ++current){
	
	//while (*current){
         // fetch the next one(token)
         yytext_new = current;
         yyleng_new = 1;
         char d=*current;
         if(d == ';') return SEMI;  
         if(d == '+') return PLUS;
         
         if(d == '<') return LESSTHEN;
         if(d == '>') return GREATERTHEN;
         if(d == ':') return COL;

	 if(d == '-') return MINUS;
         if(d == '*') return TIMES;
         if(d == '/') return DIVIDE;
         if(d == '(') return LP;
         if(d == ')') return RP;
         if(d == '=') return EQUAL;

         if(d == '\n' || d == '\t' || d == ' ') continue;




         if(!isalnum(*current))
            fprintf(stderr, "Not alphanumeric <%c>\n", *current);
         else{

            while(isalnum(*current))

               ++current;

            yyleng_new = current - yytext_new;

            char buffer[yyleng_new + 1];

            buffer[yyleng_new] = '\0';

            memcpy(buffer, yytext_new, yyleng_new);

            if(strcmp(buffer, "if") == 0)
            {
               return IF;
            }
            
            else if(strcmp(buffer, "do") == 0)
            {
               return DO;
            }
            else if(strcmp(buffer, "begin") == 0)
            {
               return BEGIN;
            }
	    else if(strcmp(buffer, "then") == 0)
            {
               return THEN;

            }
	    else if(strcmp(buffer, "end") == 0)
            {
               return END;
            }
            else if(strcmp(buffer, "while") == 0)
            {
               return WHILE;
            }
            
            return NUM_OR_ID;
         }
	//++current;

      } 
//for loop closes
   }
}

// unused functions
void lexin()
{
lexingfirst();
}


void lexingfirst()
{
lexing();
}


void lexing()
{
int ai=2;
} 



void Print(){
   char c[yyleng_new + 1];
   memcpy(c, yytext_new, yyleng_new);
   
   int flag = 0;

	c[yyleng_new] = '\0';

   if(c[0] <= '9' && c[0] >= '0'){
       fprintf(outputfile , "<NUM>");
       return;

   }
   for(int i = 1; i < cnt+1; i++){
         if(strcmp(table_asm[i-1].s, c) == 0){
               fprintf(outputfile , "<ID , %d>", table_asm[i].num);
               flag = 1;
               break;
         }
   }
   if(!flag){
      table_asm[cnt].num = cnt;
      strcpy(table_asm[cnt].s , c);
      fprintf(outputfile , "<ID , %d>", table_asm[cnt].num);
      cnt++;
   }
}

static int Lookahead = -1; /* Lookahead token  */
int checktoken(int token){
   if(Lookahead == -1) Lookahead = lex();

		 if(token == ID && Lookahead == NUM_OR_ID){
			 int i;
			 char *current = yytext_new;
          char buffer[yyleng_new + 1];
          buffer[yyleng_new] = '\0';
          memcpy(buffer, yytext_new, yyleng_new);
			 for(i = 0; i < yyleng_new; i++) current++;
			 while(isspace(*current)) current++;
			 if((*current) == ':'){
				outputfile = fopen("output.txt", "a");
				if(outputfile != NULL) 
            {
                   int flag = 0;
                   for(int i = 0; i < cnt; i++){
                   if(strcmp(table_asm[i].s , buffer) == 0)
                   {
                       fprintf(outputfile , "<ID , %d>", table_asm[i].num);
                       fclose(outputfile);
                       flag = 1;
                       break;
                   }
               }
               if(!flag)
               {
                   table_asm[cnt].num = cnt;
                   strcpy( table_asm[cnt].s , buffer  );
                    fprintf(outputfile , "<ID , %d>", table_asm[cnt].num);
                   fclose(outputfile);
                   cnt++;
               }
				}

				return 1;
			}
			 return 0;
		} 


	if( token == Lookahead)
	{
		outputfile = fopen("output.txt", "a");
		if (outputfile != NULL) {
			

			if(token==0){fprintf(outputfile,"<END OF INPUT> ");}
			else if(token==1){fprintf(outputfile,"<SEMI> ");}
			else if(token==2){fprintf(outputfile,"<PLUS> ");}
			else if(token==3){fprintf(outputfile,"<TIMES> ");}
			else if(token==4){fprintf(outputfile,"<LP> ");}
			else if(token==5){fprintf(outputfile,"<RP> ");}
			else if(token==6){Print();}
			else if(token==7){fprintf(outputfile,"<EQUAL> ");}
			else if(token==8){fprintf(outputfile,"<LESSTHEN> ");}
			else if(token==9){fprintf(outputfile,"<GREATERTHEN> ");}
			else if(token==10){fprintf(outputfile,"<MINUS> ");}
			else if(token==11){fprintf(outputfile,"<DIVIDE> ");}
			else if(token==12){fprintf(outputfile,"<IF> ");}
			else if(token==13){fprintf(outputfile,"<THEN> ");}
			else if(token==14){fprintf(outputfile,"<WHILE> ");}
			else if(token==15){fprintf(outputfile,"<DO> ");}
			else if(token==16){fprintf(outputfile,"<BEGIN> ");}
			else if(token==17){fprintf(outputfile,"<END> ");}
			else if(token==18){fprintf(outputfile,"<ID> ");}
			else if(token==19){fprintf(outputfile,"<COL> ");}
		
			fclose(outputfile);
		}
		return 1;
	}else{
		return 0;
	}
}


int match(int token){
   //Return true incase if TOKEN matches the current lookahead symbol               

   if(Lookahead == -1)
      Lookahead = lex();

   return token == Lookahead;
}

void advance(void){
// the lookahead advances to the next input symbol                             

    Lookahead = lex();
}


