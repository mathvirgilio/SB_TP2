# SB_TP2

#Compilar código em Assembly (IA-32 )
nasm -f elf32 procedimentos.s -o procedimentos.o

#Compilar código em C e ligar com o obj do Assembly:
gcc -m32 -g -o carregador carregador.c procedimentos.o 
OBS: Foi necessário instalar: sudo apt install gcc-multilib libc6-dev-i386


#Executar código em C
./carregador 125 100 500 4000 300
./carregador 125 100 500 4000 300 20000
./carregador 125 100 500 4000 300 20000 125 30000 345


LEMBRETES:
    - Apagar printf
    - Tirar 1 da memória
    - Adicionar string que informem "Início da memória do bloco" e "Final da memória do bloco"
    - Indicar qual bloco: registrador esi
    - Adicionar se os blocos não memória o suficiente (checar variável resto)