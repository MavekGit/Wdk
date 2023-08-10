
 

%option noyywrap 

%{
	
	#include <iostream>
   	
	using namespace std;
	
#ifdef _WIN32
    // needed by Visual Studio compiler:
	int isatty (int a)  // is deprecated, use _isatty instead
	{
	    return _isatty(a);
	}
	
	int fileno (FILE * f)
	{
	    return _fileno(f);
	}
#endif
	
#define DEBUG(x)  cerr << __FILE__ << " (" << __LINE__ << ") " << #x << " == " << x << endl;	
   
//	"@"[a-zA-Z0-9._%-$#]"."[pl]$
%}
 
IP1 ([0-9]|([1-9][0-9])|([0-2][0-5][0-5]))"."
IP2 ([0-9]|([1-9][0-9])|([0-2][0-5][0-5]))"."
IP3 ([0-9]|([1-9][0-9])|([0-2][0-5][0-5]))$

email ([a-zA-Z0-9])+([a-zA-Z0-9'.'_%-'$''#'])*@([a-zA-Z0-9'.'_%-'$''#'])*.[a-z]{2,}$

Kierunkowy ("+"|0)([0-9]){2}
Numer (" "|"-"|"")[0-9]{3}

%%
^{IP1}{IP2}{IP2}{IP3}              		  { cout << "poprawny adres ip " << yytext << endl; }
^{email}                                 {	cout << "poprawny adres email " << yytext << endl; }         
^{Kierunkowy}?{Numer}{Numer}{Numer}$ { cout << "poprawny numer kierunkowy " << yytext << endl; }

bye                                       {  return 0; }
.                                         {  /* inne znaki usuwamy */ }



%%

 

int main() 
{
	 yylex();   
    return 0;
}

 
