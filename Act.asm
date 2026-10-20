; =====================================================================
; NASM32 Assembly Calculator Program with Procedures and User Input
; Strictly adhering to concepts from Modules 1 to 5
; =====================================================================

section .data
    ; Menu display strings and length calculations using $ counter
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
    
    ; User interaction prompts
    prompt_choice db 0xA, 0xD, "Enter your choice: "
    len_pchoice   equ $ - prompt_choice
    
    prompt_num1   db "Enter first number: "
    len_pnum1     equ $ - prompt_num1
    
    prompt_num2   db "Enter second number: "
    len_pnum2     equ $ - prompt_num2
    
    ; Result messages
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
    
    ; ANSI escape sequence for clearing the screen
    cls           db 27, '[H', 27, '[2J'
    len_cls       equ $ - cls

section .bss
    ; Uninitialized storage space for user inputs and results
    choice      resb 2
    num1        resb 2
    num2        resb 2
    res         resb 2
    try_choice  resb 2

section .text
    global _start

_start:
    ; =====================================================================
    ; MAIN MENU DISPLAY SECTION
    ; Clears the screen and displays menu options using sys_write (syscall 4)
    ; =====================================================================
display_menu:
    ; Clear screen command
    mov eax, 4
    mov ebx, 1
    mov ecx, cls
    mov edx, len_cls
    int 0x80

    ; Print top separator line
    mov eax, 4
    mov ebx, 1
    mov ecx, menu_line
    mov edx, len_mline
    int 0x80

    ; Print MENU header
    mov eax, 4
    mov ebx, 1
    mov ecx, menu_title
    mov edx, len_mtitle
    int 0x80

    ; Print Addition option
    mov eax, 4
    mov ebx, 1
    mov ecx, opt_add
    mov edx, len_oadd
    int 0x80

    ; Print Subtraction option
    mov eax, 4
    mov ebx, 1
    mov ecx, opt_sub
    mov edx, len_osub
    int 0x80

    ; Print Multiplication option
    mov eax, 4
    mov ebx, 1
    mov ecx, opt_mul
    mov edx, len_omul
    int 0x80

    ; Print Division option
    mov eax, 4
    mov ebx, 1
    mov ecx, opt_div
    mov edx, len_odiv
    int 0x80

    ; Print bottom separator line
    mov eax, 4
    mov ebx, 1
    mov ecx, menu_line
    mov edx, len_mline
    int 0x80

    ; =====================================================================
    ; USER INPUT SECTION (MENU CHOICE)
    ; Prompts and reads the menu selection using sys_read (syscall 3)
    ; =====================================================================
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt_choice
    mov edx, len_pchoice
    int 0x80

    mov eax, 3
    mov ebx, 0          ; Standard input (stdin)
    mov ecx, choice
    mov edx, 2
    int 0x80

    ; =====================================================================
    ; NUMBER INPUT SECTION
    ; Prompts and reads the first and second numbers from the keyboard
    ; =====================================================================
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

    ; =====================================================================
    ; BRANCHING / CONDITIONAL DECISION SECTION
    ; Compares user choice against expected letters using CMP and JE
    ; =====================================================================
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
    call add_proc       ; Calls addition procedure
    jmp ask_try_again

call_sub:
    call sub_proc       ; Calls subtraction procedure
    jmp ask_try_again

call_mul:
    call mul_proc       ; Calls multiplication procedure
    jmp ask_try_again

call_div:
    call div_proc       ; Calls division procedure
    jmp ask_try_again

    ; =====================================================================
    ; PROCEDURES SECTION (MODULE 5 CONCEPT)
    ; Encapsulates arithmetic operations and output formatting
    ; =====================================================================

add_proc:
    mov al, [num1]
    sub al, '0'         ; Convert ASCII to decimal
    mov bl, [num2]
    sub bl, '0'         ; Convert ASCII to decimal
    add al, bl          ; Perform addition
    add al, '0'         ; Convert decimal back to ASCII
    mov [res], al

    mov eax, 4
    mov ebx, 1
    mov ecx, msg_sum
    mov edx, len_msum
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, res
    mov edx, 1
    int 0x80
    ret

sub_proc:
    mov al, [num1]
    sub al, '0'         ; Convert ASCII to decimal
    mov bl, [num2]
    sub bl, '0'         ; Convert ASCII to decimal
    sub al, bl          ; Perform subtraction
    add al, '0'         ; Convert decimal back to ASCII
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

mul_proc:
    mov al, [num1]
    sub al, '0'         ; Convert ASCII to decimal
    mov bl, [num2]
    sub bl, '0'         ; Convert ASCII to decimal
    mul bl              ; Multiply AL by BL (Result in AX)
    add al, '0'         ; Convert decimal back to ASCII
    mov [res], al

    mov eax, 4
    mov ebx, 1
    mov ecx, msg_mul
    mov edx, len_mmul
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, res
    mov edx, 1
    int 0x80
    ret

div_proc:
    mov ah, 0           ; Clear high byte of dividend
    mov al, [num1]
    sub al, '0'         ; Convert ASCII to decimal
    mov bl, [num2]
    sub bl, '0'         ; Convert ASCII to decimal
    div bl              ; Divide AX by BL (Quotient in AL)
    add al, '0'         ; Convert decimal back to ASCII
    mov [res], al

    mov eax, 4
    mov ebx, 1
    mov ecx, msg_div
    mov edx, len_mdiv
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, res
    mov edx, 1
    int 0x80
    ret

    ; =====================================================================
    ; TRY AGAIN SECTION
    ; Asks user if they wish to repeat the program or exit
    ; =====================================================================
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
    je display_menu     ; Loop back to menu and clear screen
    cmp al, 'y'
    je display_menu     ; Loop back to menu and clear screen

    ; =====================================================================
    ; PROGRAM TERMINATION SECTION
    ; Exits the program cleanly using sys_exit (syscall 1)
    ; =====================================================================
exit_program:
    mov eax, 1
    xor ebx, ebx
    int 0x80
