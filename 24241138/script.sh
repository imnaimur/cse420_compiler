#!/bin/bash

yacc -d -y --debug --verbose 24241138.y
echo 'Generated the parser C file as well the header file'
g++-14 -w -c -o y.o y.tab.c
echo 'Generated the parser object file'
flex 24241138.l
echo 'Generated the scanner C file'
g++-14 -fpermissive -w -c -o l.o lex.yy.c
# if the above command doesn't work try g++ -fpermissive -w -c -o l.o lex.yy.c
echo 'Generated the scanner object file'
g++-14 y.o l.o
echo 'All ready, running'
./a.exe input.txt