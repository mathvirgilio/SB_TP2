section .data
    msg_count db 'count = %d', 10, 0  ; Mensagem para count
    msg_tam_prog db 'tam_prog = %d', 10, 0  ; Mensagem para tam_prog
    msg_bloco db 'bloco = %d', 10, 0  ; Mensagem para imprimir os elementos do array
    bloco dd 0, 0, 0, 0
    buffer db '0000000000', 0  ; Buffer para armazenar a string (máx. 10 dígitos + NULL)
    newline db 10                     ; Nova linha (LF)


section .bss
    resto resd 1  ; Reserva um espaço de 4 bytes (1 palavra) para armazenar o valor de eax
    num resb 10   ; Buffer para armazenar a string resultant


section .text
    global procedimentos
    extern printf
    ;sub esi, esi

procedimentos:
    push ebp
    mov ebp, esp

    ; Acessando os parâmetros corretamente da pilha
    mov ecx, [ebp+8]   ; count -> Número de elementos no array blocos[]
    mov eax, [ebp+12]   ; tam_prog -> Tamanho do programa
    mov edx, [ebp+16]   ; Ponteiro para o array blocos[]

    ; Salvar o valor de eax em uma variável não inicializada
    mov [resto], eax ; Armazena o valor de eax na variável 'valor_eax'
    mov esi, 0


loop:
    cmp ecx, 0         ; Se count == 0, sai do loop
    je fim

    mov eax, [edx]
cont2:
    push eax
    push ebx
    push ecx
    push edx
    jmp printar_mem2
ret2:
    pop edx
    pop ecx
    pop ebx
    pop eax

    mov eax, [resto]
    cmp eax, 0
    je fim

    mov ebx, [edx + 4]     ; Pega segundo elemento do bloco

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

    mov [bloco + esi*4], ebx

    add edx, 8         ; Avança para o próximo valor bloco (incrementa o ponteiro de blocos[])
    sub ecx, 2         ; Decrementa o contador duas vezes
    inc esi            ; Incrementa contador de laço
    jmp loop      ; Repete loop

espaco_suficiente:
    mov eax, [edx]
    add eax, [resto]
    add [bloco + esi*4], eax
    mov ebx, eax
    mov eax, 0
    mov [resto], eax
    jmp cont

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
