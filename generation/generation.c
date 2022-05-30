
#include <stdio.h>
#include <stdlib.h>
#include "generation.h"


extern int indq;
FILE *f;

// void dataSegment() {

// }

// void codeSegment() {

// }

void generateCode() {

  f = fopen("./generation/generation.txt", "w");
  if(f == NULL)
  {
      printf("Error!");   
      exit(1);             
  }

  printf("text added !\n");
  int i;
  //for(i=0;i< indq;i++) tranlate(quad[i]);
  tranlate(q[8]);
  fclose(f);

}

void tranlate(quadruplet quad) {
  if (strcmp(quad.opr, "=")==0) aff(quad.op1, quad.res);

} 

void aff(char* op, char* res) {
  fprintf(f, "MOV %s %s", res, op);
}
