cd lexical
flex lexical.l
cd ../syntax
bison -d syntax.y
cd ../
gcc ./lexical/lex.yy.c ./syntax/syntax.tab.c ./tabsym/tabsym.c ./quad/quad.c ./routines/routine.c ./optimisation/optimisation.c ./generation/generation.c -lfl -ly -o compiler.exe
compiler.exe<code.txt
