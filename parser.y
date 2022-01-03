
%{

#include "global.h"
#include <stdio.h>
#include <stdlib.h>

int yylex();
int yyerror(const char *s);
%}

%token TOKEN_MULTICOM
%token TOKEN_COMMENT
%token TOKEN_CHAR
%token TOKEN_TEXT
%token TOKEN_NUMBER
%token TOKEN_FALSE
%token TOKEN_TRUE
%token TOKEN_DECLARE
%token TOKEN_CONST
%token TOKEN_START
%token TOKEN_STOP
%token TOKEN_STRUCT
%token TOKEN_READ
%token TOKEN_WRITE
%token TOKEN_IF
%token TOKEN_ELSE
%token TOKEN_FOR
%token TOKEN_IN
%token TOKEN_FROM
%token TOKEN_WHILE
%token TOKEN_ASSIGN
%token NUM
%token BOOL
%token CHAR
%token FININSTR
%token ACCOLAD_G
%token ACCOLAD_D
%token BEGIN
%token END
%token PARENTHESE_G
%token PARENTHESE_D

%token TOKEN_INF
%token TOKEN_SUP
%token TOKEN_INFEGAL
%token TOKEN_SUPEGAL
%token TOKEN_EGAL
%token TOKEN_DIFF
%token TOKEN_ADD
%token TOKEN_SOUSTR
%token TOKEN_MULT
%token TOKEN_DIVIS
%token TOKEN_MOD

%token TOKEN_NOT
%token TOKEN_AND
%token TOKEN_OR

%token TOKEN_COMMA
%token TOKEN_ACSTRUCT
%token TOKEN_ID

%token TOKEN_FININPUT

%%

ExpBool:
  | TOKEN_ID { $$=$1 } //verifier si la variable est une variable booleen dans l'analyse semantique
  | TOKEN_FALSE { $$=$1; }
  | TOKEN_TRUE  { $$=$1; }
  | PARENTHESE_G ExpBool PARENTHESE_DROITE { $$=$1; }
  | TOKEN_NOT ExpBool { $$=!$2; }
  | ExpBool TOKEN_AND ExpBool { $$=($1)&&($3); }
  | ExpBool TOKEN_OR ExpBool  { $$=($1)||($3); }
  | Comparaison
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
Blocif:
    TOKEN_IF Expbool begin (instru)* { else  (instru)*} end
%%

int yyerror(const char *s) {
  printf("%s\n",s);
}

int main(void) {
  yyparse();
}