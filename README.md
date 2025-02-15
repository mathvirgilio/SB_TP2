# SB_TP2

nasm -f elf32 procedimentos.s -o calcula.o
gcc -m32 -o carregador carregador.c calcula.o

./carregador 125 100 500 4000 300
./carregador 125 100 500 4000 300 20000
./carregador 125 100 500 4000 300 20000 125 30000 345
