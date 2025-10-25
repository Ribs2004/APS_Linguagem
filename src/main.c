#include <stdio.h>
#include <stdlib.h>

int yyparse(void);
int yylex_destroy(void);
extern FILE *yyin;   // provided by Flex

int main(int argc, char** argv) {
    if (argc >= 2) {
        yyin = fopen(argv[1], "r");
        if (!yyin) {
            perror("Erro ao abrir arquivo");
            return 1;
        }
    } else {
        yyin = stdin; // allow piping or interactive tests
    }

    int ret = yyparse();
    if (ret == 0) {
        printf("OK: sintaxe valida.\n");
    } else {
        printf("Falha na analise sintatica.\n");
    }

    if (yyin && yyin != stdin) fclose(yyin);
    yylex_destroy();
    return ret;
}
