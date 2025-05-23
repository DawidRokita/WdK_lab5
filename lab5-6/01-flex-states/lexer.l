%option noyywrap

%{
    #include <stdlib.h>
    #include <iostream>
    #include "parser.tab.h"
%}

%%

"int"       { return INT; }
"float"    { return FLOAT; }
"char"      { return CHAR; }
"string"    { return STRING; }

"sin"       { return SIN; }
"cos"       { return COS; }
"pow"       { return POWER; }

"*"         { return TIMES; }
"+"         { return PLUS; }
"-"         { return MINUS; }
"/"         { return DIVIDE; }
"="         { return ASSIGN; }
";"         { return SEMICOLON; }
"("         { return LPAREN; }
")"         { return RPAREN; }

[0-9]+\.[0-9]*     { yylval.num_val = atof(yytext); return NUMBER; }
[0-9]+             { yylval.num_val = atof(yytext); return NUMBER; }

\'[a-zA-Z0-9]\'     { yylval.char_val = yytext[1]; return CHARVAL; }
\"[^\"]*\"         { yylval.id = new std::string(yytext); return STRINGVAL; }

[a-zA-Z_][a-zA-Z0-9_]* {
    yylval.id = new std::string(yytext);
    return IDENT;
}

[ \t\r\n]+      ; // pomijaj białe znaki

.               { /* ignoruj nieznane znaki */ }

%%