section .text
    global calcula

calcula:
    push ebp
    mov ebp, esp

    mov ecx, [ebp+8]   ; count -> Número de elementos no array blocos[]
    mov eax, [ebp+12]  ; tam_prog -> Tamanho do programa
    mov edx, [ebp+16]  ; Ponteiro para o array blocos[]

    add eax, ecx       ; Soma 'count' ao 'tam_prog'

soma_loop:
    cmp ecx, 0         ; Se count == 0, sai do loop
    je fim

    mov ebx, [edx]     ; Pega próximo valor do array blocos[]
    add eax, ebx       ; Soma ao acumulador
    add edx, 4         ; Avança para o próximo valor no array
    dec ecx            ; Decrementa contador
    jmp soma_loop      ; Repete loop

fim:
    pop ebp
    ret
