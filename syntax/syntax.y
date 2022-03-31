%{
#include <stdio.h>
int lignes = 1;

%}


%token left_ar right_ar fw_slash excl col left_par right_par left_bracket right_bracket bar eq semi_col plus dash asterisk comma 
%token t_int t_float t_boolean t_char t_string 
%token _true _false string 
%token docprogram as array sub body variable _const aff _input _output 
%token and or not sup inf supe infe ega dif 
%token _if  _then _else _do _while _for _until
%token idf

%%
DOCPROGRAM: left_ar excl docprogram idf right_ar  left_ar fw_slash docprogram right_ar;




%%



int yywrap() {}
int main() {
   yyparse();
   return 0;
  
}

int yyerror(char * message) {
  printf("Error : %s\n", message);
  return 0;

}