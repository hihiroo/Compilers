/*
 * Copyright 2020-2022. Heekuck Oh, all rights reserved
 * 이 프로그램은 한양대학교 ERICA 소프트웨어학부 재학생을 위한 교육용으로 제작되었다.
 */
%option noinput nounput yylineno
%{
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include "node.h"
#include "cool.tab.h"
%}

NEWLINE     (\r\n|\n)
WHITESPACE  [ \t]+
DASHCOMMENT --.*\n

%%
                
{WHITESPACE}    /* skip */
{NEWLINE}       /* skip */
{DASHCOMMENT}   /* skip */

(?i:class)           { return CLASS; }
(?i:inherits)        { return INHERITS; }

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

