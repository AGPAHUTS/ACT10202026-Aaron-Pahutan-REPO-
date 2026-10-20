section .data
    menu_line   db "------------------------------------", 0xA, 0xD
    len_mline   equ $ - menu_line
    menu_title  db "MENU", 0xA, 0xD
    len_mtitle  equ $ - menu_title
    opt_add     db "[A]dd", 0xA, 0xD
    len_oadd    equ $ - opt_add
    opt_sub     db "[S]ubtract", 0xA, 0xD
    len_osub    equ $ - opt_sub
    opt_mul     db "[M]ultiply", 0xA, 0xD
    len_omul    equ $ - opt_mul
    opt_div     db "[D]ivide", 0xA, 0xD
    len_odiv    equ $ - opt_div
    
    prompt_choice db 0xA, 0xD, "Enter your choice: "
    len_pchoice   equ $ - prompt_choice
    
    prompt_num1   db "Enter first number: "
    len_pnum1     equ $ - prompt_num1
    
    prompt_num2   db "Enter second number: "
    len_pnum2     equ $ - prompt_num2
    
    msg_sum       db "The sum is "
    len_msum      equ $ - msg_sum
    
    msg_sub       db "The difference is "
    len_msub      equ $ - msg_sub
    
    msg_mul       db "The product is "
    len_mmul      equ $ - msg_mul
    
    msg_div       db "The quotient is "
    len_mdiv      equ $ - msg_div
    
    msg_try       db 0xA, 0xD, "Do you want to try again (Y/N): "
    len_mtry      equ $ - msg_try
    
    cls           db 27, '[H', 27, '[2J'
    len_cls       equ $ - cls

section .bss
    choice      resb 2
    num1        resb 2
    num2        resb 2
    res         resb 2
    sum_res     resb 2          ; Buffer for 2-digit sum output
    mul_res     resb 2          ; Buffer for 2-digit multiplication output
    div_res     resb 2          ; Buffer for division output
    try_choice  resb 2

section .text
    global _start

_start:
display_menu:
    mov eax, 4
    mov ebx, 1
    mov ecx, cls
    mov edx, len_cls
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, menu_line
    mov edx, len_mline
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, menu_title
    mov edx, len_mtitle
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, opt_add
    mov edx, len_oadd
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, opt_sub
    mov edx, len_osub
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, opt_mul
    mov edx, len_omul
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, opt_div
    mov edx, len_odiv
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, menu_line
    mov edx, len_mline
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, prompt_choice
    mov edx, len_pchoice
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, choice
    mov edx, 2
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, prompt_num1
    mov edx, len_pnum1
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, num1
    mov edx, 2
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, prompt_num2
    mov edx, len_pnum2
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, num2
    mov edx, 2
    int 0x80

    mov al, [choice]
    
    cmp al, 'A'
    je call_add
    cmp al, 'a'
    je call_add

    cmp al, 'S'
    je call_sub
    cmp al, 's'
    je call_sub

    cmp al, 'M'
    je call_mul
    cmp al, 'm'
    je call_mul

    cmp al, 'D'
    je call_div
    cmp al, 'd'
    je call_div

    jmp exit_program

call_add:
    call add_proc
    jmp ask_try_again

call_sub:
    call sub_proc
    jmp ask_try_again

call_mul:
    call mul_proc
    jmp ask_try_again

call_div:
    call div_proc
    jmp ask_try_again

; =====================================================================
; PROCEDURES SECTION 
; =====================================================================

; --- UNTOUCHED ADDITION ---
add_proc:
    mov al, [num1]
    sub al, '0'
    add al, [num2]
    sub al, '0'         ; Add numbers in AL
    aaa                 ; Module 4 ASCII Adjust After Addition
    
    pushf
    or ax, 3030h        ; Convert both AH and AL bytes to ASCII digits
    popf
    
    mov [sum_res], ah   ; Store tens digit
    mov [sum_res+1], al ; Store ones digit

    mov eax, 4
    mov ebx, 1
    mov ecx, msg_sum
    mov edx, len_msum
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, sum_res
    mov edx, 2          ; Print both characters (tens and ones)
    int 0x80
    ret

; --- UNTOUCHED SUBTRACTION ---
sub_proc:
    mov al, [num1]
    sub al, '0'
    mov bl, [num2]
    sub bl, '0'
    sub al, bl
    add al, '0'
    mov [res], al

    mov eax, 4
    mov ebx, 1
    mov ecx, msg_sub
    mov edx, len_msub
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, res
    mov edx, 1
    int 0x80
    ret

; --- UPDATED MULTIPLICATION USING MODULE 4 AAM ---
mul_proc:
    mov al, [num1]
    sub al, '0'         ; Convert ASCII to decimal
    mov bl, [num2]
    sub bl, '0'         ; Convert ASCII to decimal
    mul bl              ; Multiply AL by BL (Result in AX)
    aam                 ; Module 4: ASCII Adjust After Multiplication (AH=tens, AL=ones)
    
    pushf
    or ax, 3030h        ; Convert AH and AL into valid ASCII characters
    popf
    
    mov [mul_res], ah   ; Store tens digit
    mov [mul_res+1], al ; Store ones digit

    mov eax, 4
    mov ebx, 1
    mov ecx, msg_mul
    mov edx, len_mmul
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, mul_res
    mov edx, 2          ; Print both digits
    int 0x80
    ret

; --- UPDATED DIVISION ---
div_proc:
    mov ah, 0           ; Clear high byte of dividend
    mov al, [num1]
    sub al, '0'         ; Convert ASCII to decimal
    mov bl, [num2]
    sub bl, '0'         ; Convert ASCII to decimal
    div bl              ; Divide AX by BL (Quotient in AL, Remainder in AH)
    
    add al, '0'         ; Convert quotient to ASCII
    mov [div_res], al

    mov eax, 4
    mov ebx, 1
    mov ecx, msg_div
    mov edx, len_mdiv
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, div_res
    mov edx, 1
    int 0x80
    ret

ask_try_again:
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_try
    mov edx, len_mtry
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, try_choice
    mov edx, 2
    int 0x80

    mov al, [try_choice]
    cmp al, 'Y'
    je display_menu
    cmp al, 'y'
    je display_menu

exit_program:
    mov eax, 1
    xor ebx, ebx
    int 0x80