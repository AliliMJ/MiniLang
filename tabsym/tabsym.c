#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include "tabsym.h"

int taille = 200;
int MAX_LIST_DEC = 10;

char *allouerstr(int size)
{
    char *ch;
    ch = (char *)malloc(size * sizeof(char));

    if (ch == NULL)
    {
        printf("erreur de allocaion!!");
        exit(-1);
    }
    return (ch);
}

void strtohigher(char *s) // cette fonction a meme role de tosuper mais elle converte un chaine
{
    int i;
    char *p;
    p = allouerstr(15);
    for (i = 0; i < strlen(s); i++)
    {
        p[i] = toupper(s[i]);
    }
    p[i] = '\0';
    s[0] = '\0';
    strcat(s, p);
    free(p);
}

int hash_func(char *M)
{
    int code = 3;
    int c;

    char *ch;
    ch = allouerstr(15);
    strcpy(ch, M);

    strtohigher(ch);

    while ((c = *ch++))
    {
        code = ((code << 5) + code) + tolower(c);
    }
    return (code % taille);
}

void initialiter() // fonction pour allouer et initialiser le tableau de hachage
{
    int i;

    ts = (ptrTAB)malloc(taille * sizeof(tab));

    for (i = 0; i < taille; i++)
    {
        ts[i].svt2 = NULL;
    }
}

void affiche() // fonction pour afficher le contenu de table
{
    int i;
    ptr p1;

    printf("\n\n************************* Table des symboles **************************\n");
    printf("\t __________________________________________________________________________________\n");
    printf("\t|   Nom Entite    |   Code Entite   |   Type  |        constant       | Taille Tab |\n");
    printf("\t|_________________|_________________|_________|_______________________|____________|\n");

    for (i = 0; i < taille; i++)
    {
        if (ts[i].svt2 != NULL)
        {
            p1 = ts[i].svt2;
            while (p1 != NULL)
            {
                printf("\t| %15s | %15s | %7s |  %19s  | %10d |\n", p1->entity_name, p1->entity_code, p1->entity_type, p1->constante, p1->tablenght);
                p1 = p1->svt1;
            }
        }
    }
    printf("\t|_________________|_________________|_________|_______________________|____________|\n");
}

ptr allouerptr() // cette fonction pour allouer un espace memoire pour un element de la liste chaine
{
    ptr L;

    L = (ptr)malloc(sizeof(liste)); // allocation dynamique de pointeur vers un element de chaine de type liste
    L->entity_name = allouerstr(15);  // allouer la chaine de caractere dynamique
    L->entity_code = allouerstr(15);
    L->entity_type = allouerstr(15);
    L->constante = allouerstr(15);

    L->entity_name[0] = '\0';
    L->entity_code[0] = '\0';
    L->entity_type[0] = '\0';
    L->constante[0] = '\0';
    L->tablenght = 0;
    L->svt1 = NULL;
    return (L);
}

int Rechercher(char *entite)
{
    ptr p = NULL;
    int i;
   
    i = hash_func(entite);

    p = ts[i].svt2;
    while (p != NULL)
    {
        if (strcmp(entite, p->entity_name) == 0)
            return i;
        p = p->svt1;
    }
    return -1; // en cas ne trouve pas le var dans la tables des symboles
}

ptr RechercherPtr(char *entite)
{
    int i;
    i = hash_func(entite);
    ptr p;
    p = ts[i].svt2;
    while (p != NULL)
    {
        if (strcmp(entite, p->entity_name) == 0)
            return p;
        p = p->svt1;
    }
    return NULL; // en cas ne trouve pas le var dans la tables des symboles
}

void inserer(char *entite, char *code)
{
    ptr q = NULL;
    int s;

    s = hash_func(entite);

    if (Rechercher(entite) == -1)
    {
        if (ts[s].svt2 == NULL)
        {
            ts[s].svt2 = allouerptr();
            strcpy(ts[s].svt2->entity_name, entite);
            strcpy(ts[s].svt2->entity_code, code);
            strcpy(ts[s].svt2->constante, "non");
            ts[s].svt2->tablenght = -1;
            ts[s].svt2->svt1 = NULL;
        }
        else
        {
            q = allouerptr();
            strcpy(q->entity_name, entite);
            strcpy(q->entity_code, code);
            strcpy(q->constante, "non");
            q->tablenght = -1;

            q->svt1 = ts[s].svt2;
            ts[s].svt2 = q;
        }
    }
}

void InsererType(char *entite, char *type)
{
    ptr p = RechercherPtr(entite);
    if (p != NULL)
        strcpy(p->entity_type, type);
}

void InsererC(char *entite, char *val)
{
    ptr p;
    if (Rechercher(entite) != -1)
    {
        p = RechercherPtr(entite);
        if(p!=NULL)
          strcpy(p->constante, val);
    }
}

void InsererTailleTab(char *entite, int taille)
{
    ptr p = RechercherPtr(entite);
    if (p != NULL)
        p->tablenght = taille;
    strcpy(p->entity_code, "idf tab");
}

////////////// erreurs //////////////////
// double declaration
int ExistDeclaration(char *entite)
{
    ptr q = RechercherPtr(entite);

    if (q!=NULL && strcmp(q->entity_type, "") == 0 && strcmp(q->constante, "non") == 0)
    {

        return 0; // non declare
    }

    return -1; // deja declare
}

int ExistDeclarationT(char *entite)
{
    ptr q = RechercherPtr(entite);
    if (q != NULL)
        return 0;
    return -1;
}

int toInt(int val)
{
    return val;
}

// ************** liste idf ************************
void newT()
{
    if (T)
        free(T);
    T = malloc(MAX_LIST_DEC * sizeof(listeIdf));
}

void initialiterListeIdf() // fonction pour allouer et initialiser le tableau de hachage
{
    newT();
    int i;
    for (i = 0; i < MAX_LIST_DEC; i++)
    {
        strcpy(T[i].motc, "");
    }
    nbIdf = 0;
}

void InsererTypeC(char *type)
{
    int i;
    ptr p;
    for (i = 0; i < nbIdf; i++)
    {
        p = RechercherPtr(T[i].motc);
        if(p!=NULL) 
          strcpy(p->entity_type, type);
    }

    initialiterListeIdf();
}

int insererT(char *c)
{
    int i;
    for (i = 0; i < nbIdf; i++)
    {
        if (strcmp(c, T[i].motc) == 0)
        {
            return -1;
        }
    }
    strcpy(T[nbIdf].motc, c);
    nbIdf++;
    return 0;
}

// **************** liste constantes ***********************

void newC()
{
    if (T)
        free(T);
    C = malloc(MAX_LIST_DEC * sizeof(listeCnst));
}

void initialiterListeCnst() // fonction pour allouer et initialiser le tableau de hachage
{
    newC();
    int i;
    for (i = 0; i < MAX_LIST_DEC; i++)
    {
        strcpy(C[i].motc, "");
    }
    nbC = 0;
}

void InsererTypeCnste(char *type, char *init)
{
    int i;
    ptr p;
    for (i = 0; i < nbC; i++)
    {
        p = RechercherPtr(C[i].motc);
        if (p != NULL) {
          strcpy(p->entity_type, type);
          strcpy(p->constante, init);
        }
        
    }

    // initialiterListeCnst();
}

int insererCnst(char *c)
{
    int i;
    for (i = 0; i < nbC; i++)
    {
        if (strcmp(c, C[i].motc) == 0)
        {
            return -1;
        }
    }
    strcpy(C[nbC].motc, c);
    nbC++;
    return 0;
}

void afficherC()
{
    int i;

    for (i = 0; i < nbC; i++)
    {
        printf("[%s]", C[i].motc);
    }
}

void cnsteInit(char *entite, char *init)
{
    ptr p = RechercherPtr(entite);
    if (p != NULL) 
      strcpy(p->constante, init);
}

void insererTypeCnst(char *entite, char *type)
{
    ptr p = RechercherPtr(entite);
    if (p != NULL) 
      strcpy(p->entity_type, type);
}

int isCste(char *entity)
{
    ptr p = RechercherPtr(entity);
    if (strcmp(p->constante, "null") == 0 || strcmp(p->constante, "oui") == 0)
        return 1;
    return 0;
}

int csteDejaAff(char *entity)
{
    ptr p = RechercherPtr(entity);
    
    if (p!=NULL) {
      if (strcmp(p->constante, "null") == 0)
    {
        strcpy(p->constante, "oui");
        return 0;
    }
    else if (strcmp(p->constante, "oui") == 0)
    {
        return 1;
    }
    }
    
    return -1;
}

// ******************************************************************


 


// ******************************************************************

int verifierReelNonSigne(char *token, int size)
{

    int avantVergule = 0, apresVergule = 0, i = 0;
    while (token[i] != '.' && i < size)
    {
        avantVergule++;
        i++;
    }
    apresVergule = size - i - 1;
    if (apresVergule <= 3 && avantVergule <= 7)
        return 0; // accepter
    return -1;
}

char *sansParentheses(char *s)
{
    int reelSize = strlen(s) - 2;
    char *sansPar = malloc(reelSize * sizeof(char));
    memcpy(sansPar, &s[1], reelSize);
    sansPar[reelSize] = '\0';
    return sansPar;
}

int verifierReelSigne(char *token, int size)
{

    int avantVergule = 0, apresVergule = 0, i = 0;
    while (token[i] != '.' && i < size)
    {
        avantVergule++;
        i++;
    }
    apresVergule = size - i - 1;
    if (apresVergule - 1 <= 3 && avantVergule - 2 <= 7)
        return 0; // accepter
    return -1;
}




/*void verifierOut()
{
    int i = 0;

    while ((strcmp(TOut[nbIdfOut].idf, "") != 0) && (strcmp(TOut[nbIdfOut].idf, "")!=0) && (i < nbIdfOut))
    {
        if (cmpcompOut(TOut[i].c, TOut[i].idf)!=0){
            printf("incompatibilite de types");
        }
            i++;
    }
}*/

// void afficherOut()
// {
//     int i;

//     printf("\n\n");

//     for (i = 0; i < nbIdfOut1; i++)
//     {
//         printf("%d --> idf: %s\n", i, TOut1[i].entity);
//     }

//     for (i = 0; i < nbIdfOut2; i++)
//     {
//         printf("%d --> chaine: %s\n", i, TOut2[i].entity);
//     }
//     printf("\n\n");
// }

char* IntToChar(int x){
    char* c;
    c=allouerstr(15);
   
    sprintf(c,"%d",x);
    return c;
}

char *FltToChar(float x)
{
    char *c;
    c = allouerstr(15);

    sprintf(c, "%.2f", x);
    return c;
}

char * CharToString(char c){
    char* s;
    s=allouerstr(15);
    sprintf(s,"%c",c);
    return s;
}

char * transfertString(char *s){
    int i,l;
    l=strlen(s);

    for(i=0;i<strlen(s)-1;i++){
        s[i]=s[i+1];
    }
    s[l-2]='\0';
    
    return s;
}

char* tabName(char* name, char* arg) {
  char * c;
  c=allouerstr(15);
  
  sprintf(c, "%s[%s]",name, arg);

  return c;
}

int tabSize(char *entity){
    ptr p = RechercherPtr(entity);
    return p->tablenght;
}

void insererCsteVal(char *entity , char *val){
    ptr p = RechercherPtr(entity);
    strcpy(p->constante,val);
}
