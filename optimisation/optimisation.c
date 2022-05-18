#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "../quad/quad.h"
#include "optimisation.h"

extern int indq;


void optimiser() {
  int changes, iter=0;
  
  do {
    changes =   propArth()+propCopie()+ eliminer();
    iter ++;
  }while(changes > 0);
  afficherQuad();
  printf("%d iterations\n", iter);
}

int remplacer(char* temp1, char* temp2, int index){
  int change = 0;
  //tant que temp1 ne se réaffecte de nouveau.
 while(index < indq) {
   if(q[index].opr!=NULL && strcmp(q[index].res, temp1)==0) return change;
   else {
     //printf("%d - (, %s, %s, %s)", index,q[index].op1,q[index].op2, q[index].res) ;
   if (q[index].opr!=NULL &&strcmp(q[index].op1, "")!=0 && strcmp(q[index].op1, temp1)== 0) {
     
     q[index].op1 = temp2; change=1;
     
    }
    if (q[index].opr!=NULL &&strcmp(q[index].op2, "")!=0 && strcmp(q[index].op2, temp1)== 0) {
      
     q[index].op2 = temp2; change=1;
    }
    //printf("-> (, %s, %s, %s)\n",q[index].op1,q[index].op2, q[index].res );
   }
    
    index ++;
 }  
  return change;
}

int propCopie() {
  int analyse = 0;
  int change = 0;
  while(analyse+1 < indq) {
    if (q[analyse].opr!=NULL && strcmp(q[analyse].opr, "=")==0) {
      //printf("%d- %s = %s\n", analyse, q[analyse].res, q[analyse].op1);
      if (remplacer(q[analyse].res, q[analyse].op1, analyse+1) == 1) change=1;
      //printf("-------------\n");
      }
    
    analyse ++;
  }
  return change;
  
  
  
}

int used(char*temp, int index) {
  if(index >= indq) return 1;
  
  while(index < indq) {
    if(q[index].opr!=NULL && strcmp(q[index].res, temp)==0) {return 1;}
    if(q[index].opr!=NULL && strcmp(q[index].op1, temp)==0 || q[index].opr!=NULL && strcmp(q[index].op2, temp)==0){
      printf("%s is used in %d\n", temp, index);
      return 0;
    }
      

    index++;
  }
  return 1;
}

int eliminer() {
  int analyse = 0;
  int change = 0;
  //int size = 0;
  //quadruplet* s = malloc(100*sizeof(quadruplet));
  while(analyse + 1< indq) {  
    if(q[analyse].opr!=NULL && strcmp(q[analyse].opr, "=")== 0 && used(q[analyse].res, analyse + 1)!=0) {
      removeQuad(analyse); change = 1;
      //printf("%d-( %s , %s , %s , %s )\n", size, s[size].opr, s[size].op1, s[size].op2, s[size].res);
      
    }
    analyse ++;
    
    
  }
  if(q[analyse].opr!=NULL && strcmp(q[analyse].opr, "=")==0) {
    removeQuad(analyse); int change = 1;
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
  return change;
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

int isNumber(char *s)
{
  int i=0;

  while(s[i] != '\0')
  {

    if (s[i] == '.')
    {
      return (2);
    }

    if (isdigit(s[i]) == 0)
      return(0);

    

    i++;
  }

  return(1);
  
}

int propArth(){
  int ind=0;
  int change= 0;
  while(ind<indq){
    if(q[ind].opr != NULL) {
      if ((strcmp(q[ind].opr, "+") == 0) && (isNumber(q[ind].op1) == 1) && (isNumber(q[ind].op2) == 1))
      {
        sprintf(q[ind].op1, "%d", atoi(q[ind].op2) + atoi(q[ind].op1));
        q[ind].op2="";
        q[ind].opr = "=";
        change = 1;
      }

          if ((strcmp(q[ind].opr, "+") == 0) && (isNumber(q[ind].op1) == 2) && (isNumber(q[ind].op2) == 2))
      {
        sprintf(q[ind].op1, "%.2f", atof(q[ind].op2) + atof(q[ind].op1));
        //q[ind].op1 = FltToChar(atof(q[ind].op1) + atof(q[ind].op2));
        q[ind].op2 = "";
        q[ind].opr = "=";
        change = 1;
      }
    }
    ind++;
  }
  return change;
}
