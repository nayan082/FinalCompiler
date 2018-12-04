bison -d task.y
flex task.l
gcc lex.yy.c task.tab.c -o a
a