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

unsigned long hash_func(char* M)
{
    unsigned long code = 3;
    int c;

    strtohigher(M);

    while ((c = *M++))
    {
        code = ((code << 5) + code) + tolower(c);
    }
    return (code % 100) ;
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
                printf("\t|_______________________________________________________________________|\n");
                p1 = p1->svt1;
            }
        }
    }
}

