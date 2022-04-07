#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

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

tab ts[100];

char *allouerstr()
{
    char *ch;
    ch = (char *)malloc(20 * sizeof(char)); 

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
    p = allouerstr();
    for (i = 0; i < strlen(s); i++)
    {
        p[i] = toupper(s[i]);
    }
    p[i] = '\0';
    s[0] = '\0';
    strcat(s, p);
    free(p);
}

int hash_func(char* M)
{
    int code = 3;
    int c;

    strtohigher(M);

    while ((c = *M++))
    {
        code = ((code << 5) + code) + tolower(c);
    }
    return (code % 20) ;
}



ptrTAB initialiter(long n) // fonction pour allouer et initialiser le tableau de hachage
{
    long i;
    ptrTAB T;

    T = (ptrTAB)malloc(n * sizeof(tab));

    for (i = 0; i < n; i++)
    {
        T[i].svt2 = NULL;
    }
    return (T);
}

void affiche(ptrTAB T, long n) // fonction pour afficher le contenu de table
{
    int i;
    ptr p1;

    printf("\n\n************************* Table des symboles **************************\n");
    printf("\t _______________________________________________________________________\n");
    printf("\t|   Nom Entite    |   Code Entite   |   Type  |  constante | Taille Tab |\n");
    printf("\t|_________________|_________________|_________|____________|____________|\n");

    for (i = 0; i < n; i++)
    {
        if (T[i].svt2 != NULL)
        {
            p1 = T[i].svt2;
            while (p1 != NULL)
            {
                
                        printf("\t| %15s | %15s | %7s |  %8s  | %10d |\n", p1->entity_name, p1->entity_code, p1->entity_type,p1->constante, p1->tablenght);
                p1 = p1->svt1;
            }
        }
    }
    printf("\t|_________________|_________________|_________|____________|____________|\n");
}

ptr allouerptr() // cette fonction pour allouer un espace memoire pour un element de la liste chaine
{
    ptr L;

    L = (ptr)malloc(sizeof(liste)); // allocation dynamique de pointeur vers un element de chaine de type liste
    L->entity_name = allouerstr();         // allouer la chaine de caractere dynamique
    L->entity_code = allouerstr();
    L->entity_type = allouerstr();
    L->constante = allouerstr();

    L->entity_name[0] ='\0';
    L->entity_code[0] ='\0';
    L->entity_type[0] = '\0';
    L->constante[0] = '\0';
    L->tablenght=0 ;
    L->svt1=NULL;
    return (L);
}

int Rechercher(char *entite)
{
    int i;
    i = hash_func(entite);
    ptr p;
    p=ts[i].svt2;
    while (p != NULL)
    {
        if (strcmp(entite,p->entity_name) == 0)
            return i;
        p=p->svt1;
    }
    return -1; // en cas ne trouve pas le var dans la tables des symboles
}

void inserer(char *entite, char *code)
{
    ptr p;
    int s;
    s=hash_func(entite);
    printf("\n%d\n",Rechercher(entite));

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
    else{
        printf("je suis la");
        p = allouerptr();
        strcpy(p->entity_name, entite);
        strcpy(p->entity_code, code);
        strcpy(p->constante, "non");
        p->tablenght = -1;

        p->svt1 = ts[s].svt2;
        ts[s].svt2 = p;
    }
    }
}

 int main() {
     int i,k;
     char *ch;
     ptr L,p;

     ch = allouerstr();

      for(i=0;i<20;i++){
          ts[i].svt2=NULL;
      }

      scanf("%s",ch);
      k = hash_func(ch);
      printf("\n%s:%d", ch,k);

    //   for (i = 0; i < 20; i++)
    //   {
    //       ts[i].svt2 = allouerptr();
    //       L = ts[i].svt2;
    //       L->entity_name = "idf";
    //       L->entity_type = "int";
    //       L->constante = "non";
    //       L->entity_code = "idf";
    //       L->svt1 = NULL;
    // }

    inserer(ch,ch);

    printf("\n\n");

     affiche(ts, 20);

    return 0;
}
