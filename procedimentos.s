section .data
    bloco dd 0, 0, 0, 0 ;Endereço final que o programa ocupa no bloco de memória i
    buffer db '0000000000', 0  ; Buffer para armazenar a string (máx. 10 dígitos + NULL)
    newline db 10                     ; Quebra de linha
    msg_inicio_bloco db "Endereço de início do bloco: ", 0
    tam_msg_inicio_bloco EQU $-msg_inicio_bloco
    msg_final_bloco db "Endereço de final do bloco: ", 0
    tam_msg_final_bloco EQU $-msg_final_bloco
    numero db '1' '2' '3' '4', 0
    msg_resto db "Memória do programa restante: ", 0
    tam_msg_resto EQU $-msg_resto

    msg_final1 db "Toda a memória distribuída!", 0
    tam_msg_final1 EQU $-msg_final1

    msg_final2 db "Não há memória o sufiente nos blocos!", 0
    tam_msg_final2 EQU $-msg_final2

section .bss
    resto resd 1  ; Quantidade de memória restante do programa para ser guardada
    num resb 10   ; Buffer para armazenar a string resultant para função de printar

section .text
    global procedimentos

procedimentos:
    ;Recebendo elementos na pilha
    push ebp ; Salva endereço de retorno
    mov ebp, esp ;Passa pilha para ebp

    ; Acessando os parâmetros corretamente da pilha
    mov ecx, [ebp+8]    ; Contador -> Número de elementos no array blocos[]
    mov eax, [ebp+12]   ; tam_prog -> Tamanho do programa
    mov edx, [ebp+16]   ; Ponteiro para o array blocos[]

    ; Salvar o valor de eax (tam_prog) em uma variável não inicializada
    mov [resto], eax ; Armazena o valor de eax na variável 'resto'
    mov esi, 0       ; Contador do número de iterações

loop:
    cmp ecx, 0 ; Se count == 0, sai do loop
    je fim

    mov eax, [resto] 
    call printar_msg_resto
    call printar_mem

    mov eax, [edx] ; Recebe endereço inicial do bloco de memória
    call printar_msg_inicio
    ;Printar elemento de início da memória
    call printar_mem

    ;Quando a memória restante do programa for zero, encerrar o programa
    mov eax, [resto]
    cmp eax, 0
    je fim

    ;Comparação resto da memória do programa em relação ao tamanho do blobo
    mov ebx, [edx + 4]     ; Pega segundo elemento do bloco, o tamanho dele
    cmp ebx, eax
    jg espaco_suficiente

    ;Caso tenha sido preenchido todo espaço da memória do bloco
    sub eax, ebx
    mov [resto], eax
    add ebx, [edx]

    ;Printar endereço final do bloco de memória

cont:
    call printar_msg_final
    mov eax, ebx
    call printar_mem

    ; Retirar 1 do ebx
    mov [bloco + esi*4], ebx ;Salva endereço final

    add edx, 8         ; Avança para o próximo bloco (incrementa o ponteiro de blocos[])
    sub ecx, 2         ; Decrementa o contador duas vezes
    inc esi            ; Incrementa contador de laço
    jmp loop      ; Repete loop

espaco_suficiente:
    mov eax, [edx] ;Salva início da memória
    add eax, [resto] ;Soma o tamanho do código restante

    ;Retirar 1 do eax

    add [bloco + esi*4], eax    ;Salvo no array bloco referente a sua posição
    mov ebx, eax ; 
    mov eax, 0 ; Zerar o eax
    mov [resto], eax
    jmp cont

printar_mem:
    push eax
    push ebx
    push ecx
    push edx
    mov edi, num + 9   ; Aponta para o final do buffer (última posição antes do NULL)
    mov byte [edi], 0  ; Adiciona terminador NULL

convert_loop:
    mov edx, 0         ; Zerar EDX para divisão correta
    mov ecx, 10        ; Divisor = 10
    div ecx            ; EAX /= 10, EDX = resto (dígito atual)
    
    add dl, '0'        ; Converter o número para caractere ASCII
    dec edi            ; Mover ponteiro para frente
    mov [edi], dl      ; Armazenar caractere no buffer
    
    test eax, eax      ; Verifica se EAX ainda tem dígitos
    jnz convert_loop   ; Se sim, continuar loop

    ; Agora, EDI aponta para o início da string convertida.
    
    ; Exibir número convertido na saída padrão (opcional)
    mov eax, 4        ; syscall: sys_write
    mov ebx, 1        ; saída padrão (stdout)
    mov ecx, edi      ; ponteiro para string convertida
    ;mov edx, num + 10 - edi  ; tamanho da string
    mov edx, 0
    add edx, num
    add edx, 10
    sub edx, edi
    int 0x80

    ; Exibir nova linha
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    pop edx
    pop ecx
    pop ebx
    pop eax

    ret

printar_msg_inicio:
    push eax
    push ebx
    push ecx
    push edx

    mov eax, 4
    mov ebx, 1
    mov ecx, msg_inicio_bloco
    mov edx, tam_msg_inicio_bloco
    int 0x80

    pop edx
    pop ecx
    pop ebx
    pop eax
    ret

printar_msg_final:
    push eax
    push ebx
    push ecx
    push edx

    mov eax, 4
    mov ebx, 1
    mov ecx, msg_final_bloco
    mov edx, tam_msg_final_bloco
    int 0x80

    pop edx
    pop ecx
    pop ebx
    pop eax
    ret

printar_msg_resto:
    push eax
    push ebx
    push ecx
    push edx

    mov eax, 4
    mov ebx, 1
    mov ecx, msg_resto
    mov edx, tam_msg_resto
    int 0x80

    pop edx
    pop ecx
    pop ebx
    pop eax
    ret

printar_msg_final1:
    push eax
    push ebx
    push ecx
    push edx

    mov eax, 4
    mov ebx, 1
    mov ecx, msg_final1
    mov edx, tam_msg_final1
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80


    pop edx
    pop ecx
    pop ebx
    pop eax
    ret

printar_msg_final2:
    push eax
    push ebx
    push ecx
    push edx

    mov eax, 4
    mov ebx, 1
    mov ecx, msg_final2
    mov edx, tam_msg_final2
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80


    pop edx
    pop ecx
    pop ebx
    pop eax
    ret

fim:
    cmp byte [resto], 0
    je op2
    call printar_msg_final2
    pop ebp
    ret
op2:
    call printar_msg_final1
    pop ebp
    ret
