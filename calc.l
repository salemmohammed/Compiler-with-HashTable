%option yylineno
%{
#include "symbols.h"
extern int no_elements;
#include "calc.tab.h"


%}

digit		([0-9])
letter		([a-z])
%%

"printvar"       			{       return(TOK_PRINTVAR);}
"main()"				{	return(TOK_MAIN);}
"{"					{	return(TOK_OBRACE);}
"}"					{	return(TOK_CBRACE);}
"int"					{	return(TOK_INT);}
"float"					{	return(TOK_FL);}
{digit}+				{    	yylval.intval = atoi(yytext);  return(TOK_NUM); }
{digit}+"."{digit}+ 			{	yylval.floatval = atof(yytext);	return(TOK_FLOAT); }	
{letter}+{digit}*			{	yylval.str = strdup(yytext); return(TOK_VARIABLE) ;}
";"					{	return(TOK_SEMICOLON);	}
"="					{	return(TOK_EQUAL);	}
"+"					{	return(TOK_ADD);	}
"*"					{	return(TOK_MUL);	}
"-"					{printf("Parsing error : Line no %d \n",yylineno); exit(1);}
[ \n] 					{}
[ \t]   				{}
[\0]    				{}
{digit}+{letter}+			{printf("Parsing error : Line no %d \n",yylineno);exit(1);}
.					{ yyerror(); }



%%

