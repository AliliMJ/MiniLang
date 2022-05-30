
#include <stdio.h>
#include <stdlib.h>
#include "generation.h"
#include <math.h>
int * br, nbrBranches;

extern int indq;
FILE *f;

// void dataSegment() {

// }

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
  branches();
  int i;
  printf(" %d ", br[0]);
  int lastBranchIndex=0;
  for(i=0;i< indq;i++) {
    if(i==br[lastBranchIndex]) {
      fprintf(f, "Etiq%d :", i);
      lastBranchIndex++;
    }
    tranlate(q[i]);
  }

  fclose(f);

}

void tranlate(quadruplet quad) {
  if(quad.opr == NULL) return;
 
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
      div(quad);
      break;
    case 'B':
      jmp(quad);
      break;
    default:

    
  }

} 

void aff(char* op, char* res) {
  if (isdigit(op[0])==0) {
    fprintf(f, "MOV AX %s\n", op);
    fprintf(f, "MOV %s AX\n", res);
  }
  else
    fprintf(f, "MOV %s %s\n", res, op);
}
void jmp(quadruplet quad) {
  
}
void minus(quadruplet quad) {
  
}
void add(quadruplet quad) {
  
}
void div(quadruplet quad) {
  
}
void mult(quadruplet quad) {
  
}
