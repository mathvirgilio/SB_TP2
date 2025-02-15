section .data
    msg_count db 'count = %d', 10, 0  ; Mensagem para count
    msg_tam_prog db 'tam_prog = %d', 10, 0  ; Mensagem para tam_prog
    msg_bloco db 'bloco = %d', 10, 0  ; Mensagem para imprimir os elementos do array

section .bss
    resto resd 1  ; Reserva um espaço de 4 bytes (1 palavra) para armazenar o valor de eax


section .text
    global procedimentos
    extern printf

procedimentos:
    push ebp
    mov ebp, esp

    ; Acessando os parâmetros corretamente da pilha
    mov ecx, [ebp+8]   ; count -> Número de elementos no array blocos[]
    mov eax, [ebp+12]   ; tam_prog -> Tamanho do programa
    mov edx, [ebp+16]   ; Ponteiro para o array blocos[]

    ; Salvar o valor de eax em uma variável não inicializada
    mov [resto], eax ; Armazena o valor de eax na variável 'valor_eax'

    ; Salvar o valor de ecx (count) para preservá-lo antes de usá-lo na impressão
    push edx
    push ecx            ; Salva count para preservá-lo
    push eax            ; Argumento para printf (tam_prog)
    push msg_tam_prog   ; Mensagem para printf
    call printf
    add esp, 4          ; Limpeza da pilha após a chamada de printf

    ; Restaura o valor original de ecx (count)
    pop eax
    pop ecx             ; Restaura o valor de count
    pop edx

    ; Chama a função de impressão para count
    push eax
    push edx
    push ecx            ; Argumento para printf (count)
    push msg_count      ; Mensagem para printf
    call printf
    add esp, 4          ; Limpeza da pilha após a chamada de printf
    
    ; Restaura o valor original de ecx (count)
    pop ecx             ; Restaura o valor de count
    pop edx
    pop eax

; Loop para imprimir cada elemento de blocos[]
soma_loop:
    cmp ecx, 0         ; Se count == 0, sai do loop
    je fim

    mov ebx, [edx]     ; Pega próximo valor do array blocos[]
    
    ; Imprime o valor atual de bloco
    push edx
    push eax
    push ecx
    push ebx            ; Argumento para printf (valor de blocos[i])
    push msg_bloco      ; Mensagem para printf
    call printf
    add esp, 4          ; Limpeza da pilha após a chamada de printf

    pop ebx
    pop ecx
    pop eax
    pop edx

    add edx, 4         ; Avança para o próximo valor no array (incrementa o ponteiro de blocos[])
    dec ecx            ; Decrementa contador
    jmp soma_loop      ; Repete loop

fim:
    pop ebp
    ret
