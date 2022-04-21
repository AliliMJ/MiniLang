%{

  #include <stdio.h>
  #include <string.h>
  #include <stdlib.h>
  #include "../tabsym/tabsym.h"

  int nb_ligne = 1;
  char saveType[25];
  char saveIdf[30];
  int aff = 0;
  char* chaineOut;
  int posChaine = 0;
  char saveIdfOut[30];
  char saveIdfIn[30];
  char savesigne[30];
  char op[20];
  int valeurZeroE;
  float valeurZeroR;
  char IO[10];
  int existeChaine = 0;
  int isLoop = -1;
%}

%union{
  int entier;
  char* str;
  float reel;
}

%token mc_import bib_io bib_lang err
%token mc_public mc_private mc_protected mc_class mc_main
%token <str>idf <str>idf_tab signe
%token mc_out mc_inp mc_for
%token pvg vrg acr_ov acr_fer br_ov br_fer cr_ov cr_fer
%token <str>v_chaine <entier>v_entier <reel>v_reel
%token op_div op_mult op_plus op_moins op_egale
%token <str>mc_entier <str>mc_reel <str>mc_chaine mc_const
%token log_inf log_sup log_equal log_no_equal log_inf_equal log_sup_equal
%start S
%%
S:Liste_bib header_class acr_ov Corps acr_fer {printf("pgm syntaxiquement correcte");
      YYACCEPT;}
;
Liste_bib:Bib Liste_bib
          |
          ;
Bib:mc_import Nom_bib pvg
;
Nom_bib:bib_io
        |bib_lang
        ;
header_class:Modificateur mc_class idf
;
Modificateur:mc_public
            |mc_private
            |mc_protected
            ;
Corps:Liste_dec Main
;
Liste_dec:Dec Liste_dec
          |
          ;
Dec:Dec_var
    |Dec_tab
    |Dec_const
    ;
Dec_var:Type Liste_idf pvg
;
Liste_idf:Idf_controller vrg Liste_idf
         |Idf_controller
         ;
Idf_controller:idf {if(ExistDeclaration($1)==0)
                        InsererType($1,saveType);
                     else
                        printf("erreur semantique: \"%s\" double declaration a la ligne %d\n",$1,nb_ligne);
                     }
                    ;
Dec_tab:Type Liste_idf_tab pvg
;
Liste_idf_tab:Idf_tab_controller vrg Liste_idf_tab
             |Idf_tab_controller
             ;
Idf_tab_controller:idf_tab cr_ov v_entier cr_fer {InsererTailleTab($1,$3);
                                                  if(ExistDeclaration($1)==0)
                                                     InsererType($1,saveType);
                                                  else
                                                     printf("erreur semantique: \"%s\" double declaration a la ligne %d\n",$1,nb_ligne);

                                                  if($3<0)
                                                     printf("erreur semantique: \"%s\" la taille de cette table doit etre positive a la ligne %d\n",$1,nb_ligne);
                                                 }
;
Dec_const:mc_const Dec_const_diff pvg
;
Dec_const_diff:idf op_egale Type_val {InsererC($1,"oui");}
             |idf {InsererC($1,"null");}
             ;
Main:mc_main br_ov br_fer acr_ov Inst acr_fer
;
Inst:Liste Inst
    |
    ;
Liste:Ecriture {posChaine=0;if(RechercherBib("ISIL.io")==-1) printf("erreur semantique: erreur dans la Bib ISIL.io a la ligne %d\n",nb_ligne);}
      |Lecture {if(RechercherBib("ISIL.io")==-1) printf("erreur semantique: erreur dans la Bib ISIL.io a la ligne %d\n",nb_ligne);}
      |Affectation {if(RechercherBib("ISIL.lang")==-1) printf("erreur semantique: erreur dans la Bib ISIL.lang a la ligne %d\n",nb_ligne);}
      |For_bloc {if(RechercherBib("ISIL.lang")==-1) printf("erreur semantique: erreur dans la Bib ISIL.lang a la ligne %d\n",nb_ligne);}
      ;
Affectation:Idf_simple_tab_intia op_egale {existeChaine=0;} Intialisation pvg {if(DejaAffConst(saveIdf)==0) printf("erreur semantique: c\'est un const vous ne pouvez pas de renitialiser a la ligne %d\n",nb_ligne);
                                                                            if(existeChaine==0 && isChaine(saveIdf)==1)
                                                                                printf("erreur semantique: affecation une chaine incorrect verifier a la ligne %d\n",nb_ligne);
                                                                            }
;
Intialisation:Oprd Type_op Intialisation
              |Oprd
              ;
Idf_simple_tab_intia:idf {aff = 1;
                          strcpy(saveIdf,$1);
                          if(ExistDeclaration($1)==0 && isLoop==-1)
                            printf("erreur semantique: \"%s\" n\'est pas declarer a la ligne %d\n",$1,nb_ligne);
                          }
                    |idf_tab cr_ov v_entier cr_fer {aff = 1;
                                                    strcpy(saveIdf,$1);
                                                    if(LimiteTab($1,$3)==0)
                                                       printf("erreur semantique: \"%s\" l\'index est depasser la limite de cette tableau a la ligne %d\n",$1,nb_ligne);
                                                    if(ExistDeclaration($1)==0)
                                                       printf("erreur semantique: \"%s\" n\'est pas declarer a la ligne %d\n",$1,nb_ligne);
                                                    if($3<0)
                                                       printf("erreur semantique: \"%s\" l\'index de cette table doit etre positive a la ligne %d\n",$1,nb_ligne);
                                                    }
                    ;
Oprd:Type_val {if(strcmp(op,"div")==0 && (valeurZeroR==0||valeurZeroE==0))
                  printf("erreur semantique: division par zero a la ligne %d\n",nb_ligne);
               }
    |Idf_simple_tab {valeurZeroR = -1; valeurZeroE = -1;}
    ;
Ecriture:mc_out br_ov v_chaine {strcpy(IO,"out");chaineOut=malloc(strlen($3));strcpy(chaineOut,$3);}Liste_var_idf br_fer pvg
;
Liste_var_idf:vrg Idf_simple_tab {posChaine = OutVerfication(chaineOut,saveIdfOut,posChaine,IO);
                                  if(posChaine == -2)
                                    printf("erreur semantique: les signaux %s ou %s ou %s n'est pas compatible a leurs IDF dans la chaine sortie a la ligne %d\n","%s","%d","%f",nb_ligne);
                                 }
              Liste_var_idf
              |
              ;
Lecture:mc_inp br_ov signe vrg idf br_fer pvg {strcpy(IO,"in");strcpy(savesigne,$3); strcpy(saveIdf,$5);
												 if(cmpcomp(savesigne,saveIdf)==-1){
													 printf("erreur semantique: il y a pas de compatiblete entre idf %s et signe %s a la ligne %d\n",saveIdf,savesigne,nb_ligne);
											 }
									 }

;
For_bloc:mc_for {isLoop = 1;} br_ov para_for br_fer acr_ov Inst acr_fer {isLoop = -1;}
;
para_for:Affectation Condition Increment {InsererIdfLoop(saveIdf);}
;
Condition:idf Comp_type v_entier pvg
;
Increment:idf Type_op Type_op
;
Type:mc_entier {strcpy(saveType,$1);}
     |mc_reel {strcpy(saveType,$1);}
     |mc_chaine {strcpy(saveType,$1);}
     ;
Type_val:v_reel {valeurZeroR = $1; valeurZeroE = -1;
                 if(isCompatibleType(saveIdf,aff,"Reel") == -1)
                   printf(" a la ligne %d\n",nb_ligne);
                 }
       |v_chaine {valeurZeroR = -1; valeurZeroE = -1; existeChaine=1;
                  if(isCompatibleType(saveIdf,aff,"Chaine") == -1)
                    printf(" a la ligne %d\n",nb_ligne);
                  }
       |v_entier {valeurZeroR = -1; valeurZeroE = $1;
                  if(isCompatibleType(saveIdf,aff,"Entier") == -1)
                    printf(" a la ligne %d\n",nb_ligne);
                  }
       ;
Type_op:op_plus {strcpy(op,"plus");}
       |op_moins {strcpy(op,"moins");}
       |op_mult {strcpy(op,"mult");}
       |op_div {strcpy(op,"div");}
       ;
Comp_type:log_inf
         |log_sup
         |log_equal
         |log_no_equal
         |log_inf_equal
         |log_sup_equal
         ;
Idf_simple_tab:idf {strcpy(saveIdfOut,$1);
                   if(ExistDeclaration($1)==0)
                       printf("erreur semantique: \"%s\" n\'est pas declarer a la ligne %d\n",$1,nb_ligne);
                   if(isCompatibleTypeIdf(saveIdf,aff,$1) == -1)
                      printf(" a la ligne %d\n",nb_ligne);
                   }
             |idf_tab cr_ov v_entier cr_fer {strcpy(saveIdfOut,$1);
                                             if(LimiteTab($1,$3)==0)
                                                printf("erreur semantique: \"%s\" l\'index est depasser la limite de cette tableau a la ligne %d\n",$1,nb_ligne);
                                             if(ExistDeclaration($1)==0)
                                                printf("erreur semantique: \"%s\" n\'est pas declarer a la ligne %d\n",$1,nb_ligne);
                                             if($3<0)
                                                printf("erreur semantique: \"%s\" l\'index de cette table doit etre positive a la ligne %d\n",$1,nb_ligne);
                                             if(isCompatibleTypeIdf(saveIdf,aff,$1) == -1)
                                                printf(" a la ligne %d\n",nb_ligne);
                                            }
             ;
%%
main()
{yyparse();
 Afficher();
 Afficherbib();
}
yywrap() {}

yyerror(char *msg){
  printf("erreur syntaxique a la ligne %d dans le projet isil2020\n",nb_ligne);
}
