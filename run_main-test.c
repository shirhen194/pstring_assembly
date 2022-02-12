#include <stdio.h>
#include "pstring.h"

extern void func_select(int opt, Pstring *p1, Pstring *p2);

void run_main() {

    Pstring p1; //allocation of 33 bytes- string is in first 32 (255 + \0), length is in 33rd
    Pstring p2; //allocation of another 33 bytes- string is in first 65 (255 + \0), length is in 36th
    int len;
    int opt;

    // initialize first pstring
    scanf("%d", &len);
    scanf("%s", p1.str);
    p1.len = len;

    // initialize second pstring
    scanf("%d", &len);
    scanf("%s", p2.str);
    p2.len = len;

//    // initialize first pstring
//    scanf("%d", &len);
//    scanf("%s", p1.str);
//    p1.str = "len";
//    p1.len = 3;
//
//    // initialize second pstring
//    scanf("%d", &len);
//    scanf("%s", p2.str);
//    p2.len = len;

    // select which function to run
    scanf("%d", &opt);
    func_select(opt, &p1, &p2); //%rdi, %rsi, %rdx

}