CC      := gcc
LEX     := flex
YACC    := bison
CFLAGS  := -O2 -Wall -Wextra
LDFLAGS := -lfl

all: parser

parser: parser.tab.c lex.yy.c main.o
	$(CC) $(CFLAGS) -o $@ parser.tab.c lex.yy.c main.o $(LDFLAGS)

parser.tab.c parser.tab.h: parser.y
	$(YACC) -d -Wall parser.y

lex.yy.c: scanner.l parser.tab.h
	$(LEX) --header-file=lex.yy.h scanner.l

main.o: main.c
	$(CC) $(CFLAGS) -c main.c

clean:
	rm -f parser *.o parser.tab.* lex.yy.*

.PHONY: all clean
