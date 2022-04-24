#ifndef QUAD_H
#define QUAD_H

// t la taille de la table contenant les quadruplets
#define t 100
int indq = 0;
// la structure d'un element de la table
typedef struct
{
    char *opr;
    char *op1;
    char *op2;
    char *res;
} quadruplet;
// declaration de la table
quadruplet q[t];

// signature des fonctions de quad.c
void quad(char *, char *, char *, char *);
void afficherQuad();

#endif // QUAD_H
