#include <stdio.h>
#include <stdlib.h>

extern int procedimentos(int count, int tam_prog, int *blocos);

int main(int argc, char *argv[]) {
    //Checar quantidade de parâmetros passada na chamada
    if (argc < 2) {
        printf("Formato não aceito. Faltam todos os parâmetros.\n");
        return 1;
    } else if (argc < 3) {
        printf("Formato não aceito. Faltam blocos de memória.\n");
        return 1;
    } else if (argc > 10) {
        printf("Formato não aceito. Mais parâmetros que o aceito.\n");
        return 1;
    } else if ((argc - 2) % 2 != 0) {
        printf("Formato não aceito. Blocos de memória incompletos.\n");
        return 1;
    } 

    int tam_prog = atoi(argv[1]); //Tamanho do programa
    int count = argc - 2;  // Número total de argumentos fornecidos (sem o tamanho do código) 
    int blocos[8] = {0, 0, 0, 0, 0, 0, 0, 0};

    for (int i = 0; i < count; i++) {
        blocos[i] = atoi(argv[i + 2]);
    }
    //printf("Tam_prog = %d, Count = %d\n", tam_prog, count);
    // Chamar função Assembly passando a quantidade de parâmetros, o tamanho do código e o array
    int resultado = procedimentos(count, tam_prog, blocos);

    //printf("Resultado: %d\n", resultado);

    return 0;
}
