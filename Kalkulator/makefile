
__start__: kompilator
	./kompilator

kompilator: lex.yy.c parser.tab.c
	g++ parser.tab.c lex.yy.c -o kompilator

parser.tab.c: parser.y
	bison parser.y --defines
	
lex.yy.c: lekser.l  
	flex lekser.l 
	

