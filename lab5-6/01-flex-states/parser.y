%{
    #include <stdio.h>
    #include <iostream>
    #include <stdlib.h>
    extern int yylex();
    void yyerror(const char *s);
    extern FILE *yyin;
    extern int current_line;
%}

%token REF RREF STAR LPAREN RPAREN LBRACKET RBRACKET COMMA COLON SEMICOLON NUMBER
%token INT DOUBLE CONST CHAR VOID CONSTEXP IDENTIFIER

%start program

%%

program:
      /* pusty */
    | program function_declaration
    ;

function_declaration:
      full_type IDENTIFIER LPAREN parameter_list RPAREN SEMICOLON { 
            printf("line %d: OK\n", current_line); 
      }
    | full_type IDENTIFIER LPAREN RPAREN SEMICOLON { 
            printf("line %d: OK\n", current_line); 
      }
    | IDENTIFIER LPAREN RPAREN COLON full_type SEMICOLON { 
            printf("line %d: ERROR\n", current_line); 
      }
    | error SEMICOLON { 
            printf("line %d: ERROR\n", current_line); 
            yyerrok; 
      }
    ;

full_type:
      type_qualifiers base_type type_qualifiers pointer_suffixes
    ;

type_qualifiers:
      /* pusty */
    | type_qualifiers CONST
    | type_qualifiers CONSTEXP
    ;

base_type:
      INT
    | DOUBLE
    | CHAR
    | VOID
    ;

pointer_suffixes:
      /* pusty */
    | pointer_suffixes STAR 
    | pointer_suffixes REF
    | pointer_suffixes RREF
    ;
    
parameter_list:
      parameter
    | parameter_list COMMA parameter
    ;

parameter:
      full_type IDENTIFIER array_suffix
    | full_type array_suffix
    | full_type IDENTIFIER
    | full_type
    ;

array_suffix:
      LBRACKET NUMBER RBRACKET
    | LBRACKET RBRACKET
    ;

%%

void yyerror(const char *s)
{
    // Ukryj błąd bisona, wypisujemy tylko własne
}

int main()
{
    std::ios_base::sync_with_stdio(true);

    FILE *file = fopen("in.txt", "r");
    if (!file) {
        perror("Nie można otworzyć pliku in.txt");
        return 1;
    }

    yyin = file;
    yyparse();
    fclose(file);
    return 0;
}