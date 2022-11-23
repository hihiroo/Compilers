/*
 * Copyright 2020-2022. Heekuck Oh, all rights reserved
 * 이 프로그램은 한양대학교 ERICA 소프트웨어학부 재학생을 위한 교육용으로 제작되었다.
 */
#include <stdio.h>
#include <stdlib.h>
#include "node.h"

// 아래 함수는 필요한 전체 함수 중 극히 일부에 불과하다.
// 학생들은 필요한 함수를 추가한다.


class_t* new_class(char *type, char *inherited){
    class_t *cls = (class_t*)malloc(sizeof(class_t));
    cls->type = type;
    cls->inherited = inherited;
    cls->head = NULL;

    return cls;
}

void append_class(class_list_t *cls_list, class_t *cls){
    cls_list->next = cls;
}

Node* new_node(char *type, char *token){
    Node *node = (Node*)malloc(sizeof(Node));

    node->type = type;
    node->token = token;
    node->child = NULL;
    node->next = NULL;

    return node;
}

void append_Node(Node *par, Node *node){
    if(par->child != NULL) par->child = node;
    else{
        Node *tmp = par->child;
        while(tmp->next != NULL){
            tmp = tmp->next;
        }
        tmp->next = node;
    }
}

void show_class(class_t *cls){

}

void show_class_list(class_list_t *class_list)
{
}
