
__start__: kompilator
	./kompilator

kompilator: lex.yy.c  
	g++ -std=c++14 lex.yy.c -o kompilator

lex.yy.c: lekser.l 
	flex lekser.l 
	
generator: generator.cpp
	g++ -std=c++14 generator.cpp -o generator
	
dane : generator
	rm -r data
	mkdir data
	./generator
	ls -U data/* > data.txt	
	
zadanie : zadanie.tex
	pdflatex zadanie
