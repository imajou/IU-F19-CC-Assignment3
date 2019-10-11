#!/usr/bin/env sh

bison -d toy.y
flex toy.l
gcc -o toy.out toy.tab.c lex.yy.c