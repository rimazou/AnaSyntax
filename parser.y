%{
#include "global.h"
#include <string.h>

bool erreurSyntax = false;
extern unsigned int linenbr;
extern bool erreurLexical;

%}

/* definition des types utilises */

/* text c'est pour recuperer les nom des variables et les non terminaux du language */

%union {
    long num;
    char char;
    char* text;
    bool bool;
}

/* regles d'associativites: l'ordre de priorite est inverse a celui de lex, last one is plus prioritaire*/


%left TOKEN_ADD TOKEN_SOUSTR

 //TODO: all the rest of the operators in ordre


%right PARENTHESE_G PARENTHESE_D

/* liste des expressions i.e. les non terminaux */


%type<text>     code
%type<text>     commentaire
%type<text>     instruction
%type<text>     affectation
%type<text>     lecture
%type<text>     ecriture
%type<text>     conditionnel
%type<text>     variable
%type<text>     expression_arithmetique
%type<text>     expression_booleenne
%type<text>     while
%type<text>     for

/* liste des tokens i.e. les terminaux */

%token          TOKEN_MULTICOM
%token          TOKEN_COMMENT
%token <char>   TOKEN_CHAR
%token <text>   TOKEN_TEXT
%token <num>    TOKEN_NUMBER
%token <bool>   TOKEN_FALSE
%token <bool>   TOKEN_TRUE
%token          TOKEN_DECLARE
%token          TOKEN_CONST
%token          TOKEN_START
%token          TOKEN_STOP
%token          TOKEN_STRUCT
%token          TOKEN_READ
%token          TOKEN_WRITE
%token          TOKEN_IF
%token          TOKEN_ELSE
%token          TOKEN_FOR
%token          TOKEN_IN
%token          TOKEN_FROM
%token          TOKEN_WHILE
%token          TOKEN_ASSIGN
%token          NUM
%token          BOOL
%token          CHAR
%token          FININSTR
%token          ACCOLAD_G
%token          ACCOLAD_D
%token          BEGIN
%token          END
%token          PARENTHESE_G
%token          PARENTHESE_D

%token          TOKEN_INF
%token          TOKEN_SUP
%token          TOKEN_INFEGAL
%token          TOKEN_SUPEGAL
%token          TOKEN_EGAL
%token          TOKEN_DIFF
%token          TOKEN_ADD
%token          TOKEN_SOUSTR
%token          TOKEN_MULT
%token          TOKEN_DIVIS
%token          TOKEN_MOD

%token          TOKEN_NOT
%token          TOKEN_AND
%token          TOKEN_OR

%token          TOKEN_COMMA
%token          TOKEN_ACSTRUCT
%token <text>   TOKEN_ID

%token          TOKEN_FININPUT

%%
/* definition des regles de production  */
bloc_code:      bloc_code instruction{

                }
                |
                bloc_code commentaire{

                }
commentaire:    TOKEN_COMMENT{
                    printf("commentaire ");
                }
                |
                TOKEN_MULTICOM{
                    printf("commentaire de multiples lignes");
                }                

instruction:    affectation{

                }
                |
                lecture{

                }
                |
                ecriture{

                }
                |
                conditionnel{
                    printf("conditionnel\n");
                }
                |
                while{
                    printf("Boucle Tant que\n");
                    
                }
                |
                for{
                    printf("Boucle Pour\n");
                    
                };

while :         TOKEN_WHILE expression_booleenne BEGIN bloc_code END{
                    
                };
for :           TOKEN_FOR TOKEN_ID TOKEN_FROM TOKEN_NUMBER TOKEN_COMMA TOKEN_NUMBER BEGIN bloc_code END{

                }
                |
                TOKEN_FOR TOKEN_ID TOKEN_IN TOKEN_ID BEGIN bloc_code END {

                }
conditionnel :  TOKEN_IF Expbool BEGIN  bloc_code END {

                }
                |TOKEN_IF Expbool BEGIN  bloc_code TOKEN_ELSE  bloc_code END{
                    
                }
expression_booleenne: Expbool{

                      }
                      |
                    Comparaison {

                    }

ExpBool:
                | TOKEN_ID { $$=$1 } //verifier si la variable est une variable booleen dans l'analyse semantique
                | TOKEN_FALSE { $$=$1; }
                | TOKEN_TRUE  { $$=$1; }
                | PARENTHESE_G ExpBool PARENTHESE_DROITE { $$=$1; }
                | TOKEN_NOT ExpBool { $$=!$2; }
                | ExpBool TOKEN_AND ExpBool { $$=($1)&&($3); }
                | ExpBool TOKEN_OR ExpBool  { $$=($1)||($3); }
  ;
Comparaison:
                | comparable TOKEN_EGAL comparable { $$=($$1==$$3) }
                | comparable TOKEN_DIFF comparable { $$=($$1!=$$3) }
                | comparable TOKEN_SUP comparable { $$=($$1>$$3) }
                | comparable TOKEN_SUPEGAL comparable { $$=($$1>=$$3) }
                | comparable TOKEN_INF comparable { $$=($$1<$$3) }
                | comparable TOKEN_INFEGAL comparable { $$=($$1<=$$3) }
                ;
comparable:
                 | TOKEN_ID // since ya pas de traitement il prendra par defaut $1
                 | CHAR
                 | NUM
                 ;
                              
                
%%