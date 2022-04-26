#ifndef TABSYM
#define TABSYM

typedef struct liste *ptr;
typedef struct liste
{
    char *entity_name;
    char *entity_code;
    char *entity_type;
    char *constante;
    int tablenght;
    ptr svt1;
} liste;

typedef struct tab *ptrTAB;
typedef struct tab
{
    ptr svt2;
} tab;

ptrTAB ts;

typedef struct listeIdf
{
    char motc[20];
} listeIdf;

listeIdf *T;
int nbIdf;

typedef struct listeCnst
{
    char motc[20];
} listeCnst;

listeIdf *C;
int nbC;

typedef struct listeIdfOut
{
  char entity[30];
} listeIdfOut;

listeIdfOut *TOut1, *TOut2;
int nbIdfOut1, nbIdfOut2;
char *allouerstr();
void strtohigher(char *s);
int hash_func(char *M);
void initialiter();
void affiche();
ptr allouerptr();
int Rechercher(char *entite);
ptr RechercherPtr(char *entite);
void inserer(char *entite, char *code);
void InsererType(char *entite, char *type);
void InsererC(char *entite, char *val);
void InsererTailleTab(char *entite, int taille);
int ExistDeclaration(char *entite);
int ExistDeclarationT(char *entite);
int toInt(int val);
void newT();
void initialiterListeIdf();
void InsererTypeC(char *type);
int insererT(char *c);
void newC();
void initialiterListeCnst();
void InsererTypeCnste(char *type , char *init);
int insererCnst(char *c);
void afficherC();
void cnsteInit(char *entite, char *init);
void insererTypeCnst(char *entite,char *type);
int isCste(char *entity);
int csteDejaAff(char *entity);
int cmpcomp(char chaine[], char *entite , int nb);
int verifierReelNonSigne(char* token, int size);
char* sansParentheses(char* s);
int verifierReelSigne(char* token, int size);
void compatible(char* left, char* right);
void idfHasType(char* entite, char*valueType);
void isNumeric(char* entite);
void newOut();
void initialiterListeIdfOut();
void insertIdfOut1(char *entity);
void insertIdfOut2(char *entity);
int cmpcompOut(char chaine[], char *entite);
void afficherOut();
char* IntToChar(int x);

#endif 
