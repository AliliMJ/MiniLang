
cd lexical
flex lexical.l
cd ../syntax
bison -d syntax.y
cd ../

gcc ./lexical/lex.yy.c ./syntax/syntax.tab.c -o compiler.exe
