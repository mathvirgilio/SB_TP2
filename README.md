# SB_TP2

nasm -f elf32 procedimentos.s -o procedimentos.o
gcc -m32 -g -o carregador carregador.c procedimentos.o 
(foi necessário: sudo apt install gcc-multilib libc6-dev-i386)

./carregador 125 100 500 4000 300
./carregador 125 100 500 4000 300 20000
./carregador 125 100 500 4000 300 20000 125 30000 345