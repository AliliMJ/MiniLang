#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "quad.h"
int indq = 0;
int nTemp=1;

void initialiterListeQuad() {
  q = malloc(100*sizeof(quadruplet));
}

char *allouer()
{
    char *ch;
    ch = (char *)malloc(15 * sizeof(char));

    if (ch == NULL)
    {
        printf("erreur de allocaion!!");
        exit(-1);
    }
    return (ch);
}
void quad(char *o, char *o1, char *o2, char *r)
{
    q[indq].opr = o;
    q[indq].op1 = o1;
    q[indq].op2 = o2;
    q[indq].res = r;
    indq++;
}
char* temporaire() {
  char* temp;
  temp = allouer();
  sprintf(temp,"_T%d",nTemp);nTemp++;
  return temp;
}
void afficherQuad()
{
  printf("\n\n");
  printf("************************* Quadruplets **************************\n\n");

    int i;
    for (i = 0; i < indq; i++)
    {
      if (q[i].opr != NULL)
        printf("%d-( %s , %s , %s , %s )\n", i, q[i].opr, q[i].op1, q[i].op2, q[i].res);
      else printf("%d-\n", i);
    }
    printf("\n\n");
}

char *BoolToString(int b) {
  char*c;
  c = allouer();
  if(b==1) c= "TRUE";
  else c="FALSE";
  return c;
}

void removeQuad(int index) {
  if(index < indq) {
    q[index].opr =NULL;
    q[index].op1=NULL;
    q[index].op2=NULL;
    q[index].res=NULL;
  }

} 


