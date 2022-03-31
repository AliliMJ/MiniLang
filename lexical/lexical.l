
%{
 #include <stdio.h>
 #include "../syntax/syntax.tab.h"
 extern int lignes;
%}

lettre [a-zA-Z]
chiffre [0-9]
idf {lettre}({lettre}|{chiffre}|_({lettre}|{chiffre})+)*
string ["](.)*["]


%%

"<" {return left_ar;}
">" {return right_ar;}
"/" {return fw_slash;}
"!" { return excl;}
":" {return col;}
"(" {return left_par;}
")" {return right_par;}
"[" {return left_bracket;}
"]" {return right_bracket;}
"|" {return bar;}
"=" {return eq;}
";" {return semi_col;}
"+" {return plus;}
"-" {return dash;}
"*" {return asterisk;}
"," {return comma;}
INT {return t_int;}
FLT { return t_float;}
BOL {return t_boolean;}
CHR {return t_char;}
STR {return t_string;}
TRUE {return _true;}
FALESE {return _false;}
{string} {return string;}
docprogram {return docprogram;}
AS {return as;}
ARRAY {return array;}
SUB {return sub;} 
body {return body;}
VARIABLE {return variable;}
CONSTANTE {return _const;}
AFF {return aff;}
INPUT {return _input;}
OUTPUT {return _output;}
AND {return and;}
OR {return or;}
NOT {return not;}
SUP {return sup;}
INF {return inf;}
SUPE {return supe;}
INFE {return infe;}
EGA {return ega;}
DIF {return dif;}
IF {return _if;} 
THEN {return _then;}
ESLE {return _else;}
DO {return _do;}
WHILE {return _while;}
FOR {return _for;}
UNTIL {return _until;}
{idf} {return idf;}

[ \t]
[\n] lignes++;
. { printf("Lexical error!");}

%%



