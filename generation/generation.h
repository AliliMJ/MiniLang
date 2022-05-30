#ifndef GEN_H
#define GEN_H
#include "../quad/quad.h"

void generateCode();
void tranlate(quadruplet quad);
void aff(char* op, char* res); 
void jmp(quadruplet quad);
void minus(quadruplet quad);
void add(quadruplet quad);
void div(quadruplet quad);
void mult(quadruplet quad);



#endif 
