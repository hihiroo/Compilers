/*
 * Copyright 2020-2022. Heekuck Oh, all rights reserved
 * 이 프로그램은 한양대학교 ERICA 소프트웨어학부 재학생을 위한 교육용으로 제작되었다.
 */
%{
#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
#include "node.h"

int yylex();
extern FILE* yyin;
extern int yylineno;
extern char *yytext;
static int num_errors = 0;
static class_list_t *program;
void yyerror(char const *s);
%}

%union{
    class_list_t *class_list;
    char *s;
    int i;
    bool b;
}

%token CLASS INHERITS IF THEN ELSE FI LET IN
%token WHILE LOOP POOL CASE OF DARROW ESAC
%token NEW ISVOID ASSIGN NOT LTE
%token <s> STRING TYPE ID
%token <i> INTEGER
%token <b> BOOLEAN
%token EOL


%type <class_list> class_list

%start program

%left '+' '-'
%left '*' '/'
%left '(' ')'

%%

program: class_list { program = $1; }
    ;

class_list: class {}
    | error ';' {}
    | class_list class {}
    ;

class: CLASS TYPE '{' feature_list '}' ';' {}
    | CLASS TYPE '{' '}' ';' {}
    | CLASS TYPE INHERITS TYPE '{' feature_list '}' ';' {}
    | CLASS TYPE INHERITS TYPE '{' '}' ';' {}
    ;

feature_list: feature ';' {}
    | error ';' {}
    | feature_list feature ';' {}
    ;

feature: ID '(' formal_list ')' ':' TYPE '{' expr '}' {}
    | ID '(' ')' ':' TYPE '{' expr '}' {}
    | ID ':' TYPE ASSIGN expr {}
    | ID ':' TYPE {}
    ;

formal_list: formal {}
    | formal_list ',' formal {}
    ;

formal: ID ':' TYPE {}
    ;

expr_list_comma: expr {}
    | error {}
    | expr_list_comma ',' expr {}
    ;

expr_list: expr ';' {}
    | error ';' {}
    | expr_list expr ';' {}
    ;

let_exprs: let_expr {}
    | error {}
    | let_exprs ',' let_expr {}
    ;

let_expr: ID ':' TYPE ASSIGN expr {}
    | ID ':' TYPE {}
    ;  

case_expr: ID ':' TYPE DARROW expr ';' {}
    | error {}
    | case_expr ID ':' TYPE DARROW expr ';' {}
    ;

expr: ID ASSIGN expr {}
    | expr '@' TYPE '.' ID '(' expr_list_comma ')' {}
    | expr '@' TYPE '.' ID '(' ')' {}
    | expr '.' ID '(' expr_list_comma ')' {}
    | expr '.' ID '(' ')' {}
    | ID '(' expr_list_comma ')' {}
    | ID '(' ')' {}
    | IF expr THEN expr ELSE expr FI {}
    | WHILE expr LOOP expr POOL {}
    | '{' expr_list '}' {}
    | '{' '}' {}
    | LET let_exprs IN expr {}
    | CASE expr OF case_expr ESAC {}
    | NEW TYPE {}
    | ISVOID expr {}
    | expr '+' expr {}
    | expr '-' expr {}
    | expr '*' expr {}
    | expr '/' expr {}
    | '~' expr {}
    | expr '<' expr {}
    | expr LTE expr {}
    | expr '=' expr {}
    | NOT expr {}
    | '(' expr ')' {}
    | ID {}
    | INTEGER {}
    | STRING {}
    | BOOLEAN {}
    ;

%%

void yyerror(char const *s)
{
    /*
     * 오류의 개수를 누적한다.
     */
    ++num_errors;
    /*
     * 문법 오류가 발생한 줄번호와 관련된 토큰을 출력한다.
     */
    if (yychar > 0)
        printf("%s in line %d at \"%s\"\n", s, yylineno, yytext);
    else
        printf("%s in line %d (unexpected EOF)\n", s, yylineno);
}

int main(int argc, char *argv[])
{
    /*
     * 스캔할 COOL 파일을 연다. 파일명이 없으면 표준입력이 사용된다.
     */
    if (argc > 1)
        if (!(yyin = fopen(argv[1],"r"))) {
            printf("\"%s\"는 잘못된 파일 경로입니다.\n", argv[1]);
            exit(1);
        }
    /*
     * 구문분석을 위해 수행한다.
     */
    yyparse();
    /*
     * 오류의 개수를 출력한다.
     */
    if (num_errors > 0)
         printf("%d error(s) found\n", num_errors);
    else
         show_class_list(program);
    
    return 0;
}
