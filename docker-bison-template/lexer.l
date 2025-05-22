
 


%option noyywrap

%{
   #include <stdlib.h> 
   #include <iostream>
	#include "parser.tab.h"
%}

%%

[0-9]+(\.[0-9]*)?         { /* int */ yylval.dtype =  atof(/* char* */ yytext);  return NUMBER; } 
"*"            return TIMES;
"+"            return PLUS;
"-"            return SUBSTRUCT;
"/"            return DIVIDE;
"**"           return POWER;
"sqrt"         return SQRT;
"%"            return PERCENT;
"!"            return FACTORIAL;
"sin"          return SIN;
"cos"          return COS;
=              return EQUAL;

""

.              /* remove other characters */
             

%%
