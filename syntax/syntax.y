%{
#include <stdio.h>
#include <string.h>

#include "../tabsym/tabsym.h"
#include "../quad/quad.h"

#define BOOL "BLT"
#define INT "INT"
#define FLOAT "FLT"
#define STRING "STR"
#define CHAR "CHR"
int lignes = 1;
char saveType[25];
char saveIdf[30];
char currentExpType[25];

int nTemp=1; char tempC[12]=""; 

void setType(char* s) {
  strcpy(saveType, s);
}
%}


%union {int integer;
  char* string;
  float real;
  char ch;  
  struct {int type;char* res;}NT;
  }



%token left_ar right_ar fw_slash excl col left_par right_par left_bracket right_bracket bar eq semi_col plus dash asterisk comma 
%token t_int t_float t_boolean t_char t_string 
%token <integer>v_true <integer> v_false <string> v_string <real> v_real <integer> v_integer <ch>v_char
%token k_docprogram k_as k_array k_sub k_body k_variable k_const k_aff k_input k_output 
%token and or not sup inf supe infe ega dif 
%token k_if  k_then k_else k_do k_while k_for k_until
%token <string> idf err
%left plus dash
%left asterisk fw_slash
%left left_par right_par 
%type <string> TYPE
%type <string> IDF
%type <string> IDF_TAB
%type<NT> EXPRESSION_ARITHMETIQUE
%type<NT> AFF_ARG
%start S


%%
S: DOCPROGRAM {printf("\n ********* Program compiled successfuly. *********\n");
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
OPEN_SUB_ARRAY: left_ar k_array k_as TYPE right_ar {setType($4)};

TYPE:t_boolean {$$= BOOL;}
     |t_char {$$ = CHAR;}
     |t_int {$$=INT;}
     |t_float {$$=FLOAT;}
     |t_string {$$=STRING;}
     ;

DEC_VARIABLE: OPEN_SUB_VAR BLOCK_DEC_VAR 
;
DEC_CONSTANTE: OPEN_SUB_CONST BLOCK_DEC_CONST
;
DEC_ARRAY: OPEN_SUB_ARRAY BLOCK_DEC_ARRAY
;

LIST_VAR:IDF_CONTROLLER 
    |IDF_CONTROLLER bar LIST_VAR 
    ;

IDF_CONTROLLER: idf {if(ExistDeclaration($1)==0) {
                       if(insererT($1)==-1)
                        printf("erreur semantique [%d] : double declaration de \"%s\"\n",lignes,$1);

          }
                     else 
                        printf("erreur semantique [%d] : double declaration de \"%s\"\n",lignes,$1);
                     };



LIST_CONST: IDF_CONTROLLER_CSTE
    | IDF_CONTROLLER_CSTE bar LIST_CONST ;

IDF_CONTROLLER_CSTE:idf{{if(ExistDeclaration($1)==0) {
                       if(insererCnst($1)==-1)
                        printf("erreur semantique [%d] : double declaration de \"%s\"\n",lignes,$1);

          }
                     else 
                       printf("erreur semantique [%d] : double declaration de \"%s\"\n",lignes,$1);
                     };};

IDF_DEC_INIT:left_ar idf eq VALUE fw_slash right_ar {cnsteInit($2,"oui");InsererType($2,saveType);}
             ;
IDF_DEC_CONST_TYPE: left_ar LIST_CONST k_as TYPE fw_slash right_ar {InsererTypeCnste($4,"null");};


IDF_DEC_VAR:left_ar LIST_VAR k_as TYPE fw_slash right_ar {InsererTypeC($4);}
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
     |v_string {setType(STRING);}
     |v_char {setType(CHAR);}
     ;

VALUE_BOOL:v_false {setType(BOOL);}
          |v_true {setType(BOOL);}
          ;
VALUE_NUMERIC:v_integer {setType(INT);}
             |v_real {setType(FLOAT);}
             ;
CLOSE_BODY: left_ar fw_slash k_body right_ar;
BODY: left_ar k_body right_ar BLOCK_INST  ;

INSTRUCTION:INPUT
           |OUTPUT
           |CONDITIONAL
           |DO_WHILE
           |FOR
           |AFF
           |v_integer | v_real 
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

INPUT:left_ar k_input col idf v_string fw_slash right_ar {if(ExistDeclaration($4)==0){
  printf("erreur semantique [%d] : variable non declarer dans input \"%s\"\n",lignes,$4);
}else{
  cmpcomp($5,$4,lignes);
}}
;
OUTPUT:left_ar k_output col OUTPUT_ARG fw_slash right_ar 
;
OUTPUT_ARG:OUTPUT_STR plus OUTPUT_ARG 
          |OUTPUT_IDF plus OUTPUT_ARG 
          |OUTPUT_IDF 
          |OUTPUT_STR 
          ;

OUTPUT_STR:v_string ;
OUTPUT_IDF:idf ;
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
FOR_INIT: idf eq v_integer{if(ExistDeclaration($1)==0){
  printf("erreur semantique [%d] : variable non declarer \"%s\"\n",lignes,$1);}}
;
UNTIL:k_until v_integer
     |k_until idf {if(ExistDeclaration($2)==0){
  printf("erreur semantique [%d] : variable non declarer \"%s\"\n",lignes,$2);}}
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


EXPRESSION_ARITHMETIQUE:EXPRESSION_ARITHMETIQUE plus EXPRESSION_ARITHMETIQUE {sprintf(tempC,"T%d",nTemp);nTemp++;$$.res=strdup(tempC);tempC[0]='\0';quad ("+",$1.res,$3.res,$$.res);}
                        |EXPRESSION_ARITHMETIQUE dash EXPRESSION_ARITHMETIQUE {sprintf(tempC,"T%d",nTemp);nTemp++;$$.res=strdup(tempC);tempC[0]='\0';quad ("-",$1.res,$3.res,$$.res);}
                        |EXPRESSION_ARITHMETIQUE asterisk EXPRESSION_ARITHMETIQUE {sprintf(tempC,"T%d",nTemp);nTemp++;$$.res=strdup(tempC);tempC[0]='\0';quad ("*",$1.res,$3.res,$$.res);}
                        |EXPRESSION_ARITHMETIQUE fw_slash EXPRESSION_ARITHMETIQUE {sprintf(tempC,"T%d",nTemp);nTemp++;$$.res=strdup(tempC);tempC[0]='\0';quad ("/",$1.res,$3.res,$$.res);}
                        |left_par EXPRESSION_ARITHMETIQUE right_par {$$=$2;}
                        |IDF plus EXPRESSION_ARITHMETIQUE {isNumeric($1);}
                        |IDF dash EXPRESSION_ARITHMETIQUE {isNumeric($1);}
                        |IDF asterisk EXPRESSION_ARITHMETIQUE {isNumeric($1);}
                        |IDF fw_slash EXPRESSION_ARITHMETIQUE {isNumeric($1);}
                        |EXPRESSION_ARITHMETIQUE plus IDF {isNumeric($3);}
                        |EXPRESSION_ARITHMETIQUE dash IDF {isNumeric($3);}
                        |EXPRESSION_ARITHMETIQUE asterisk IDF {isNumeric($3);}
                        |EXPRESSION_ARITHMETIQUE fw_slash IDF {isNumeric($3);}
                        |v_integer {testRangInt($1,lignes,saveIdf);$$.res=IntToChar($1);}
                        |v_real {testRangFlt($1,lignes,saveIdf);$$.res=FltToChar($1);}
                        ;

IDF:idf {strcpy(saveIdf,$1);$$=$1;if(ExistDeclaration($1)==0){
  printf("erreur semantique [%d] : variable non declarer \"%s\"\n",lignes,$1);}}
    |IDF_TAB
    ;
IDF_TAB:idf left_bracket TAB_ARG right_bracket {$$=$1;strcpy(saveIdf,$1);if(ExistDeclaration($1)==0){
  printf("erreur semantique [%d] : variable non declarer \"%s\"\n",lignes,$1);}};
TAB_ARG:IDF
       |v_integer
       ;

AFF:left_ar k_aff col IDF comma AFF_ARG {if(csteDejaAff($4)==1){printf("erreur semantique [%d] : constante deja affecter \"%s\"\n",lignes,$4);}quad ("=",$6.res,"",$4);}
| left_ar k_aff col IDF comma IDF fw_slash right_ar {compatible($4, $6);if(csteDejaAff($4)==1){printf("erreur semantique [%d] : constante deja affecter \"%s\"\n",lignes,$4);}}
;
AFF_ARG:EXPRESSION_ARITHMETIQUE fw_slash right_ar {isNumeric(saveIdf);$$.res=$1.res}
       |EXPRESSION_LOGIQUE fw_slash right_ar {idfHasType(saveIdf, BOOL);}
       |v_string fw_slash right_ar {idfHasType(saveIdf, STRING);$$.res=transfertString($1);}
       |v_char fw_slash right_ar {idfHasType(saveIdf, CHAR);$$.res=CharToString($1)}
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


int yywrap();

int main() {
   initialiter();
   initialiterListeIdf();
   initialiterListeCnst();
   initialiterListeIdfOut();
   yyparse();
   affiche();
   afficherQuad();
}

int yyerror(char * message) {
  printf("code:%d: %s\n", lignes, message);
  return 0;

}