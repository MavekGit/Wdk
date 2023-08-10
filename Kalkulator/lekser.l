%option noyywrap

%{
#include <stdlib.h> 
#include <iostream>
#include "parser.tab.h"
using namespace std;

//extern int yylval;
%}
 
%%
"max"          { return MAX; }
"mean"         { return MEAN; }
"min"          { return MIN; }
"median"       { return MEDIAN; }   
"+"            { return '+'; }
"-"            { return '-'; }
"*"            { return '*'; }
"/"            { return '/'; }
"="            { return '='; }
"^"            { return '^'; }
","            { return ','; }
"("            { return '('; }
")"            { return ')'; }
[0-9]+         { yylval.dtype = atoi(yytext); return LICZBA; }
[a-z]+         { yylval.ctype = yytext[0]; return ZNAK;}
\n             { return '\n'; }

.              { } /* pozostale znaki usun */
              
%%
