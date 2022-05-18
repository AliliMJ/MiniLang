

#ifndef QUAD_H
#define QUAD_H

// t la taille de la table contenant les quadruplets
#define t 100
#define imb 5

// la structure d'un element de la table
typedef struct
{
    char *opr;
    char *op1;
    char *op2;
    char *res;
} quadruplet;
// declaration de la table
quadruplet* q;






// signature des fonctions de quad.c
void initialiterListeQuad();
void quad(char *, char *, char *, char *);
void removeQuad(int);
void afficherQuad();
char* temporaire();
char *allouertemp();
char *BoolToString(int b); 

void remplacer(char* temp1, char* temp2, int index);
void propCopie();
int notUsed(char*temp, int index);
void eliminer();
void corrigerBranch();
int isNumber(char s[]);
void remplacer1();

#endif // QUAD_H
