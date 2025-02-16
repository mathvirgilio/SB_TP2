section .data

    msg_count db 'count = %d', 10, 0  ; Mensagem para count APAGAAAAAAAAAAAAAAAAAR
    msg_tam_prog db 'tam_prog = %d', 10, 0  ; Mensagem para tam_prog APAGAAAAAAAAAAAAAAAAAR
    msg_bloco db 'bloco = %d', 10, 0  ; Mensagem para imprimir os elementos do array APAGAAAAAAAAAAAAAAAAAR

    bloco dd 0, 0, 0, 0 ;Endereço final que o programa ocupa no bloco de memória i
    buffer db '0000000000', 0  ; Buffer para armazenar a string (máx. 10 dígitos + NULL)
    newline db 10                     ; Quebra de linha

section .bss
    resto resd 1  ; Quantidade de memória restante do programa para ser guardada
    num resb 10   ; Buffer para armazenar a string resultant para função de printar

section .text
    global procedimentos
    extern printf ; APAGAAAAAAAAAAAAAAAAAR

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

    mov eax, [edx]

cont2:       
    push eax
    push ebx
    push ecx
    push edx
    jmp printar_mem2  ; Printar posição de início da memória (função própria)
ret2:
    pop edx
    pop ecx
    pop ebx
    pop eax

    ;Quando a memória restante do programa for zero, encerrar o programa
    mov eax, [resto]
    cmp eax, 0
    je fim

    ;Comparação resto da memória do programa em relação ao tamanho do blobo
    mov ebx, [edx + 4]     ; Pega segundo elemento do bloco, o tamanho dele
    cmp ebx, eax
    jg espaco_suficiente

    sub eax, ebx
    mov [resto], eax
    add ebx, [edx]

cont:
    push eax
    push ebx
    push ecx
    push edx
    mov eax, ebx
    jmp printar_mem
ret:
    pop edx
    pop ecx
    pop ebx
    pop eax

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
    jmp cont ;Verificar se deveria ser cont2

printar_mem:
    mov edi, num + 9   ; Aponta para o final do buffer (última posição antes do NULL)
    mov byte [edi], 0  ; Adiciona terminador NULL
    jmp convert_loop

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

    jmp ret

printar_mem2:
    mov edi, num + 9   ; Aponta para o final do buffer (última posição antes do NULL)
    mov byte [edi], 0  ; Adiciona terminador NULL
    jmp convert_loop2

convert_loop2:
    mov edx, 0         ; Zerar EDX para divisão correta
    mov ecx, 10        ; Divisor = 10
    div ecx            ; EAX /= 10, EDX = resto (dígito atual)
    
    add dl, '0'        ; Converter o número para caractere ASCII
    dec edi            ; Mover ponteiro para frente
    mov [edi], dl      ; Armazenar caractere no buffer
    
    test eax, eax      ; Verifica se EAX ainda tem dígitos
    jnz convert_loop2   ; Se sim, continuar loop

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

    jmp ret2

fim:    
    pop ebp
    ret
