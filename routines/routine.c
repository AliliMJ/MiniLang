#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include "routine.h"
#include "../quad/quad.h"
#include "../optimisation/optimisation.h"
#include "../tabsym/tabsym.h"

int nb1 = 0;
int nb2 = 0;

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

void ExistDeclarationPin(char *entity, int ligne)
{

    if (ExistDeclaration(entity) == 0)
    {
        printf("erreur semantique [%d] : variable non declarer dans input \"%s\"\n", ligne, entity);
    }
}

void outOfRange(char *entity , int indice , int ligne){
     int size;
     size=tabSize(entity);
    if(indice>size){
        printf("erreur semantique [%d] : l'indice de la table depasse la taille \"%s\"\n",ligne,entity);
    }else if(indice<0){
        printf("erreur semantique [%d] : l'indice est negatif \"%s\"\n", ligne, entity);
    }

}

void constanteDeja(char *entity , int ligne){
    if(csteDejaAff(entity)==1){
        printf("erreur semantique [%d] : constante deja affecter \"%s\"\n", ligne, entity);
    }
}

void insererT1(char *entity){
    strcpy(T1[nb1].chaine,entity);
    nb1++;
}

void insererT2(char *entity)
{
    strcpy(T2[nb2].chaine, entity);
    nb2++;
}

void outputChaine(char *entity){
    int i;
    char s[10];

    s[0]='\0';

    for(i=0;i<strlen(entity);i++){
        // if ((entity[i] == '$') || (entity[i] == '@') || (entity[i] == '%') || (entity[i] == '#') || (entity[i] == '&')){
        //     s[0]=entity[i];
        //     insererT2(s);
        //     printf("\n\nsignature : %s %d\n\n", s, strlen(s));
        //     printf("\n\nsignature : %s %d\n\n", T1[nb1 - 1].chaine, strlen(T1[nb1 - 1].chaine));
        // }

        if(entity[i] =='$'){
            insererT2("$");
        }else if (entity[i] == '@'){
            insererT2("@");
        }else if (entity[i] == '%'){
            insererT2("%");
        }else if (entity[i] == '#'){
            insererT2("#");
        }
        else if (entity[i] == '&'){
            insererT2("&");
        }
    }
}

void initialiser(){
    int i;

    for(i=0;i<10;i++){
        T1[i].chaine[0]='\0';
        T2[i].chaine[0] = '\0';
    }
    nb1 = 0;
    nb2 = 0;
}

// void afficherOutPut(){
//     int i;

//     for(i=0;i<nb1;i++){
//         printf(" T1[%d] :  %s ",i, T1[i].chaine);
//     }

//     printf("\n");

//     for (i = 0; i < nb2; i++)
//     {
//         printf(" T2[%d] : %s ",i,T2[i].chaine);
//     }



//     for (i = 0; i < nb1; i++)
//     {
//         printf(" T1[%d] :  %s ", i, T1[i].chaine);
//     }

//     printf("\n\n");
// }


void testoutput(int ligne){
    int i;

    if(nb1!=nb2){
        printf("erreur semantique [%d] : different entre signaure et variables\n",ligne);
    }else{
        ptr p;
        for(i=0;i<nb1;i++){

            p=RechercherPtr(T1[i].chaine);

            if(strcmp(p->entity_type,"INT")==0){
                if(strcmp(T2[i].chaine,"$")!=0){
                    printf("erreur semantique [%d] : incompatibilte de type dans output entre %s et %s\n",ligne,T1[i].chaine,T2[i].chaine);
                }
            }
            else if (strcmp(p->entity_type, "FLT") == 0)
            {
                if (strcmp(T2[i].chaine, "%") != 0)
                {
                    printf("erreur semantique [%d] : incompatibilte de type dans output entre %s et %s\n", ligne, T1[i].chaine, T2[i].chaine);
                }
            }
            else if (strcmp(p->entity_type, "STR") == 0)
            {
                if (strcmp(T2[i].chaine, "#") != 0)
                {
                    printf("erreur semantique [%d] : incompatibilte de type dans output entre %s et %s\n", ligne, T1[i].chaine, T2[i].chaine);
                }
            }
            else if (strcmp(p->entity_type, "CHR") == 0)
            {
                if (strcmp(T2[i].chaine, "&") != 0)
                {
                    printf("erreur semantique [%d] : incompatibilte de type dans output entre %s et %s\n", ligne, T1[i].chaine, T2[i].chaine);
                }
            }
            else if (strcmp(p->entity_type, "BLT") == 0)
            {
                if (strcmp(T2[i].chaine, "@") != 0)
                {
                    printf("erreur semantique [%d] : incompatibilte de type dans output entre %s et %s\n", ligne, T1[i].chaine, T2[i].chaine);
                }
            }
        }
    }

}

void divisionZero(char *s , int ligne){
    if(atoi(s)==0){
        printf("erreur semantique [%d] : division par zero !!\n",ligne);
    }

}
