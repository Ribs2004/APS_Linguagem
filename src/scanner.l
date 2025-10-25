%option noyywrap
%option yylineno
%option nounput
%option noinput

%{
#include "parser.tab.h"
#include <string.h>
#include <stdlib.h>

int yycolumn = 1;
static void bumpcols(const char* s){
    for(const char* p = s; *p; ++p){
        if(*p == '\n') yycolumn = 1;
        else yycolumn++;
    }
}
%}

/* Macros */
DIGIT      [0-9]
LETTER     [A-Za-z]
IDREST     [A-Za-z0-9_]
WS         [ \t\r]+
STRING     \"([^\"\\\n]|\\[\\nrt\"'])*\"

%%
"var"           { bumpcols(yytext); return VAR; }
"int"           { bumpcols(yytext); return INT_T; }
"bool"          { bumpcols(yytext); return BOOL_T; }
"texto"         { bumpcols(yytext); return TEXTO_T; }
"se"            { bumpcols(yytext); return SE; }
"senao"         { bumpcols(yytext); return SENAO; }
"enquanto"      { bumpcols(yytext); return ENQUANTO; }
"para"          { bumpcols(yytext); return PARA; }
"escreva"       { bumpcols(yytext); return ESCREVA; }
"leia"          { bumpcols(yytext); return LEIA; }
"verdadeiro"    { bumpcols(yytext); return VERDADEIRO; }
"falso"         { bumpcols(yytext); return FALSO; }

{DIGIT}+        { bumpcols(yytext); yylval.ival = strtol(yytext, NULL, 10); return INT_LIT; }
{STRING}        {
                   bumpcols(yytext);
                   size_t n = yyleng - 2;
                   char* buf = (char*)malloc(n + 1);
                   if(!buf) exit(1);
                   memcpy(buf, yytext + 1, n);
                   buf[n] = '\0';
                   yylval.sval = buf;
                   return STR_LIT;
                }

{LETTER}{IDREST}*  { bumpcols(yytext); yylval.sval = strdup(yytext); return IDENT; }

"==" { bumpcols(yytext); return EQ; }
"!=" { bumpcols(yytext); return NE; }
"<=" { bumpcols(yytext); return LE; }
">=" { bumpcols(yytext); return GE; }
"||" { bumpcols(yytext); return OR; }
"&&" { bumpcols(yytext); return AND; }
"="  { bumpcols(yytext); return ASSIGN; }
";"  { bumpcols(yytext); return SEMICOLON; }
":"  { bumpcols(yytext); return COLON; }
","  { bumpcols(yytext); return COMMA; }
"("  { bumpcols(yytext); return LPAREN; }
")"  { bumpcols(yytext); return RPAREN; }
"{"  { bumpcols(yytext); return LBRACE; }
"}"  { bumpcols(yytext); return RBRACE; }
"<"  { bumpcols(yytext); return LT; }
">"  { bumpcols(yytext); return GT; }
"+"  { bumpcols(yytext); return PLUS; }
"-"  { bumpcols(yytext); return MINUS; }
"*"  { bumpcols(yytext); return STAR; }
"/"  { bumpcols(yytext); return SLASH; }
"%"  { bumpcols(yytext); return PERCENT; }
"!"  { bumpcols(yytext); return NOT; }

{WS}  { bumpcols(yytext); }
\n    { bumpcols("\n"); }

.     {
        bumpcols(yytext);
        fprintf(stderr, "Caractere inesperado '%s' na linha %d, col %d\n",
                yytext, yylineno, yycolumn);
      }
%%
