
%{
	#include <iostream>
    #include <stdio.h>
	using namespace std;
    int liczbaZnakow = 0;
    int liczbaLinii = 0;
	int liczbaSlow = 0;
    int liczbaZdan = 0;
    int liczbaPlikow = 0;
    int liczbaParagrafow = 0;
    int i = 0;
    int nBufor = 0;
    #define MAX 100
    YY_BUFFER_STATE stos[MAX];
%} 

%x INCLUDE
%x COMMENT
%x BEGEND




%%
"include"                       BEGIN(INCLUDE);
"%"				            BEGIN(COMMENT);
\\begin\{[a-zA-Z]+\}		BEGIN(BEGEND);

[a-zA-Z]+                       {liczbaZnakow+=strlen(yytext); liczbaSlow++;};
[0-9]+                          {liczbaZnakow++;};
.[\n\n]		        	{ liczbaZnakow++; liczbaParagrafow++; liczbaLinii++; }
\n                              { liczbaZnakow++; liczbaLinii++; }
[.?!]				{ liczbaZnakow++; liczbaZdan++; }
.                               { liczbaZnakow++; }
<INCLUDE>{
[\t]*                   ;
[a-z0-9]+"."[a-z]{3}    {

        stos[nBufor++] = YY_CURRENT_BUFFER;
        yyin = fopen(yytext,"r");
        yy_switch_to_buffer(yy_create_buffer(yyin,YY_BUF_SIZE));
        liczbaPlikow++;
        BEGIN(INITIAL);
        }
}
<COMMENT>{
.	{};
\n	BEGIN(INITIAL);
}
<BEGEND>{
\\end\{[a-zA-Z]+\}		BEGIN(INITIAL);
.	{};
}
<<EOF>> {

    if(nBufor == 0)
    {
        yyterminate();
    }
    else
    {
        yy_delete_buffer(YY_CURRENT_BUFFER);
        yy_delete_buffer(stos[--nBufor]);
    }
}



%%

int yywrap()
{
    printf("wykryto koniec pliku \n");
    printf("znaki = %d \n linie = %d \n slowa = %d \n zdania = %d \n pliki = %d \n paragrafy = %d \n", liczbaZnakow, liczbaLinii,liczbaSlow,liczbaZdan,liczbaPlikow,liczbaParagrafow/2);
    return 1;

}

int main(int argc, char** argv) 
{
        
        yylex();
        
    
    return 0;

}

 
