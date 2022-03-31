%{
#include <stdio.h>
int lignes = 1;

%}


%token left_ar right_ar fw_slash excl col left_par right_par left_bracket right_bracket bar eq semi_col plus dash asterisk comma 
%token t_int t_float t_boolean t_char t_string 
%token true false string 
%token docprogram as arra sub body variable const aff input output 
%token and or not sup inf supe infe ega dif 
%token if  then else do while for until
%token doc_id;

%%
DOCPROGRAM: left_ar excl docprogram doc_id right_ar  left_ar fw_slash docprogram right_ar;
DECLARATION: DECLARATION_TYPES DECLARATION | ;
DECLARATION_TYPES: DECLARATION_VARIABLE | DECLARATION_ARRAY | DECLARATION_CONST;
BODY: ;
DECLARATION_VARIABLE: left_ar sub variable right_ar LIST_VARIABLES left_ar fw_slash right_ar;
DECLARATION_ARRAY:;
DECLARATION_CONST:;



%%



yywrap() {}
main() {
   yyparse();
  
}

yyerror(char * s) {
  printf("Error");

}