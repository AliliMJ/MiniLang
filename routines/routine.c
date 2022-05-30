#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include "routine.h"
#include "../quad/quad.h"
#include "../optimisation/optimisation.h"
#include "../tabsym/tabsym.h"

void testRangFlt(float val, int lignes, char *saveIdf)
{
    if ((val > 32767) || (val < -32767))
    {
        printf("erreur semantique [%d] : valeur de entier depasser la limite [-32767,32767] %s \n", lignes, saveIdf);
    }
}

void testRangInt(int val, int lignes, char *saveIdf)
{
    if ((val > 32767) || (val < -32767))
    {
        printf("erreur semantique [%d] : valeur de entier depasser la limite [-32767,32767] %s \n", lignes, saveIdf);
    }
}

int cmpcomp(char chaine[], char *entite, int nb)
{
    ptr p = RechercherPtr(entite);

    if (p != NULL)
    {

        int i;

        for (i = 0; i < strlen(chaine); i++)
        {
            if (chaine[i] == '$')
            {
                if (strcmp(p->entity_type, "INT") == 0)
                {
                    return 0;
                }
            }
            else if (chaine[i] == '%')
            {
                if (strcmp(p->entity_type, "FLT") == 0)
                {
                    return 0;
                }
            }
            else if (chaine[i] == '#')
            {
                if (strcmp(p->entity_type, "STR") == 0)
                {
                    return 0;
                }
            }
            else if (chaine[i] == '&')
            {
                if (strcmp(p->entity_type, "CHR") == 0)
                {
                    return 0;
                }
            }
            else if (chaine[i] == '@')
            {
                if (strcmp(p->entity_type, "BLT") == 0)
                {
                    return 0;
                }
            }
        }
    }
    printf("erreur semantique [%d] : incompatibelete de type dans input \"%s\"\n", nb, entite);

    return -1;
}

void compatible(char *left, char *right , int ligne)
{

    ptr l = RechercherPtr(left);
    ptr r = RechercherPtr(right);
    if (l == NULL || r == NULL)
    {
        if(l=NULL){
            printf("erreur semantique [%d] : Variable non declare %s \n",ligne,l);
        }else if(r=NULL){
            printf("erreur semantique [%d] : Variable non declare %s \n", ligne, r);
        }
        
    }
    else if (strcmp(l->entity_type, r->entity_type) != 0)
    {
        printf("Incompatible variable assignment (%s) %s := (%s) %s .\n", l->entity_type, l->entity_name, r->entity_type, r->entity_name);
    }
}

void idfHasType(char *entite, char *valueType ,int ligne)
{
    ptr p = RechercherPtr(entite);
    if (p == NULL)
        printf("erreur semantique [%d] : Variable %s non declare\n",ligne,entite);
    else if (strcmp(p->entity_type, valueType) != 0)
    {
        printf("erreur semantique [%d] : Incompatible variable assignment (%s) %s := (%s) .\n", ligne,p->entity_type, p->entity_name, valueType);
    }
}

void isNumeric(char *entite, int ligne)
{
    ptr p = RechercherPtr(entite);
    if (p == NULL)
        printf("erreur semantique [%d] :Variable %s non declare\n",ligne, entite);
    else if (strcmp(p->entity_type, "INT") != 0 && strcmp(p->entity_type, "FLT") != 0)
    {
        printf("erreur semantique [%d] : Cannot assign expression to variable (%s) %s. %d\n", ligne, p->entity_type, p->entity_name, ligne);
    }
}

int cmpcompOut(char chaine[], char *entite)
{
    ptr p = RechercherPtr(entite);
    if (p != NULL)
    {

        int i;

        for (i = 0; i < strlen(chaine); i++)
        {
            if (chaine[i] == '$')
            {
                if (strcmp(p->entity_type, "INT") == 0)
                {
                    return 0;
                }
            }
            else if (chaine[i] == '%')
            {
                if (strcmp(p->entity_type, "FLT") == 0)
                {
                    return 0;
                }
            }
            else if (chaine[i] == '#')
            {
                if (strcmp(p->entity_type, "STR") == 0)
                {
                    return 0;
                }
            }
            else if (chaine[i] == '&')
            {
                if (strcmp(p->entity_type, "CHR") == 0)
                {
                    return 0;
                }
            }
            else if (chaine[i] == '@')
            {
                if (strcmp(p->entity_type, "BOL") == 0)
                {
                    return 0;
                }
            }
        }
    }
    return -1;
}

void ExistDeclarationP(char *entity , int ligne){

    if (ExistDeclaration(entity)==0){
        printf("erreur semantique [%d] : variable non declarer \"%s\"\n", ligne,entity);
    }
}

void outOfRange(char *entity , int indice , int ligne){
     int size;
     size=tabSize(entity);
    if(indice>size){
        printf("erreur semantique [%d] : l'indice de la table depasse la taille \"%s\"\n",ligne,entity);
    }

}

void constanteDeja(char *entity , int ligne){
    if(csteDejaAff(entity)==1){
        printf("erreur semantique [%d] : constante deja affecter \"%s\"\n", ligne, entity);
    }
}
