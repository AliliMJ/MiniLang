%{
#include <stdio.h>
#include <string.h>

#include "../tabsym/tabsym.h"
#include "../quad/quad.h"
#include "../optimisation/optimisation.h"
#include "../routines/routine.h"
#include "../generation/generation.h"

#define BOOL "BLT"
#define INT "INT"
#define FLOAT "FLT"
#define STRING "STR"
#define CHAR "CHR"
int lignes = 1;
char saveType[25];
char saveIdf[30];
char currentExpType[25];
char saveOp[6];
char tempFor[25];
char saveIdfFor[25];
extern int indq;
extern int nb1;
extern int nb2;
int debDoWhile;
int debIf;
int thenIf;
int saveFor;
int saveUntil;


void setType(char* s) {
  strcpy(saveType, s);
}
%}

%union {int integer;
  char* string;
  float real;
  char ch;  
  struct {int type;char* res;}NT;
  struct {char* ref;} REF;
  struct {char* ch1;char* ch2;}NTT;
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
%type <string> TAB_ARG
%type<NT> EXPRESSION_ARITHMETIQUE
%type<NT> EXPRESSION_LOGIQUE
%type<NT> AFF_ARG
%type <integer>VALUE_BOOL
%type <string> VALUE
%type <string> VALUE_NUMERIC
%type <NT> AND_ARG
%type <NT> OR_ARG
%type <string> AND
%type <string> OR
%type <string> NOT
%type <string> DIF
%type <string> EGA
%type <string> INF
%type <string> INFE
%type <string> SUP
%type <string> SUPE
%type <string> COMP_ARG
%type <string> OPEN_WHILE
%type <string> IF_COND_A
%type <string> COND_IF
%type <string> BLOCK_FOR
%type <string> FOR
%type <string> UNTIL
%type <NTT> FOR_DEB
%type <NTT> FOR_INIT
%type <string> COND_IF_ELSE_A
%type <string> COND_IF_ELSE
%type <string> CONDITIONAL



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
                        printf("erreur semantique [%d] : double declaration de ******* \"%s\"\n",lignes,$1);

          }
                     else 
                        printf("erreur semantique [%d] : double declaration de \"%s\"\n",lignes,$1);
                     };



LIST_CONST: IDF_CONTROLLER_CSTE
    | IDF_CONTROLLER_CSTE bar LIST_CONST ;

IDF_CONTROLLER_CSTE:idf{if(ExistDeclaration($1)==0) {
                       if(insererCnst($1)==-1)
                        printf("erreur semantique [%d] : double declaration de \"%s\"\n",lignes,$1);

          }
                     else 
                       printf("erreur semantique [%d] : double declaration de \"%s\"\n",lignes,$1);
                     };

IDF_DEC_INIT:left_ar idf eq VALUE fw_slash right_ar {cnsteInit($2,"oui");InsererType($2,saveType);
    quad("=", $4, "", $2);insererCsteVal($2,$4);

}
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


VALUE:VALUE_BOOL {$$=BoolToString($1);}
     |VALUE_NUMERIC {$$=$1}
     |v_string {setType(STRING);$$=transfertString($1);}
     |v_char {setType(CHAR);$$=CharToString($1);}
     ;

VALUE_BOOL:v_false {setType(BOOL);$$=0;}
          |v_true {setType(BOOL);$$=1;}
          ;
VALUE_NUMERIC:v_integer {setType(INT); $$=IntToChar($1);}
             |v_real {setType(FLOAT);$$=FltToChar($1);}
             ;
CLOSE_BODY: left_ar fw_slash k_body right_ar;
BODY: left_ar k_body right_ar BLOCK_INST  ;

INSTRUCTION:INPUT
           |OUTPUT
           |CONDITIONAL
           |DO_WHILE
           |FOR
           |AFF
           |v_integer
           |v_real 
           ;

BLOCK_INST:INSTRUCTION BLOCK_INST
          |CLOSE_BODY
          ;

INPUT:left_ar k_input col idf v_string fw_slash right_ar {if(ExistDeclaration($4)==0){
  ExistDeclarationPin($4,lignes);
}else{
  cmpcomp($5,$4,lignes);
}}
;
OUTPUT:left_ar k_output col OUTPUT_ARG fw_slash right_ar {testoutput(lignes);initialiser();}
;
OUTPUT_ARG:v_string plus idf plus OUTPUT_ARG {insererT1($3);outputChaine($1);}
          |v_string plus idf {insererT1($3);outputChaine($1);}
          |v_string {outputChaine($1);}
          |v_string plus OUTPUT_ARG {outputChaine($1);}
          ;
 

CONDITIONAL:COND_IF CLOSE_IF {q[atoi($1)-1].op1=IntToChar(indq);} //mettre l'adresse de la fin dans le quad pour sauter en cas de false
           |COND_IF_ELSE CLOSE_IF {q[atoi($1)].op1=IntToChar(indq);} //mettre l'adresse de la fin dans le quad pour sauter le ELSE en cas l'execution de IF
           ;

//transporter l'index de (BR , , , ) dans COND_IF_ELSE et mettre dans la quad de (BZ , , , ) l'adresse pour aller vers ELSE 
COND_IF_ELSE: COND_IF COND_IF_ELSE_A BLOCK_INST_ELSE {$$=$2;q[atoi($1)-1].op1=IntToChar(atoi($2)+1);}
;

//creer le quad (BR , , , ) pour sauter le ELSE en cas l'execution de IF sans adresse et transporter l'index de quad pour le mettre a jour ulterieurement
COND_IF_ELSE_A:  left_ar k_else right_ar {$$=IntToChar(indq);quad("BR","","","");}
;

BLOCK_INST_ELSE:INSTRUCTION BLOCK_INST_ELSE 
               |CLOSE_ELSE
               ;

CLOSE_ELSE:left_ar fw_slash k_else right_ar 
;
//transporter l'index precedent de IF_COND_A de COND_IF (2)
COND_IF:left_ar k_if col IF_COND_A right_ar left_ar k_then right_ar BLOCK_INST_THEN {$$=$4;}
;
//creer le quad (BZ , , , ) et sauvgarder l'index de quadreplet
//transporter l'index de quadreplet dans le non terminal IF_COND_A (1)
IF_COND_A : EXPRESSION_LOGIQUE {quad("BZ","",$1.res,"");$$=IntToChar(indq);}
;

BLOCK_INST_THEN:INSTRUCTION BLOCK_INST_THEN
               |CLOSE_THEN 
               ;

CLOSE_IF:left_ar fw_slash k_if right_ar 
;

CLOSE_THEN:left_ar fw_slash k_then right_ar
;



DO_WHILE: OPEN_WHILE BLOCK_INST_DO {quad("BNZ",$1, q[indq-1].res, "");} 
;
OPEN_WHILE:left_ar k_do right_ar {$$=IntToChar(indq);}
;
BLOCK_INST_DO: INSTRUCTION BLOCK_INST_DO | CLOSE_DO 
;
CLOSE_DO: WHILE left_ar fw_slash k_do right_ar 
;
WHILE: left_ar k_while col EXPRESSION_LOGIQUE fw_slash right_ar 
;

//incrementer le compteur a la fin de la boucle avec 1 telque l'indice se trouve dans $1.ch2
//generer quad de BR pour revenir au debut pour tester i avec la valeur maximale $1.ch1 est l'adresse de debut (BE, , , );
//q[atoi($1)].op1=$2 pour mettre l'adresse de la fin pour sauter la boucle i=max
FOR:  FOR_DEB BLOCK_FOR {strcpy(tempFor,temporaire());quad("+",$1.ch2,"1",strdup(tempFor));quad("=",strdup(tempFor),"",$1.ch2);quad("BR",$1.ch1,"","");q[atoi($1)].op1=$2;}
;
// $$.ch1 pour transporter la valeur de l'indice de quadreplet
// $$.ch2 pour transporter l'idf
FOR_DEB: left_ar k_for FOR_INIT  UNTIL right_ar {$$.ch1=$3.ch1;$$.ch2=$3.ch2;}
;
//initialiter le compteur par la valeur donnee 
// $$.ch1 pour transporter la valeur de l'indice de quadreplet
// $$.ch2 pour transporter l'idf
FOR_INIT: idf eq v_integer{quad("=",IntToChar($3),"",$1);$$.ch1=IntToChar(indq);$$.ch2=$1;strcpy(saveIdfFor,$1);ExistDeclarationP($1,lignes);}
;
//generer le quadreplet de BE sans adresse , sauvgarder l'indice de quadreplet dans UNTIL
UNTIL:k_until v_integer {quad("BE","",strdup(saveIdfFor),IntToChar($2));$$=IntToChar(indq);}
     |k_until idf {quad("BE","",strdup(saveIdfFor),$2);$$=IntToChar(indq);ExistDeclarationP($2,lignes)}
;
//sauvgarder l'adresse de la fin de chaque boucle (+3 pour les 3 quads de traitement incrementation et affectation)
BLOCK_FOR: BLOCK_INST_FOR {$$=IntToChar(indq+3);}
;

BLOCK_INST_FOR:INSTRUCTION BLOCK_INST_FOR
              |CLOSE_FOR
              ;

CLOSE_FOR:left_ar fw_slash k_for right_ar
;

EXPRESSION_LOGIQUE:VALUE_BOOL {$$.res=BoolToString($1);}
                  |AND {$$.res=$1}
                  |OR {$$.res=$1}
                  |NOT {$$.res=$1}
                  |SUP {$$.res=$1}
                  |INF {$$.res=$1}
                  |SUPE{$$.res=$1}
                  |INFE{$$.res=$1}
                  |EGA{$$.res=$1}
                  |DIF{$$.res=$1}
                  ;



AND_ARG:EXPRESSION_LOGIQUE comma AND_ARG  
{
  if(strcmp($1.res, "FALSE")==0) $$.res="FALSE";
  else $$.res=$3.res;
}

           |EXPRESSION_LOGIQUE comma EXPRESSION_LOGIQUE {
             if(strcmp($1.res, "FALSE")==0) $$.res="FALSE";
             else if(strcmp($1.res, "TRUE")==0) $$.res= $3.res;
             else {
               if(strcmp($3.res, "TRUE")==0) $$.res=$1.res;
               else if(strcmp($3.res, "FALSE")==0) $$.res = "FALSE";
               else {$$.res=temporaire(); quad("AND", $1.res, $3.res, $$.res);} 
             }
             }
           |IDF comma IDF {$$.res=temporaire(); quad("AND", $1, $3, $$.res);}
           |IDF comma AND_ARG {
             if(strcmp($3.res, "FALSE")==0) $$.res="FALSE";
             else if(strcmp($3.res, "TRUE")==0) $$.res = $1;
             else {$$.res=temporaire();quad("AND", $1, $3.res, $$.res);}
            }
           | IDF comma EXPRESSION_LOGIQUE {
            if(strcmp($3.res, "FALSE")==0) $$.res="FALSE";
            else if(strcmp($3.res, "TRUE")==0) $$.res=$1;
            else {$$.res=temporaire();quad("AND", $1, $3.res, $$.res);}
          }
          | EXPRESSION_LOGIQUE  comma IDF {
            if(strcmp($1.res, "FALSE")==0) $$.res="FALSE";
            else if(strcmp($1.res, "TRUE")==0) $$.res=$3;
            else {$$.res=temporaire();quad("AND", $1.res, $3, $$.res);}
          }
           ;
OR_ARG:EXPRESSION_LOGIQUE comma AND_ARG {if(strcmp($1.res, "TRUE")==0) $$.res="TRUE";else $$.res=$3.res;}
           |EXPRESSION_LOGIQUE comma EXPRESSION_LOGIQUE {
             if(strcmp($1.res, "TRUE")==0) $$.res="TRUE";
             else if(strcmp($1.res, "FALSE")==0) $$.res= $3.res;
             else {
               if(strcmp($3.res, "FALSE")==0) $$.res=$1.res;
               else if(strcmp($3.res, "TRUE")==0) $$.res = "TRUE";
               else {$$.res=temporaire(); quad("OR", $1.res, $3.res, $$.res);} 
             }
             }
           |IDF comma IDF {$$.res=temporaire(); quad("OR", $1, $3, $$.res);}
           |IDF comma AND_ARG {
             if(strcmp($3.res, "TRUE")==0) $$.res="TRUE";
             else if(strcmp($3.res, "FALSE")==0) $$.res = $1;
             else {$$.res=temporaire();quad("OR", $1, $3.res, $$.res);}
            }
           | IDF comma EXPRESSION_LOGIQUE {
            if(strcmp($3.res, "TRUE")==0) $$.res="TRUE";
            else if(strcmp($3.res, "FALSE")==0) $$.res=$1;
            else {$$.res=temporaire();quad("OR", $1, $3.res, $$.res);}
          }
          | EXPRESSION_LOGIQUE  comma IDF {
            if(strcmp($1.res, "TRUE")==0) $$.res="TRUE";
            else if(strcmp($1.res, "FALSE")==0) $$.res=$3;
            else {$$.res=temporaire();quad("OR", $1.res, $3, $$.res);}
          }
           ;


AND:and left_par AND_ARG right_par {$$=$3.res}
;
OR:or left_par OR_ARG right_par {$$=$3.res}
;
NOT:not left_par EXPRESSION_LOGIQUE right_par {
  if(strcmp($3.res, "FALSE")==0) $$="TRUE";
  else if (strcmp($3.res, "TRUE")==0) $$ ="FALSE";
  else {$$=temporaire(); quad("NOT", $3.res,"" , $$);}
  }
   |not left_par IDF right_par {$$=temporaire(); quad("NOT", $3,"" , $$);}
;


EXPRESSION_ARITHMETIQUE:EXPRESSION_ARITHMETIQUE plus EXPRESSION_ARITHMETIQUE {$$.res=temporaire();quad ("+",$1.res,$3.res,$$.res);}
                        |EXPRESSION_ARITHMETIQUE dash EXPRESSION_ARITHMETIQUE {$$.res=temporaire();quad ("-",$1.res,$3.res,$$.res);}
                        |EXPRESSION_ARITHMETIQUE asterisk EXPRESSION_ARITHMETIQUE {$$.res=temporaire();quad ("*",$1.res,$3.res,$$.res);}
                        |EXPRESSION_ARITHMETIQUE fw_slash EXPRESSION_ARITHMETIQUE {$$.res=temporaire();quad ("/",$1.res,$3.res,$$.res);}
                        |left_par EXPRESSION_ARITHMETIQUE right_par {$$=$2;}
                        |IDF plus EXPRESSION_ARITHMETIQUE {isNumeric($1,lignes);$$.res=temporaire();quad ("+",$1,$3.res,$$.res);}
                        |IDF dash EXPRESSION_ARITHMETIQUE {isNumeric($1,lignes);$$.res=temporaire();quad ("-",$1,$3.res,$$.res);}
                        |IDF asterisk EXPRESSION_ARITHMETIQUE {isNumeric($1,lignes);$$.res=temporaire();quad ("*",$1,$3.res,$$.res);}
                        |IDF fw_slash EXPRESSION_ARITHMETIQUE {isNumeric($1,lignes);$$.res=temporaire();quad ("/",$1,$3.res,$$.res);divisionZero($3.res,lignes);}
                        |EXPRESSION_ARITHMETIQUE plus IDF {isNumeric($3,lignes);$$.res=temporaire();quad ("+",$1.res,$3,$$.res);}
                        |EXPRESSION_ARITHMETIQUE dash IDF {isNumeric($3,lignes);$$.res=temporaire();quad ("-",$1.res,$3,$$.res);}
                        |EXPRESSION_ARITHMETIQUE asterisk IDF {isNumeric($3,lignes);$$.res=temporaire();quad ("*",$1.res,$3,$$.res);}
                        |EXPRESSION_ARITHMETIQUE fw_slash IDF {isNumeric($3,lignes);$$.res=temporaire();quad ("/",$1.res,$3,$$.res);}
                        |v_integer {testRangInt($1,lignes,saveIdf);$$.res=IntToChar($1);}
                        |v_real {testRangFlt($1,lignes,saveIdf);$$.res=FltToChar($1);}
                        ;

IDF:idf {strcpy(saveIdf,$1);$$=$1;ExistDeclarationP($1,lignes);}
    |IDF_TAB
    ;
IDF_TAB:idf left_bracket TAB_ARG right_bracket {$$=tabName($1, $3);strcpy(saveIdf,$1);ExistDeclarationP($1,lignes);outOfRange($1,atoi($3),lignes);};
TAB_ARG:IDF {$$=$1}
       |v_integer {$$=IntToChar($1);}
       ;

AFF:left_ar k_aff col IDF comma AFF_ARG {constanteDeja($4,lignes);quad ("=",$4,"",$6.res);}
| left_ar k_aff col IDF comma IDF fw_slash right_ar {compatible($4, $6 , lignes);
  constanteDeja($4,lignes);
  quad ("=",$6,"",$4);
  }
;
AFF_ARG:EXPRESSION_ARITHMETIQUE fw_slash right_ar {isNumeric(saveIdf,lignes);$$.res=$1.res;}
       |EXPRESSION_LOGIQUE fw_slash right_ar {idfHasType(saveIdf, BOOL , lignes);$$.res=$1.res;}
       |v_string fw_slash right_ar {idfHasType(saveIdf, STRING , lignes);$$.res=transfertString($1);}
       |v_char fw_slash right_ar {idfHasType(saveIdf, CHAR, lignes);$$.res=CharToString($1);}
       ;

SUP: sup left_par {strcpy(saveOp, "SUP");} COMP_ARG right_par {$$=$4}
;

INF: inf left_par {strcpy(saveOp, "INF");} COMP_ARG right_par {$$=$4}
;
SUPE:supe left_par {strcpy(saveOp, "SUPE");} COMP_ARG right_par{$$=$4}
;
INFE:infe left_par {strcpy(saveOp, "INFE");} COMP_ARG right_par{$$=$4}
;
EGA:ega left_par {strcpy(saveOp, "EGA");} COMP_ARG right_par{$$=$4}
;
DIF:dif left_par {strcpy(saveOp, "DIF");} COMP_ARG right_par{$$=$4}
;

COMP_ARG:EXPRESSION_ARITHMETIQUE comma EXPRESSION_ARITHMETIQUE {$$=temporaire(); quad(strdup(saveOp), $1.res, $3.res, $$);}
        |IDF comma EXPRESSION_ARITHMETIQUE {$$=temporaire(); quad(strdup(saveOp), $1, $3.res, $$);}
        |IDF comma IDF {$$=temporaire(); quad(strdup(saveOp), $1, $3, $$);}
        |EXPRESSION_ARITHMETIQUE comma IDF {$$=temporaire(); quad(strdup(saveOp), $1.res, $3, $$);}
        ;





%%


int yywrap();

int main() {
   initialiter();
   initialiser();
   initialiterListeIdf();
   initialiterListeCnst();
   initialiterListeQuad();
   yyparse();
   affiche();
   optimiser();  
   generateCode();
}

int yyerror(char * message) {
  printf("code:%d: %s\n", lignes, message);
  return 0;

}