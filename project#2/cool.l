/*
 * Copyright 2020-2022. Heekuck Oh, all rights reserved
 * 이 프로그램은 한양대학교 ERICA 소프트웨어학부 재학생을 위한 교육용으로 제작되었다.
 */
%option nounput yylineno
%{
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include "node.h"
#include "cool.tab.h"

void comment();
%}

NEWLINE     (\r\n|\n)
WHITESPACE  [ \t]+
DASHCOMMENT --.*\n


%%
                
{WHITESPACE}    /* skip */
{NEWLINE}       /* skip */
{DASHCOMMENT}   /* skip */
"(*"            { comment(); }

(?i:class)           { return CLASS; }
(?i:inherits)        { return INHERITS; }
(?i:if)              { return IF; }
(?i:then)            { return THEN; }
(?i:else)            { return ELSE; }
(?i:fi)              { return FI; }
(?i:let)             { return LET; }
(?i:in)              { return IN; }
(?i:while)           { return WHILE; }
(?i:loop)            { return LOOP; }
(?i:pool)            { return POOL; }
(?i:case)            { return CASE; }
(?i:of)              { return OF; }
(?i:esac)            { return ESAC; }
(?i:new)             { return NEW; }
(?i:isvoid)          { return ISVOID; }
(?i:not)             { return NOT; }
\"([^\\]|(\\.))*\"      { return STRING; }
[A-Z][A-z0-9_]*      { return TYPE; }
[a-z][A-z0-9_]*      { return ID; }
[0-9]+               { return INTEGER; }
(?i:false)           { return BOOLEAN; }
(?i:true)            { return BOOLEAN; }


"("     { return '('; }
")"     { return ')'; }
"{"     { return '{'; }
"}"     { return '}'; }
"<="    { return LTE; }
"<-"    { return ASSIGN; }
"<"     { return '<'; }
"=>"    { return DARROW; }
"="     { return '='; }
","     { return ','; }
";"     { return ';'; }
":"     { return ':'; }
"."     { return '.'; }
"+"     { return '+'; }
"-"     { return '-'; }
"*"     { return '*'; }
"/"     { return '/'; }
"~"     { return '~'; }
"@"     { return '@'; }
.       { fprintf(stderr, "Skip unknown character %s in line %d\n", yytext, yylineno); }

%%

void comment(){
    int open_cnt = 1, pre = -1, c = input();

    while(c != EOF && c != YY_NULL){
        if(pre == '(' && c == '*') open_cnt++;
        else if(pre == '*' && c == ')'){
            if(--open_cnt == 0) return;
        }
        pre = c;
        c = input();
    }
    fprintf(stderr, "comment error in line %d\n", yylineno);
    exit(1);
}

