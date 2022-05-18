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
  sprintf(temp,"T%d",nTemp);nTemp++;
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
    q[index].opr = NULL;
    q[index].op1=NULL;
    q[index].op2=NULL;
    q[index].res=NULL;
  }

} 

void remplacer(char* temp1, char* temp2, int index){
  //tant que temp1 ne se réaffecte de nouveau.
 while(index < indq) {
   if(strcmp(q[index].res, temp1)==0) break;
   else {
     //printf("%d - (, %s, %s, %s)", index,q[index].op1,q[index].op2, q[index].res) ;
   if (strcmp(q[index].op1, "")!=0 && strcmp(q[index].op1, temp1)== 0) {
     
     q[index].op1 = temp2;
     
    }
    if (strcmp(q[index].op2, "")!=0 && strcmp(q[index].op2, temp1)== 0) {
      
     q[index].op2 = temp2;
    }
    //printf("-> (, %s, %s, %s)\n",q[index].op1,q[index].op2, q[index].res );
   }
    
    index ++;
 }  
  
}

void propCopie() {
  int analyse = 0;
  while(analyse+1 < indq) {
    if (strcmp(q[analyse].opr, "=")==0) {
      //printf("%d- %s = %s\n", analyse, q[analyse].res, q[analyse].op1);
      remplacer(q[analyse].res, q[analyse].op1, analyse+1);
      //printf("-------------\n");
      }
    
    analyse ++;
  }

  
  
  
}

int used(char*temp, int index) {
  if(index >= indq) return 1;
  
  while(index < indq) {
    if(strcmp(q[index].res, temp)==0) {return 1;}
    if(strcmp(q[index].op1, temp)==0 || strcmp(q[index].op2, temp)==0){
      printf("%s is used in %d\n", temp, index);
      return 0;
    }
      

    index++;
  }
  return 1;
}

void eliminer() {
  int analyse = 0;
  //int size = 0;
  //quadruplet* s = malloc(100*sizeof(quadruplet));
  while(analyse + 1< indq) {  
    if(strcmp(q[analyse].opr, "=")== 0 && used(q[analyse].res, analyse + 1)!=0) {
      removeQuad(analyse);
      //printf("%d-( %s , %s , %s , %s )\n", size, s[size].opr, s[size].op1, s[size].op2, s[size].res);
      
    }
    analyse ++;
    
    
  }
  if(strcmp(q[analyse].opr, "=")==0) {
    removeQuad(analyse);
    //size++;
  }
  
    // free(q);
    // //memcpy(q, s, sizeof(s));
    // q= malloc(100*sizeof(quadruplet));
    // int i;
    // for(i=0;i<size;i++) q[i]=s[i];

    corrigerBranch();
   printf("\n\n");
  //printf("************************* Quadruplets Optimise **************************\n\n");

    // int i;
    // for (i = 0; i < indq; i++)
    // {
    //     printf("%d-( %s , %s , %s , %s )\n", i, s[i].opr, s[i].op1, s[i].op2, s[i].res);
    // }
    // printf("\n\n");

    //decaler(s, indq);
    


  
}

void corrigerBranch() {
  int branch=0;
  while(branch < indq) {
    if (q[branch].opr!=NULL && q[branch].opr[0] == 'B') {
      int etiq = atoi(q[branch].op1);
      printf("%d- %d\n", branch ,etiq);
      
      while(etiq < indq && q[etiq].opr == NULL) {
        
        etiq++;
        }
      sprintf(q[branch].op1, "%d", etiq);
      
    }
    branch++;
  }
}

// void decaler(quadruplet* quad, int taille) {
//   int i=0,rep=0;
//   while(i < taille) {
//     if(quad[i].opr== NULL) {
//       rep++;
//     }else {
//       int j;
//       if (rep > 0) {
//         for(j=i; j<taille;j++) {
//         if (quad[j].opr!=NULL && quad[j].opr[0]=='B') {
//           int branch = atoi(quad[j].op1);
//           branch = branch - rep;
          
//           sprintf(quad[j].op1, "%d", branch);
//           printf("branch : %s\n", quad[j].op1);

//         }
//       }
//       }
//        rep=0;
     
//     }

  

