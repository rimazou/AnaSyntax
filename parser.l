%{

#include "global.h"

TableSymbole* table;
bool erreurLexical = false;
unsigned int linenbr=1;

%}


letter [a-z]
capLetter [A-Z]
digit [0-9]

identifier ({letter}|{capLetter}|"_")({digit}|{letter}|{capLetter}|"_")*

everything .




%%

\*{3}({everything}|\n)*\*{3} {return TOKEN_MULTICOM;} /* can be used with files only */

\*{2}{everything}* {return TOKEN_COMMENT;}

\'{everything}\' {yylval.char=yytext; return TOKEN_CHAR;}

\"{everything}+\" {yylval.text=yytext; return TOKEN_TEXT;} /*Text is a string*/

{digit}+ {yylval.num=atoi(yytext); return TOKEN_NUMBER;}

"false" {yylval.bool=false; return TOKEN_FALSE;}
"true"  {yylval.bool=true; return TOKEN_TRUE;}

"DECLARE" {return TOKEN_DECLARE	;}
"CONST"  {return TOKEN_CONST;}
"START"  {return TOKEN_START	;}
"STOP"  {return TOKEN_STOP	;}
"structure"  {return TOKEN_STRUCT;}
"read"  {return TOKEN_READ	;}
"write"  {return TOKEN_WRITE	;}
"if"  {return TOKEN_IF	;}
"else"  {return TOKEN_ELSE	;}
"for"  {return 	TOKEN_FOR;}
"in"  {return TOKEN_IN	;}
"from"  {return TOKEN_FROM	;}
"while"  {return TOKEN_WHILE;}

"<-" {return TOKEN_ASSIGN;}

"num" { return NUM;}
"bool" {return BOOL;}
"char" {return CHAR;}


[" "]* {}/* ignore all space */

"." {return FININSTR}

"{" {return ACCOLAD_G;}
"}" { return ACCOLAD_D;}
"begin" {return BEGIN;}
"end" {return END;}
"(" {return PARENTHESE_G;}
")" {return PARENTHESE_D;}

"<" {return TOKEN_INF;}
">" {return TOKEN_SUP;}
"<=" {return TOKEN_INFEGAL;}
">=" {return TOKEN_SUPEGAL;}
"=" {return TOKEN_EGAL;}
"!=" {return TOKEN_DIFF;}
"+" {return TOKEN_ADD;}
"-" {return TOKEN_SOUSTR;}
"*" {return TOKEN_MULT;}
"/" {return TOKEN_DIVIS;}
"mod" {return TOKEN_MOD;}

"not" {return TOKEN_NOT;}
"and" {return TOKEN_AND;}
"or" {return TOKEN_OR;}

"," {return TOKEN_COMMA;}
":" {return TOKEN_ACSTRUCT;}

{identifier} {	
		AjouterTable(table->Entete_llc, "identifier",yytext);
		return TOKEN_ID;
		}

# {return TOKEN_FININPUT;}

"\n"    {linenbr++;}
. {fprintf(stderr,"\tERREUR : Lexeme inconnu a la ligne %d. Il s'agit de %s et comporte %d lettre(s)\n",linenbr,yytext,yyleng);
        erreurLexical = true;
        return yytext[0];}

%%


int yywrap() {};

int main(int argc, char *argv[]) {

	
	table=initialisation();
	yyin = fopen( argv[1], "r" );
	if (yyin) {

		yylex();
		printf("Affichage de la table ");
		AfficherTable (table->Entete_llc);
		
			
	} else {
		printf("Erreur de lecture fichier\n******Analyse en ligne de commande\n");
		yyin = stdin;
		yylex();
		printf("Affichage de la table ");
		AfficherTable (table->Entete_llc);
	}
		
	return 0;	
}
