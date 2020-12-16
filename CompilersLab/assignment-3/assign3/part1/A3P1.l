%{
    #include <stdlib.h>
    #include <string.h>
    #include <stdio.h>
    
    void add_class(char*);
    int check_class(char*);
    void objects(char *);
    void comments_removal(FILE*, FILE*);
    void increase_counts(void);
    int sai;

    int number_of_classes = 0;
    int number_of_inherited_classes = 0;
    int number_of_constructors=0;
    int number_of_objects=0;
    char temp_class[1460];

    char classes[10000][200];
    int tempi=0;
    
    int class_found = 0;
    int inherited_found = 0;
    int constructor_found = 0;
    int object_found=0;

%}
wd   [A-Za-z_0-9]
str   [A-Za-z_]
typ   public|final|abstract|private|static|protected
cls  class
inh  extends|implements
int   public|private
s     [;]
%option noyywrap
%x C0 C1 C2 C3 C4 D1 D2 D3 D4 D5 D6 D0 E1 E3 E4

%%
[^A-Za-z0-9_]{cls}[ ]+     { if(yytext[0] == '\n'){increase_counts();} BEGIN(C1); }
<C0>[^A-Za-z0-9_]{cls}[ ]+     { if(yytext[0] == '\n'){increase_counts();} BEGIN(C1); }
<C1>{str}{wd}*             {  memset(temp_class, 0, sizeof(temp_class)) ; snprintf(temp_class, 200, "%s", yytext); BEGIN(C2) ; }
<C2>[ \t]                 { BEGIN(C2) ; }
<C2>\n                    { class_found = 1; increase_counts(); if(check_class(temp_class)==0){add_class(temp_class);} BEGIN(INITIAL);}
<C2>"{"                   { class_found = 1; increase_counts();if(check_class(temp_class)==0){add_class(temp_class);} /*printf("%s-was here\n", temp_class);*/ BEGIN(INITIAL); }
<C2>[^A-Za-z0-9_]{inh}[ ]+          { BEGIN(D4); }
<D4>{str}{wd}*                      { BEGIN(D5) ; }
<D5>[ \t]                           {BEGIN(D6);}
<D6>\n                              { inherited_found=1,class_found = 1; increase_counts(); if(check_class(temp_class)==0){add_class(temp_class);} BEGIN(INITIAL);}
<D6>"{"                             { inherited_found=1,class_found = 1; increase_counts(); if(check_class(temp_class)==0){add_class(temp_class);} /*printf("%s-was here\n", temp_class);*/ BEGIN(INITIAL); }

{str}{wd}*[*]*[ ]+[*]*[A-Za-z0-9_,][A-Za-z0-9_,\.\[\] ()]*[^\n;<>]*;  {/* printf("%s\n", yytext); */ objects(yytext);}      

{str}{wd}*[ ]*[(]          { memset(temp_class, 0, sizeof(temp_class)) ; sscanf(yytext, "%[A-Za-z0-9_]s", temp_class); BEGIN(E3) ; /* printf("%s-const-%d-%s-\n", yytext, yylineno, temp_class); */}
<E1>[ \t]                 { BEGIN(E1);}
<E1>[(]                   { BEGIN(E3);}
<E3>[^)]                  { BEGIN(E3);}
<E3>[)]                   { BEGIN(E4);}
<E4>[ \t]                 { BEGIN(E4);}
<E4>[{]                  { if (check_class(temp_class)){ constructor_found = 1; /* printf("######%s#######", temp_class);*/ } increase_counts(); /* printf("%s-was here\n", temp_class);*/ BEGIN(INITIAL);}
<E4>\n                    { if (check_class(temp_class)){constructor_found = 1; /* printf("######%s#######", temp_class);*/ }increase_counts(); /*printf("%s-was here\n", temp_class);*/ BEGIN(INITIAL);}

.
\n
                     

%%

void add_class(char *temp_class){
    snprintf(classes[tempi], 200, "%s", temp_class);
    tempi++;
}

int check_class(char *class_name){
    int i;
    for(i=0;i<tempi;i++){

        if(strcmp(class_name, classes[i]) == 0){
            
            return 1;
        }
    }
    return 0;
}
void objects(char *temp_char){
    char classname[250];
    // printf("%s\n", temp_char);
    memset(classname, 0, sizeof(classname));
    sscanf(temp_char, "%s", classname);
    int length = strlen(classname);
    while(classname[length-1] == '*') {
        classname[length-1] = '\0';
        length--;
    }
    
    if(check_class(classname)){
        object_found = 1;
        increase_counts() ;
        //printf("%s\n", temp_char);
    }
}
void print_classes(){
    int i;
    printf("Printing classes : \n");
    for(i=0;i<tempi;i++){
        printf("%s ", classes[i]);
    }
    printf("\n");
}



void increase_counts(){
    number_of_classes += class_found;
    number_of_inherited_classes += inherited_found;
    number_of_constructors += constructor_found;

    number_of_objects += object_found;
    class_found = inherited_found = constructor_found =  object_found = 0;
}

void comments_removal(FILE* source, FILE* destination){
    int singleline_comment_found = 0, multiline_comment_found = 0, length=0, i=0, string_started=0;
    char *read_line;
    read_line = malloc(1000);
    memset(read_line, 0, sizeof(read_line));
    size_t max_length = 1000;
    while(getline(&read_line, &max_length, source)!=-1){
        length = (int)strlen(read_line);
        if(read_line[length-1]=='\n'){
            length--;
        }
        // printf("%d\n", (int)length);
        singleline_comment_found = string_started = 0;
        for(i=0;i<length;i++){
            if(string_started && read_line[i] == '\"' && read_line[i-1] != '\\'){
                string_started = 0;
                read_line[i-1] = ' ';
                read_line[i] = ' ';
            }
            else if(multiline_comment_found == 1 && read_line[i] == '*' && read_line[i+1] == '/'){
                multiline_comment_found = 0;
                read_line[i] = ' ';
                read_line[i+1] = ' ';
                i++;
            }
            else if(string_started){
                read_line[i-1] = ' ';
            }
            else if(singleline_comment_found || multiline_comment_found){
                read_line[i] = ' ';
            }
            else if(read_line[i] == '\"' && read_line[i-1] != '\\'){
                string_started = 1;
            }
            else if(read_line[i] == '/' && read_line[i+1] == '/'){
                singleline_comment_found = 1;
                read_line[i] = ' ';
                read_line[i+1] = ' ';
                i++;
            }
            else if(read_line[i] == '/' && read_line[i+1] == '*'){
                multiline_comment_found = 1;
                read_line[i] = ' ';
                read_line[i+1] = ' ';
                i++;
            }
        }
        fprintf(destination, "%s", read_line);
        memset(read_line, 0, sizeof(read_line));
    }
}

int main(int argc, char **argv){
    argv++;
    argc--;
    if(argc == 0){
        printf("Supply file name\n");
        exit(0);
    }
    FILE* file_ptr = fopen(argv[0], "r");
    if(file_ptr == NULL){
        printf("File not found!\n");
        exit(0);
    }
    FILE* file_inter = fopen("mediator.txt", "w");
    comments_removal(file_ptr, file_inter);
    fclose(file_inter);
    fclose(file_ptr);
    file_ptr = fopen("mediator.txt", "r");

    yyin = file_ptr;
    yylex();
    increase_counts();
    printf("\nNumber of Classes           : %d\n", number_of_classes);
    printf("Number of Inherited classes : %d\n", number_of_inherited_classes);

    printf("Number of Constructors      : %d\n", number_of_constructors);

    printf("Number of Objects           : %d\n", number_of_objects);
}
/*
.
.
.
.
..
.
..
.
.
.
.
..
.
...
..
.
.
.
.
.
.
.
.
.
..
.
..
.
..
.
.
.
.
..
.
.
..
..
.
.
..
..
.
.
.
..
.
*/
