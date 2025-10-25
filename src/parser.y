%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* yylex vem do Flex */
int yylex(void);
void yyerror(const char *s);
%}

/* erro detalhado */
%define parse.error detailed

/* Tipos de yylval */
%union {
  long ival;
  char *sval;
}

/* Tokens */
%token VAR "var"
%token INT_T "int"
%token BOOL_T "bool"
%token TEXTO_T "texto"

%token SE "se"
%token SENAO "senao"
%token ENQUANTO "enquanto"
%token PARA "para"
%token ESCREVA "escreva"
%token LEIA "leia"

%token VERDADEIRO "verdadeiro"
%token FALSO "falso"

%token <ival> INT_LIT
%token <sval> STR_LIT
%token <sval> IDENT

%token ASSIGN "="
%token SEMICOLON ";"
%token COLON ":"
%token COMMA ","
%token LPAREN "("
%token RPAREN ")"
%token LBRACE "{"
%token RBRACE "}"

%token OR "||"
%token AND "&&"
%token EQ "=="
%token NE "!="
%token LT "<"
%token LE "<="
%token GT ">"
%token GE ">="

%token PLUS "+"
%token MINUS "-"
%token STAR "*"
%token SLASH "/"
%token PERCENT "%"
%token NOT "!"

/* Precedência e associatividade (baixa → alta) */
%left OR
%left AND
%left EQ NE
%left LT LE GT GE
%left PLUS MINUS
%left STAR SLASH PERCENT
%precedence NOT
%precedence UMINUS

/* Resolver 'dangling else' */
%precedence NO_ELSE
%precedence SENAO


/* Não precisamos de valores nessas regras agora */
%type <sval> type_opt

%start program

%%

program
  : list_decl_cmd
  ;

list_decl_cmd
  : %empty
  | list_decl_cmd item
  ;

item
  : decl
  | cmd
  ;

decl
  : VAR IDENT type_opt init_opt SEMICOLON
  ;

type_opt
  : %empty                 { $$ = NULL; }
  | COLON type             { $$ = NULL; }
  ;

type
  : INT_T
  | BOOL_T
  | TEXTO_T
  ;

init_opt
  : %empty
  | ASSIGN expr
  ;

cmd
  : block
  | atrib SEMICOLON
  | se
  | enquanto
  | para
  | escreva SEMICOLON
  | leia SEMICOLON
  | SEMICOLON               /* comando vazio */
  ;

block
  : LBRACE list_decl_cmd RBRACE
  ;

atrib
  : IDENT ASSIGN expr
  ;

se
  : SE LPAREN expr RPAREN cmd                   %prec NO_ELSE
  | SE LPAREN expr RPAREN cmd SENAO cmd
  ;

enquanto
  : ENQUANTO LPAREN expr RPAREN cmd
  ;

para
  : PARA LPAREN para_init_opt SEMICOLON para_cond_opt SEMICOLON para_upd_opt RPAREN cmd
  ;

para_init_opt
  : %empty
  | atrib
  | decl
  ;

para_cond_opt
  : %empty
  | expr
  ;

para_upd_opt
  : %empty
  | atrib
  ;

escreva
  : ESCREVA LPAREN arglist_opt RPAREN
  ;

leia
  : LEIA LPAREN IDENT RPAREN
  ;

arglist_opt
  : %empty
  | arglist
  ;

arglist
  : expr
  | arglist COMMA expr
  ;

expr
  : expr OR expr
  | expr AND expr
  | expr EQ expr
  | expr NE expr
  | expr LT expr
  | expr LE expr
  | expr GT expr
  | expr GE expr
  | expr PLUS expr
  | expr MINUS expr
  | expr STAR expr
  | expr SLASH expr
  | expr PERCENT expr
  | NOT expr
  | MINUS expr %prec UMINUS
  | primary
  ;

primary
  : INT_LIT
  | VERDADEIRO
  | FALSO
  | STR_LIT
  | IDENT
  | LPAREN expr RPAREN
  ;

%%

void yyerror(const char *s) {
  extern int yylineno;
  extern int yycolumn; /* definido no scanner */
  fprintf(stderr, "Erro sintatico: %s na linha %d, coluna %d\n", s, yylineno, yycolumn);
}
