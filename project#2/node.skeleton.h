/*
 * Copyright 2020-2022. Heekuck Oh, all rights reserved
 * 이 프로그램은 한양대학교 ERICA 소프트웨어학부 재학생을 위한 교육용으로 제작되었다.
 */
#ifndef _NODE_H_
#define _NODE_H_

// 아래 타입과 함수는 극히 일부에 불과하다.
// 학생들은 필요한 타입과 함수 시그니처를 추가한다.


typedef struct _class_list class_list_t;
typedef struct _class class_t;

struct _class_list {
    class_t *class;
    struct _class_list *next;
};

struct _class {
    char *type;
    char *inherited;
    // feature 목록이 들어갈 수 있도록 추가한다
};

void show_class_list(class_list_t *class_list);

#endif
