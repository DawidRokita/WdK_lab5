
%{
	#include <stdlib.h>
	#include <stdio.h>
	#include <iostream>
    #include <cmath>
	
	void yyerror(char *s);
	int yylex();
	extern FILE* yyin;

   int counter = 0;

   //#define YYSTYPE double
	
%}

%union
{
    double dtype;
}


%verbose

%type<dtype> PLUS TIMES  DIVIDE SUBSTRUCT POWER 
%type<dtype> total expression
%token<dtype> NUMBER SQRT EQUAL FACTORIAL PERCENT SIN COS INT


%left PLUS SUBSTRUCT
%left DIVIDE TIMES
%left POWER
	
%%

total      : expression EQUAL                {  std::cout <<  $1 << std::endl;   }
           ;

expression : expression PLUS expression      {  $$ = $1 + $3;   }
           | expression TIMES expression     {  $$ = $1 * $3;   } 
           | expression DIVIDE expression    {  
                if ($3 == 0) {
                    yyerror("Error: Division by zero");
                    $$ = 0;
                } else {
                    $$ = $1 / $3;
                }
            }
           | expression SUBSTRUCT expression  {  $$ = $1 - $3;   } 
           | expression POWER expression      {  $$ = pow($1, $3);  }
           | expression SQRT                 {  $$ = sqrt($1);  }
           | expression PERCENT expression    {  $$ = ($1*$3)/100;   }
           | expression FACTORIAL {  
                if ($1 < 0) {
                    yyerror("Error: Factorial of a negative number is undefined");
                    $$ = 0;
                } else {
                    $$ = 1; // Inicjalizacja wyniku
                    for (int i = 1; i <= $1; i++) {
                        $$ *= i;
                    }
                }
            }
           | SIN expression    {$$ = sin($2*M_PI*2/180);}
           | COS expression    {$$ = cos($2*M_PI*2/180);}
           | NUMBER                         {  $$ = $1;   }
           ;

;
	
%%

void yyerror(char *s)
{
    fprintf(stderr, "%s\n", s);
}

int main() 
{
    std::ios_base::sync_with_stdio (true);
    yyparse();    
    return 0;
}
