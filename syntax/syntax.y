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
DOCPROGRAM: left_ar excl k_docprogram idf right_ar DECLARATIONS left_ar fw_slash k_docprogram right_ar;
DECLARATIONS: 
  DEC DECLARATIONS | BODY ;

DEC: DEC_VARIABLE | DEC_CONSTANTE | DEC_ARRAY;

CLOSE_SUB: left_ar fw_slash k_sub right_ar;
CLOSE_ARRAY: left_ar fw_slash k_array right_ar;
OPEN_SUB_CONST: left_ar k_sub k_const right_ar;
OPEN_SUB_VAR: left_ar k_sub k_variable right_ar;
OPEN_SUB_ARRAY: left_ar k_array k_as TYPE right_ar;

TYPE: t_boolean | t_char | t_int|t_float|t_string;

DEC_VARIABLE: OPEN_SUB_VAR BLOCK_DEC_VAR;
DEC_CONSTANTE: OPEN_SUB_CONST BLOCK_DEC_CONST;
DEC_ARRAY: OPEN_SUB_ARRAY BLOCK_DEC_ARRAY;

LIST: idf | idf bar LIST;

IDF_DEC_TYPE: left_ar LIST k_as TYPE fw_slash right_ar;
IDF_DEC_INIT: left_ar idf eq VALUE fw_slash right_ar;
IDF_DEC_CONST: IDF_DEC_TYPE | IDF_DEC_INIT;
IDF_DEC_ARRAY: left_ar idf col v_integer fw_slash right_ar;

BLOCK_DEC_VAR: IDF_DEC_TYPE semi_col BLOCK_DEC_VAR | CLOSE_SUB;
BLOCK_DEC_CONST: IDF_DEC_CONST semi_col BLOCK_DEC_CONST| CLOSE_SUB;
BLOCK_DEC_ARRAY: IDF_DEC_ARRAY semi_col BLOCK_DEC_ARRAY | CLOSE_ARRAY;


VALUE: VALUE_BOOL |VALUE_NUMERIC | v_string;
VALUE_BOOL: v_false| v_true;
VALUE_NUMERIC: v_integer | v_real;
CLOSE_BODY: left_ar fw_slash k_body right_ar;
BODY: left_ar k_body right_ar BLOCK_INST  ;
INSTRUCTION: INPUT | OUTPUT | FOR | EXPRESSION_ARITHMETIQUE ;
BLOCK_INST: INSTRUCTION BLOCK_INST | CLOSE_BODY;


INPUT: left_ar k_input col idf v_string fw_slash right_ar;
OUTPUT: left_ar k_output col OUTPUT_ARG fw_slash right_ar;
OUTPUT_ARG:idf|v_string | v_string plus OUTPUT_ARG;
FOR: left_ar k_for col EXPRESSION_LOGIQUE fw_slash right_ar;

EXPRESSION_LOGIQUE: VALUE_BOOL | idf| AND | OR | NOT;
LOGICAL_ARG: EXPRESSION_LOGIQUE comma LOGICAL_ARG | EXPRESSION_LOGIQUE;
AND: and left_par LOGICAL_ARG right_par;
OR: or left_par LOGICAL_ARG right_par;
NOT: not left_par EXPRESSION_LOGIQUE right_par;


EXPRESSION_ARITHMETIQUE: VALUE_NUMERIC | idf | PLUS | left_par EXPRESSION_ARITHMETIQUE right_par;
PLUS: EXPRESSION_ARITHMETIQUE plus EXPRESSION_ARITHMETIQUE;






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