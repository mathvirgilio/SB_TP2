# SB_TP2

#Compilar código em Assembly (IA-32 )
nasm -f elf32 procedimentos.s -o procedimentos.o

#Compilar código em C e ligar com o obj do Assembly:
gcc -m32 -g -o carregador carregador.c procedimentos.o 
OBS: Foi necessário instalar: sudo apt install gcc-multilib libc6-dev-i386


#Executar código em C
./carregador 125 100 500 4000 300
./carregador 125 100 500 4000 300 20000         #Dará mensagem de falta de parâmetros
./carregador 1250 100 500 4000 300 20000 500
./carregador 1250 100 500 4000 300 20000 250

Formato da saída:

    - Memória do programa restante (não distribuida entre os blocos) printada antes de cada bloco percorrido;
    - Endereço inicial do bloco, seguindo a ordem do comando;
    - Se toda memória não tiver sido distribuida ainda, endereço final do bloco.

