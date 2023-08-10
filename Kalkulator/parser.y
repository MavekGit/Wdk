%{
#include <stdlib.h>
#include <stdio.h>
#include <iostream>
#include "parser.tab.h"
#include <math.h>
#define YYSTPE double
using namespace std;

void yyerror(const char *s);
//extern FILE* yyin;
int yylex();
int zmienne['z' - 'a'];
int licznik = 0;
int pt_buffer=0;
double buffer[100];
%}

 %union
 {
    
    double dtype;
    char ctype;
 }
 
%verbose

%token  MAX MEAN MIN MEDIAN
%token  <dtype>LICZBA
%token  <ctype>ZNAK
%type   <dtype>program
%type   <dtype>wyrazenie
%type   <dtype>param_max
%type   <dtype>param_min
%type   <dtype>param_mean
%type   <dtype>param_median
%left   '+' '-'
%left   '*' '/'
%left   NEG
%right  '^'



%%
program: program wyrazenie '\n' { printf("Wynik = %lf\n\n",$2); }
    |   error '\n'              { yyerror("obsługa błedu"); yyerrok; }
    | 
    ;

wyrazenie: LICZBA           { $$ = $1; }
|   ZNAK                    { $$ = $1; }
|   ZNAK                    { $$ = zmienne[$1 - 'a']; }
|   ZNAK '=' wyrazenie      { $$ = $3; zmienne[$1 - 'a'] = $3; }
|   wyrazenie '+' wyrazenie { $$ = $1 + $3; }
|   wyrazenie '-' wyrazenie { $$ = $1 - $3; }
|   '('wyrazenie')'         { $$ = $2;}
|   wyrazenie '*' wyrazenie { $$ = $1 * $3; }
|   wyrazenie '^' wyrazenie { $$ = pow($1, $3); }
|   '-' wyrazenie %prec NEG { $$ = - $2; }
|   MAX     '(' param_max ')'           { $$ = $3; }
|   MIN     '(' param_min ')'           { $$ = $3; }
|   MEAN    '(' param_mean ')'          { $$ = $3/licznik; ; licznik=0; }
|   MEDIAN  '(' param_median ')'        { for(int i = 0; i  < pt_buffer; i++)
                                            { for(int j = 0; j < pt_buffer-1;j++)
                                                { if(buffer[j]>buffer[j+1]) 
                                                    {
                                                        int kopia = buffer[j+1]; buffer[j+1] = buffer[j]; buffer[j] = kopia;
                                                    }   
                                                }     
                                            }
                                            if(pt_buffer%2==0)
                                            { 
                                                $$ = buffer[pt_buffer/2]-1;
                                            }
                                            else
                                            {
                                                $$ = (buffer[int(pt_buffer/2)]+buffer[int(pt_buffer/2)+1])/2.0;
                                                pt_buffer = 0;
                                            }  }
|   wyrazenie '/' wyrazenie {if($3 != 0 )
                             $$ = $1 / $3;
                            else {
                                $$ = 1;
                                fprintf(stderr, "%d.%d-%d.%d: dzielenie przez zero ",
                                @3.first_line, @3.first_column,
                                @3.last_line, @3.last_column);
                                } 
                            } 


|
;

param_max: LICZBA                       { $$ = $1; }
| param_max ',' LICZBA                  { $$ = $1 > $3 ? $1 : $3; }
| 
;

param_min: LICZBA                       { $$ = $1; }
| param_min ',' LICZBA                  { $$ = $1 < $3 ? $1 : $3; }
| 
;

param_mean: LICZBA                      { $$ = $1; licznik++; }
| param_mean ',' LICZBA                 { $$ = $1 + $3; licznik++; }
|
;
param_median: LICZBA                      { buffer[0] = $1; pt_buffer = 0; }
| param_median ',' LICZBA                 { buffer[pt_buffer++] = $3; }
|
;
%%

void yyerror(const char *s) 
{
    fprintf(stderr, "%s\n", s);
}

int main() 
{
    //std::ios_base::sync_with_stdio(true);
    yyparse();    
    return 0;
}
