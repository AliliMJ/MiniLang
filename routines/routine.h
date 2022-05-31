#ifndef ROUTINE
#define ROUTINE

typedef struct listeIdfOut1
{
    char chaine[20];
} listeIdfOut1;

listeIdfOut1 T1[10], T2[20];

void testRangFlt(float val, int lignes, char *saveIdf);
void testRangInt(int val, int lignes, char *saveIdf);
int cmpcomp(char chaine[], char *entite, int nb);
void compatible(char *left, char *right, int ligne);
void idfHasType(char *entite, char *valueType, int ligne);
void isNumeric(char *entite, int ligne);
int cmpcompOut(char chaine[], char *entite);
void ExistDeclarationP(char *entity, int ligne);
void outOfRange(char *entity, int indice, int ligne);
void constanteDeja(char *entity, int ligne);
void ExistDeclarationP(char *entity, int ligne);

void insererT1(char *entity);
void insererT2(char *entity);
void outputChaine(char *entity);
void afficherOutPut();
void initialiser();
void testoutput(int ligne);
void divisionZero(char *s, int ligne);

#endif
