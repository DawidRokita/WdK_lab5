%{
    #include <stdlib.h>
    #include <stdio.h>
    #include <iostream>
    #include <math.h>

    void yyerror(const char *msg);
    int yylex();
    extern FILE* yyin;
%}

%union {
    float num_val;
    std::string *id;
    char char_val;
}

%verbose

%token PLUS TIMES ASSIGN MINUS DIVIDE POWER SIN COS INT SEMICOLON FLOAT CHAR STRING
%token LPAREN RPAREN
%token<num_val> NUMBER
%type<id> declaration
%type<num_val> expr
%token<id> IDENT
%token<char_val> CHARVAL
%token<id> STRINGVAL
%left MINUS PLUS
%left DIVIDE TIMES
%left POWER
%left SIN COS

%%

declaration:
      INT IDENT ASSIGN expr SEMICOLON {
          std::cout << "OK: int " << *$2 << " = " << $4 << std::endl;
          delete $2;
      }
    | FLOAT IDENT ASSIGN expr SEMICOLON {
          std::cout << "OK: float " << *$2 << " = " << $4 << std::endl;
          delete $2;
      }
    | CHAR IDENT ASSIGN CHARVAL SEMICOLON {
          std::cout << "OK: char " << *$2 << " = '" << $4 << "'" << std::endl;
          delete $2;
      }
    | STRING IDENT ASSIGN STRINGVAL SEMICOLON {
          std::cout << "OK: string " << *$2 << " = " << *$4 << std::endl;
          delete $2; delete $4;
      }
    | INT TIMES IDENT ASSIGN expr SEMICOLON {
          std::cout << "OK: int* " << *$3 << " = " << $5 << std::endl;
          delete $3;
      }
    | FLOAT TIMES IDENT ASSIGN expr SEMICOLON {
          std::cout << "OK: float* " << *$3 << " = " << $5 << std::endl;
          delete $3;
      }
    | CHAR TIMES IDENT ASSIGN CHARVAL SEMICOLON {
          std::cout << "OK: char* " << *$3 << " = '" << $5 << "'" << std::endl;
          delete $3;
      }
    | STRING TIMES IDENT ASSIGN STRINGVAL SEMICOLON {
          std::cout << "OK: string* " << *$3 << " = " << *$5 << std::endl;
          delete $3; delete $5;
      }
    ;

expr:
      expr PLUS expr      { $$ = $1 + $3; }
    | expr TIMES expr     { $$ = $1 * $3; }
    | expr MINUS expr     { $$ = $1 - $3; }
    | expr POWER expr     { $$ = pow($1, $3); }
    | SIN expr            { $$ = sin($2); }
    | COS expr            { $$ = cos($2); }
    | LPAREN expr RPAREN  { $$ = $2; }
    | expr DIVIDE expr    {
            if ($3 != 0) $$ = $1 / $3;
            else yyerror("Division by zero!");
        }
    | NUMBER              { $$ = $1; }
    ;

%%

void yyerror(const char *msg)
{
    std::cerr << "Syntax error: " << msg << std::endl;
}

int main()
{
    std::ios_base::sync_with_stdio(true);
    yyparse();
    return 0;
}