%{
  #include "synt.tab.h"
  #include "table_symbole.h"
  extern nb_ligne;
  extern YYSTYPE yylval;
%}
lettres [a-zA-Z]
chifres [0-9]
name {lettres}({lettres}|{chifres}|_({lettres}|{chifres})+)*
idf "$"{name}
idf_tab "@"{name}
val_entier (0|[-]?[1-9]{chifres}*)
val_reel ([-]?{chifres}+[.]{chifres}*[1-9])
val_chaine ["][^"]*["]
signe ["](%d|%f|%s)["]
comment "##"[^#]*"##"
%%
import return mc_import;
ISIL.io {Insererbib(yytext);yylval.str = strdup("ISIL.io"); return bib_io;}
ISIL.lang {Insererbib(yytext);yylval.str = strdup("ISIL.lang"); return bib_lang;}
public return mc_public;
private return mc_private;
protected return mc_protected;
class return mc_class;
main return mc_main;
CONST return mc_const;
entier {yylval.str = strdup("Entier"); return mc_entier;}
reel {yylval.str = strdup("Reel"); return mc_reel;}
chaine {yylval.str = strdup("Chaine"); return mc_chaine;}
For return mc_for;
Out return mc_out;
In return mc_inp;
{signe} {yylval.str=strdup(yytext); return signe;}
{idf_tab} {if(yyleng<=25){
              Inserer(yytext,"idf tableau");
              yylval.str = strdup(yytext);
              return idf_tab;
          }
          else printf("erreur lexicale a la ligne %d: l'idf %s trop long\n",nb_ligne,yytext);}
{idf} {if(yyleng<=25){
          Inserer(yytext,"idf");
          yylval.str = strdup(yytext);
          return idf;
       }
       else printf("erreur lexicale a la ligne %d: l'idf %s trop long\n",nb_ligne,yytext);
       }
{val_entier} {yylval.entier=atoi(yytext);
              return v_entier;}
{val_reel} {yylval.reel=atof(yytext);
            return v_reel;}
{val_chaine} {yylval.str=strdup(yytext);
            return v_chaine;}
{comment}
"{" return acr_ov;
"}" return acr_fer;
"(" return br_ov;
")" return br_fer;
"[" return cr_ov;
"]" return cr_fer;
";" return pvg;
"," return vrg;
":=" return op_egale;
"+" return op_plus;
"-" return op_moins;
"*" return op_mult;
"/" return op_div;
"=" return log_equal;
"<" return log_inf;
">" return log_sup;
"<=" return log_inf_equal;
">=" return log_sup_equal;
"!=" return log_no_equal;
[ \t]
[\n] nb_ligne++;
. printf("erreur lexicale a ligne %d sur l'entite %s\n",nb_ligne,yytext); return err;
