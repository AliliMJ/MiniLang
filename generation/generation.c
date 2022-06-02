
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "generation.h"
#include "../tabsym/tabsym.h"
#include <math.h>
int * br, nbrBranches;

extern int indq;
FILE *f;

int nb=0;

int rechercherTG(char *entity){
  int i;

  for (i = 0; i < nb; i++)
  {
    if(strcmp(TG[i].chaine,entity)==0) return 1;
  }

return 0;
}

void insererTG(char *entity)
{
  if(rechercherTG(entity)==0){
   strcpy(TG[nb].chaine,entity);
   nb++;
  }
}

void branches() {
  int b[indq], i, j=0, n;
  for(i=0;i<indq;i++) {
    if(q[i].opr!=NULL && q[i].opr[0]=='B') {
      n = atoi(q[i].op1);
      b[n]=1;
      nbrBranches++;
    }
    else b[i] =0;
  }
  br = malloc(nbrBranches*sizeof(int));
  j=0;
  for(i=0;i<indq;i++) {
    if(b[i]==1) {
      br[j] = i;
      j++;
    }
  }

}

void dataSegment() {

  fprintf(f,"DATA segment stack\n");

  int i;

  for(i=0;i<indq;i++){
    if (q[i].opr != NULL)
    {
      if (RechercherPtr(q[i].op1) != NULL)
      {
        ptr p = RechercherPtr(q[i].op1);
        if(rechercherTG(p->entity_name)==0){
          formatInst(4);
          if (p->tablenght != -1)
          {

            fprintf(f, "%s dw %d dup (?)\n", p->entity_name, p->tablenght);
            insererTG(p->entity_name);
          
        }else if(strcmp(p->constante,"non")==0){
          fprintf(f, "%s dw\n", p->entity_name);
          insererTG(p->entity_name);
        }
        else if ((strcmp(p->constante, "non") != 0) && (strcmp(p->constante, "null") != 0) && (strcmp(p->constante, "oui") != 0)){
          fprintf(f, "%s dw %s\n", p->entity_name,p->constante);
          insererTG(p->entity_name);
        }
      }
      }

      if (RechercherPtr(q[i].op2) != NULL)
      {
        
        ptr p = RechercherPtr(q[i].op2);
        if(rechercherTG(p->entity_name)==0){
          formatInst(4);
          if (p->tablenght != -1)
          {
            fprintf(f, "%s dw %d dup (?)\n", p->entity_name, p->tablenght);
            insererTG(p->entity_name);
        }
        else if(strcmp(p->constante, "non")==0)
        {
          fprintf(f, "%s dw\n", p->entity_name);
          insererTG(p->entity_name);
        }
        else if ((strcmp(p->constante, "non") != 0) && (strcmp(p->constante, "null") != 0) && (strcmp(p->constante, "oui") != 0))
        {
          fprintf(f, "%s dw %s\n", p->entity_name, p->constante);
          insererTG(p->entity_name);
        }
      }
      }
    }

    
    
  }
printf("\n\n");
for(i=0;i<nb;i++){
  printf("  %s  ",TG[i].chaine);
}
printf("\n\n");
fprintf(f, "DATA ends\n");
}


void codeSegment() {
  fprintf(f, "CODE segment\nMAIN:\n");formatInst(4);
  fprintf(f, "ASSUME CS:CODE DS:DATA\n");

  branches();
  int i;
  printf(" %d ", br[0]);
  int lastBranchIndex=0;
  for(i=0;i< indq;i++) {

    if(i==br[lastBranchIndex]) {
      fprintf(f, "ETIQ%d:\n", i);
      lastBranchIndex++;
    }
    
    tranlate(q[i]);
  }
  fprintf(f, "MAIN ENDS\n");formatInst(4);
  fprintf(f, "END MAIN\n");
}

void generateCode() {

  f = fopen("./generation/generation.txt", "w");
  if(f == NULL)
  {
      printf("Error!");   
      exit(1);             
  }

  printf("text added !\n");
  dataSegment();
  codeSegment();
  fclose(f);

}

void formatInst(int indent) {
  int i;
  for(i=0;i<indent;i++) fprintf(f, "\t");
}
void tranlate(quadruplet quad) {
  if(quad.opr == NULL) return;
  
  formatInst(4);
  switch(quad.opr[0]) {
    case '=':
      aff(quad.op1, quad.res);

      break;
    case '+':
      add(quad);
      break;
    case('*'):
      mult(quad);
      break;
    case('-'):
      minus(quad);
      break;
    case('/'):
      divide(quad);
      break;
    case 'B':
      jmp(quad);
      break;
    default:
      logical(quad);
    
  }
  fprintf(f, "\n");

} 

void logical(quadruplet quad) {
  if(strcmp(quad.opr, "AND")==0) { land(quad);

  }else if(strcmp(quad.opr, "OR")==0) { lor(quad);

  }else if(strcmp(quad.opr, "SUP")==0) { lsup(quad);

  }else if(strcmp(quad.opr, "SUPE")==0) { lsupe(quad);

  }else if(strcmp(quad.opr, "INF")==0) { linf(quad);

  }else if (strcmp(quad.opr, "INFE")==0) {linfe(quad);

  }else if (strcmp(quad.opr, "EGA")==0) { lega(quad);

  }else if (strcmp(quad.opr, "DIF")==0) { ldif(quad);

  }
}
void lsup(quadruplet quad) {
  fprintf(f, "CALL SUP %s %s\n", quad.op1, quad.op2);formatInst(4);
  fprintf(f, "MOV %s", quad.res);
}
void lsupe(quadruplet quad) {
  fprintf(f, "CALL SUPE %s %s\n", quad.op1, quad.op2);formatInst(4);
  fprintf(f, "MOV %s", quad.res);
}
void linf(quadruplet quad) {
  fprintf(f, "CALL INF %s %s\n", quad.op1, quad.op2);formatInst(4);
  fprintf(f, "MOV %s", quad.res);
}
void linfe(quadruplet quad) {
  fprintf(f, "CALL INFE %s %s\n", quad.op1, quad.op2);formatInst(4);
  fprintf(f, "MOV %s", quad.res);
}
void lega(quadruplet quad) {
  fprintf(f, "CALL EGA %s %s\n", quad.op1, quad.op2);formatInst(4);
  fprintf(f, "MOV %s", quad.res);
}
void ldif(quadruplet quad) {
  fprintf(f, "CALL DIF %s %s\n", quad.op1, quad.op2);formatInst(4);
  fprintf(f, "MOV %s", quad.res);
}
void land(quadruplet quad) {
  fprintf(f, "AND %s %s\n", quad.op1, quad.op2);formatInst(4);
  fprintf(f, "MOV %s AX", quad.res);

}
void lor(quadruplet quad) {
  fprintf(f, "OR %s %s\n", quad.op1, quad.op2);formatInst(4);
  fprintf(f, "MOV %s AX", quad.res);
}

void aff(char* op, char* res) {
  if (isdigit(op[0])==0) {
    fprintf(f, "MOV AX %s\n", op);
    formatInst(4);
    fprintf(f, "MOV %s AX", res);
  }
  else
    fprintf(f, "MOV %s %s", res, op);
}
void jmp(quadruplet quad) {
  char *typeB = quad.opr, *branch=quad.op1;
  if(strcmp(typeB, "BR")==0) {
    fprintf(f, "JMP ETIQ%s", branch);
  }else if (strcmp(typeB, "BZ")==0) {
    fprintf(f, "JZ %s", quad.op1);
  }else if (strcmp(typeB, "BNZ")==0){
    fprintf(f, "JNZ %s", quad.op1);
  }
  else if(strcmp(typeB, "BE")==0) {
    //fprintf(f, "MOV AX %s\n", quad.op2); formatInst(4);
    fprintf(f, "CMP %s %s\n", quad.res, quad.op2);formatInst(4);
    fprintf(f, "JE %s", quad.op1);
    
  }else if(strcmp(typeB, "BNE")==0) {
    //fprintf(f, "MOV AX %s\n", quad.op2); formatInst(4);
    fprintf(f, "CMP %s %s\n", quad.res, quad.op2);formatInst(4);
    fprintf(f, "JNE %s", quad.op1);
    
  }
  else {
    fprintf(f, "B");
  }
  
}
void minus(quadruplet quad) {
  fprintf(f, "MOV AX %s\n", quad.op1);formatInst(4);
  fprintf(f, "SUB %s\n", quad.op2);formatInst(4);
  fprintf(f, "MOV %s AX", quad.res);
}
void add(quadruplet quad) {
  fprintf(f, "MOV AX %s\n", quad.op1);formatInst(4);
  fprintf(f, "ADD AX %s\n", quad.op2);formatInst(4);
  fprintf(f, "MOV %s AX", quad.res);
  
}
void divide(quadruplet quad) {
  fprintf(f, "MOV AX %s\n", quad.op1);formatInst(4);
  fprintf(f, "DIV %s\n", quad.op2);formatInst(4);
  fprintf(f, "MOV %s AX", quad.res);
}
void mult(quadruplet quad) {
  fprintf(f, "MOV AX %s\n", quad.op1);formatInst(4);
  fprintf(f, "IMULT %s\n", quad.op2);formatInst(4);
  fprintf(f, "MOV %s AX", quad.res);
}
