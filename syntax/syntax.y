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
S: DOCPROGRAM {printf("\nProgram compiled successfuly.");
      YYACCEPT;}

| err
;
DOCPROGRAM: left_ar excl k_docprogram idf right_ar DECLARATIONS BODY  left_ar fw_slash k_docprogram right_ar;
DECLARATIONS: DEC '\n' DECLARATIONS  | DEC;
DEC: DEC_VARIABLE | DEC_CONSTANTE| DEC_ARRAY;



DEC_VARIABLE: left_ar k_sub k_variable right_ar LIST_DEC left_ar fw_slash k_sub right_ar;
DEC_CONSTANTE: left_ar k_sub k_const right_ar LIST_DEC left_ar fw_slash k_sub right_ar;

LIST: idf | idf bar LIST;

LIST_DEC:  LIST_DEC INLINE_DEC_VAR|LIST_DEC INIT_DEC_CONST  |INLINE_DEC_VAR | INIT_DEC_CONST;



INLINE_DEC_VAR: left_ar LIST k_as TYPE fw_slash right_ar;
INIT_DEC_CONST: left_ar idf eq VALUE fw_slash right_ar;
INLINE_DEC_ARRAY: left_ar idf col v_integer fw_slash right_ar;


DEC_ARRAY: left_ar k_array k_as TYPE right_ar LIST_DEC_ARRAY left_ar fw_slash k_array right_ar;
LIST_DEC_ARRAY: LIST_DEC_ARRAY INLINE_DEC_ARRAY | INLINE_DEC_ARRAY;
TYPE: t_boolean | t_char | t_int|t_float|t_string;
BODY: left_ar k_body right_ar left_ar fw_slash k_body right_ar ;

VALUE: VALUE_BOOL |VALUE_NUMERIC | v_string;
VALUE_BOOL: v_false| v_true;
VALUE_NUMERIC: v_integer | v_real;

EXPRESSION_LOGIQUE: VALUE_BOOL | idf| AND | OR | NOT| SUP|INF|SUPE|INFE|EGA|DIF ;
EXPRESSION_ARITHMETIQUE: VALUE_NUMERIC | idf | PLUS | MOINS| DIV| FOIS| left_par EXPRESSION_ARITHMETIQUE right_par;
LIST_EXPRESSION_ARITHMETIQUE: LIST_EXPRESSION_ARITHMETIQUE EXPRESSION_ARITHMETIQUE | EXPRESSION_ARITHMETIQUE comma EXPRESSION_ARITHMETIQUE;
LIST_EXPRESSION_LOGIQUE: LIST_EXPRESSION_LOGIQUE comma EXPRESSION_LOGIQUE | EXPRESSION_LOGIQUE comma EXPRESSION_LOGIQUE;

AND: and left_par LIST_EXPRESSION_LOGIQUE right_par;
OR: or left_par LIST_EXPRESSION_LOGIQUE right_par;
NOT: not left_par EXPRESSION_LOGIQUE right_par;

PLUS: EXPRESSION_ARITHMETIQUE plus EXPRESSION_ARITHMETIQUE;
MOINS: EXPRESSION_ARITHMETIQUE dash EXPRESSION_ARITHMETIQUE;
DIV:EXPRESSION_ARITHMETIQUE fw_slash EXPRESSION_ARITHMETIQUE;
FOIS: EXPRESSION_ARITHMETIQUE asterisk EXPRESSION_ARITHMETIQUE;


SUP: sup left_par EXPRESSION_ARITHMETIQUE comma EXPRESSION_ARITHMETIQUE right_par;
INF: inf left_par EXPRESSION_ARITHMETIQUE comma EXPRESSION_ARITHMETIQUE right_par;
SUPE:supe left_par EXPRESSION_ARITHMETIQUE comma EXPRESSION_ARITHMETIQUE right_par;
INFE:infe left_par EXPRESSION_ARITHMETIQUE comma EXPRESSION_ARITHMETIQUE right_par;
EGA:ega left_par EXPRESSION_ARITHMETIQUE comma EXPRESSION_ARITHMETIQUE right_par;
DIF:dif left_par EXPRESSION_ARITHMETIQUE comma EXPRESSION_ARITHMETIQUE right_par;
INPUT:;
OUTPUT:;
IF:;
DO_WHILE:;
FOR:;
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