%{
#include <stdio.h>
int lignes = 1;
char saveType[25];
char saveIdf[30];
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
%left plus dash
%left asterisk fw_slash
%type <string> TYPE
%start S


%%
S: DOCPROGRAM {printf("\nProgram compiled successfuly.");
      YYACCEPT;}

| err
;

DOCPROGRAM: left_ar excl k_docprogram idf right_ar DECLARATIONS left_ar fw_slash k_docprogram right_ar
;

DECLARATIONS:DEC DECLARATIONS 
             |BODY
             ;

DEC:DEC_VARIABLE
    |DEC_CONSTANTE
    |DEC_ARRAY
    ;

CLOSE_SUB: left_ar fw_slash k_sub right_ar
;

CLOSE_ARRAY: left_ar fw_slash k_array right_ar
;

OPEN_SUB_CONST: left_ar k_sub k_const right_ar
;

OPEN_SUB_VAR: left_ar k_sub k_variable right_ar;
OPEN_SUB_ARRAY: left_ar k_array k_as TYPE right_ar {strcpy(saveType, $4)};

TYPE:t_boolean {$$= "bool";}
     |t_char {$$ = "char";}
     |t_int {$$="int";}
     |t_float {$$="FLT";}
     |t_string {$$="str";}
     ;

DEC_VARIABLE: OPEN_SUB_VAR BLOCK_DEC_VAR
;
DEC_CONSTANTE: OPEN_SUB_CONST BLOCK_DEC_CONST
;
DEC_ARRAY: OPEN_SUB_ARRAY BLOCK_DEC_ARRAY
;

LIST_VAR:idf {strcpy(saveIdf,$1); printf("%s est variable\n", $1);}
    |idf bar LIST_VAR {strcpy(saveIdf,$1);printf("%s est variable\n", $1);};

LIST_CONST: idf {strcpy(saveIdf,$1);printf("%s est constante\n", $1);} 
    |idf bar LIST_CONST {strcpy(saveIdf,$1);printf("%s est constante\n", $1);}; 



IDF_DEC_INIT:left_ar idf eq VALUE fw_slash right_ar
             ;
IDF_DEC_CONST_TYPE: left_ar LIST_CONST k_as TYPE fw_slash right_ar {InsererType(saveIdf,$4);};


IDF_DEC_VAR:left_ar LIST_VAR k_as TYPE fw_slash right_ar {InsererType(saveIdf,$4);}
            ;

IDF_DEC_CONST:IDF_DEC_CONST_TYPE 
              |IDF_DEC_INIT
              ;
IDF_DEC_ARRAY: left_ar idf col v_integer fw_slash right_ar {InsererTailleTab($2,$4);strcpy(saveIdf,$2);InsererType(saveIdf,saveType);}
;

BLOCK_DEC_VAR:IDF_DEC_VAR semi_col BLOCK_DEC_VAR
              |CLOSE_SUB
              ;

BLOCK_DEC_CONST:IDF_DEC_CONST semi_col BLOCK_DEC_CONST
               |CLOSE_SUB
               ;

BLOCK_DEC_ARRAY:IDF_DEC_ARRAY semi_col BLOCK_DEC_ARRAY 
               |CLOSE_ARRAY
;


VALUE:VALUE_BOOL 
     |VALUE_NUMERIC 
     |v_string
     ;

VALUE_BOOL:v_false
          |v_true
          ;
VALUE_NUMERIC:v_integer
             |v_real
             ;
CLOSE_BODY: left_ar fw_slash k_body right_ar;
BODY: left_ar k_body right_ar BLOCK_INST  ;

INSTRUCTION:INPUT
           |OUTPUT
           |CONDITIONAL
           | DO_WHILE
           |FOR
           |AFF 
           ;

BLOCK_INST:INSTRUCTION BLOCK_INST
          |CLOSE_BODY
          ;
BLOCK_INST_THEN:INSTRUCTION BLOCK_INST_THEN
               |CLOSE_THEN
               ;
BLOCK_INST_ELSE:INSTRUCTION BLOCK_INST_ELSE
               |CLOSE_ELSE
               ;
BLOCK_INST_FOR:INSTRUCTION BLOCK_INST_FOR
              |CLOSE_FOR
              ;

CLOSE_FOR:left_ar fw_slash k_for right_ar
;
CLOSE_IF:left_ar fw_slash k_if right_ar
;
CLOSE_THEN:left_ar fw_slash k_then right_ar
;
CLOSE_ELSE:left_ar fw_slash k_else right_ar
;

INPUT:left_ar k_input col idf v_string fw_slash right_ar
;
OUTPUT:left_ar k_output col OUTPUT_ARG fw_slash right_ar
;
OUTPUT_ARG:idf
          |v_string
          |v_string plus OUTPUT_ARG
          ;

COND_IF:left_ar k_if col EXPRESSION_LOGIQUE right_ar left_ar k_then right_ar BLOCK_INST_THEN
;
COND_IF_ELSE:COND_IF left_ar k_else right_ar BLOCK_INST_ELSE
;

CONDITIONAL:COND_IF CLOSE_IF
           |COND_IF_ELSE CLOSE_IF
           ;

BLOCK_INST_DO: INSTRUCTION BLOCK_INST_DO | CLOSE_DO
;
CLOSE_DO: WHILE left_ar fw_slash k_do right_ar
;
WHILE: left_ar k_while col EXPRESSION_LOGIQUE fw_slash right_ar
;
DO_WHILE: left_ar k_do right_ar BLOCK_INST_DO
;

FOR: left_ar k_for FOR_INIT  UNTIL right_ar BLOCK_INST_FOR;
FOR_INIT: idf eq v_integer;
UNTIL:k_until v_integer
     |k_until idf
     ;


EXPRESSION_LOGIQUE:VALUE_BOOL
                  |AND
                  |OR
                  |NOT
                  |SUP
                  |INF
                  |SUPE
                  |INFE
                  |EGA
                  |DIF
                  ;

LOGICAL_ARG:EXPRESSION_LOGIQUE comma LOGICAL_ARG
           |EXPRESSION_LOGIQUE 
           |IDF
           |IDF comma LOGICAL_ARG
           ;
AND:and left_par LOGICAL_ARG right_par
;
OR:or left_par LOGICAL_ARG right_par
;
NOT:not left_par EXPRESSION_LOGIQUE right_par
   |not left_par IDF right_par
;


EXPRESSION_ARITHMETIQUE:EXPRESSION_ARITHMETIQUE plus EXPRESSION_ARITHMETIQUE 
                        |EXPRESSION_ARITHMETIQUE dash EXPRESSION_ARITHMETIQUE 
                        |EXPRESSION_ARITHMETIQUE asterisk EXPRESSION_ARITHMETIQUE 
                        |EXPRESSION_ARITHMETIQUE fw_slash EXPRESSION_ARITHMETIQUE 
                        |left_par EXPRESSION_ARITHMETIQUE right_par
                        |IDF plus EXPRESSION_ARITHMETIQUE
                        |IDF dash EXPRESSION_ARITHMETIQUE 
                        |IDF asterisk EXPRESSION_ARITHMETIQUE 
                        |IDF fw_slash EXPRESSION_ARITHMETIQUE
                        |EXPRESSION_ARITHMETIQUE plus IDF
                        |EXPRESSION_ARITHMETIQUE dash IDF 
                        |EXPRESSION_ARITHMETIQUE asterisk IDF 
                        |EXPRESSION_ARITHMETIQUE fw_slash IDF  
                        |v_integer {if(toInt($1)>50) {printf("erreur val sup!!!");}}
                        |v_real  
                        ;

IDF:idf
    |IDF_TAB
    ;
IDF_TAB:idf left_bracket TAB_ARG right_bracket;
TAB_ARG:IDF
       |v_integer
       ;

AFF:left_ar k_aff col IDF comma AFF_ARG
;
AFF_ARG:IDF fw_slash right_ar
       |EXPRESSION_ARITHMETIQUE fw_slash right_ar
       |EXPRESSION_LOGIQUE fw_slash right_ar
       ;

SUP: sup left_par COMP_ARG right_par
;
INF: inf left_par COMP_ARG right_par
;
SUPE:supe left_par COMP_ARG right_par
;
INFE:infe left_par COMP_ARG right_par
;
EGA:ega left_par COMP_ARG right_par
;
DIF:dif left_par COMP_ARG right_par
;

COMP_ARG:EXPRESSION_ARITHMETIQUE comma EXPRESSION_ARITHMETIQUE
        |IDF comma EXPRESSION_ARITHMETIQUE
        |IDF comma IDF
        |EXPRESSION_ARITHMETIQUE comma IDF
        ;





%%


int yywrap() {}
main() {
   initialiter();
   yyparse();
   affiche();
}

int yyerror(char * message) {
  printf("code:%d: %s\n", lignes, message);
  return 0;

}