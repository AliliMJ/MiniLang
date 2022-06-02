# Mini lang

### **Instructions**

Si vous êtes sous mac os lancer la commande `./unix.sh` pour compiler

sinon lancer `./commandes.bat`. n'oubliez pas de remplacer l'espace par le point d'extension.

Ou bien lancer le code suivant 
```sh
  cd lexical
  flex lexical.l
  cd ../syntax
  bison -d syntax.y
  cd ../
  gcc ./lexical/lex.yy.c ./syntax/syntax.tab.c ./tabsym/tabsym.c ./quad/quad.c ./routines/routine.c ./optimisation/optimisation.c ./generation/generation.c -lfl -ly -o compiler.exe
  compiler.exe<code.txt
```

### **Les resultats et sorties**

Vous trouvrez dans le fichier out.txt le code intermédiaire brute, et l'optimisé en dessous. Le code objet est générer dans le répertoire ****generation****.

### **Membres**

| Nom | Pénom | Matricule | Groupe |
| --- | --- | --- | --- |
| ALILI | Mohamed Lamine | 181839052826 | 4 |
| ABOURI | Abdelkrim | 171731055178 | 3 |


