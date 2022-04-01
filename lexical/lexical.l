
%{
 #include <stdio.h>
 #include "../syntax/syntax.tab.h"
 extern lignes;
 extern YYSTYPE yylval;
%}

lettre [a-zA-Z]
chiffre [0-9]
idf {lettre}({lettre}|{chiffre}|_({lettre}|{chiffre})+)*

string ["](.)*["]
entier (0|[-]?[1-9]{chiffre}*)
reel ([-]?{chiffre}+[.]{chiffre}*[1-9])


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
FALSE {return _false;}
{entier} { 
  yylval._int = atoi(yytext);
  return integer;}
{reel} {
  yylval._float = atof(yytext);
  return real;}
{string} {
  yylval.str = strdup(yytext);
  return string;}

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
{idf} {
  yylval.str = strdup(yytext);
  return idf;}

[ \t]
[\n] lignes++;
. {
  printf("code:%d: error: token \" %s \" unrecognized\n",lignes,yytext); return err;}

%%



