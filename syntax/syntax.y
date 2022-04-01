%{
#include <stdio.h>
int lignes = 1;

%}

%union{
  int integer;
  char* string;
  float real;
}



%token left_ar right_ar fw_slash excl col left_par right_par left_bracket right_bracket bar eq semi_col plus dash asterisk comma 
%token t_int t_float t_boolean t_char t_string 
%token <integer>v_true <integer> v_false <string> v_string <real> v_real <integer> v_integer
%token k_docprogram k_as k_array k_sub k_body k_variable k_const k_aff k_input k_output 
%token and or not sup inf supe infe ega dif 
%token k_if  k_then k_else k_do k_while k_for k_until
%token <string> idf err
%start S

%%
S: DOCPROGRAM {printf("Program compiled successfuly.");
      YYACCEPT;}

| err
;
DOCPROGRAM: left_ar excl k_docprogram idf right_ar DECLARATIONS BODY  left_ar fw_slash k_docprogram right_ar;
DECLARATIONS: DECLARATIONS DEC |  ;
DEC: DEC_VARIABLE | DEC_CONSTANTE| DEC_ARRAY;

DEC_VARIABLE: left_ar k_sub k_variable right_ar LIST_DEC_VARIABLE left_ar fw_slash k_sub right_ar;
LIST_DEC_VARIABLE:;

DEC_CONSTANTE: left_ar k_sub k_const right_ar LIST_DEC_CONSTANTE left_ar fw_slash k_sub right_ar;
LIST_DEC_CONSTANTE:;

DEC_ARRAY: left_ar k_array k_as TYPE right_ar LIST_DEC_ARRAY left_ar fw_slash k_array;
LIST_DEC_ARRAY:;
TYPE: t_boolean | t_char | t_int|t_float|t_string;
BODY: left_ar k_body right_ar left_ar fw_slash k_body right_ar ;


%%



int yywrap() {}
int main() {
   yyparse();
   return 0;
  
}

int yyerror(char * message) {
  printf("code:%d: %s\n", lignes, message);
  return 0;

}