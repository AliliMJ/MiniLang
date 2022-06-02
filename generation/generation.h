#ifndef GEN_H
#define GEN_H
#include "../quad/quad.h"

typedef struct listeIdfGen
{
    char chaine[20];
} listeIdfGen;

listeIdfGen TG[40];

void generateCode();
void formatInst(int indent);
void tranlate(quadruplet quad);
void aff(char* op, char* res); 
void jmp(quadruplet quad);
void minus(quadruplet quad);
void add(quadruplet quad);
void divide(quadruplet quad);
void mult(quadruplet quad);
void land(quadruplet quad);
void lor(quadruplet quad);
void logical(quadruplet quad);
void lsup(quadruplet quad);
void lsupe(quadruplet quad);
void linf(quadruplet quad);
void linfe(quadruplet quad);
void lega(quadruplet quad);
void ldif(quadruplet quad);

int rechercherTG(char *entity);
void insererTG(char *entity);

#endif 
