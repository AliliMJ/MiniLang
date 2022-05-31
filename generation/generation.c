
#include <stdio.h>
#include <stdlib.h>
#include "generation.h"
#include "../tabsym/tabsym.h"
#include <math.h>
int * br, nbrBranches;

extern int indq;
FILE *f;

void dataSegment() {

  fprintf(f,"DATA segment stack\n");

  int i;

  for(i=0;i<indq;i++){
    if (q[i].opr != NULL)
    {
      if (RechercherPtr(q[i].op1) != NULL)
      {
        ptr p = RechercherPtr(q[i].op1);
        if(p->tablenght!=-1){
          fprintf(f,"%s dw %d dup (?)\n",p->entity_name,p->tablenght);
        }else if(strcmp(p->constante,"non")==0){
          fprintf(f, "%s dw\n", p->entity_name);
        }
        else if ((strcmp(p->constante, "non") != 0) && (strcmp(p->constante, "null") != 0) && (strcmp(p->constante, "oui") != 0)){
          fprintf(f, "%s dw %s\n", p->entity_name,p->constante);
        }
      }

      if (RechercherPtr(q[i].op2) != NULL)
      {
        ptr p = RechercherPtr(q[i].op2);
        if (p->tablenght != -1)
        {
          fprintf(f, "%s dw %d dup (?)\n", p->entity_name, p->tablenght);
        }
        else if(strcmp(p->constante, "non")==0)
        {
          fprintf(f, "%s dw\n", p->entity_name);
        }
        else if ((strcmp(p->constante, "non") != 0) && (strcmp(p->constante, "null") != 0) && (strcmp(p->constante, "oui") != 0))
        {
          fprintf(f, "%s dw %s\n", p->entity_name, p->constante);
        }
      }

    }

    
    
  }

  fprintf(f, "DATA ends\n");
}

// void codeSegment() {

// }
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
void generateCode() {

  f = fopen("./generation/generation.txt", "w");
  if(f == NULL)
  {
      printf("Error!");   
      exit(1);             
  }

  printf("text added !\n");
  dataSegment();
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
      fprintf(f, "INST");
    
  }
  fprintf(f, "\n");

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
    fprintf(f, "MOV AX %s\n", quad.op1); formatInst(4);
    
  }
  else {
    fprintf(f, "B");
  }
  
}
void minus(quadruplet quad) {
  fprintf(f, "MINUS");
}
void add(quadruplet quad) {
  fprintf(f, "ADD");
}
void divide(quadruplet quad) {
  fprintf(f, "DIV");
}
void mult(quadruplet quad) {
  fprintf(f, "MULT");
}
