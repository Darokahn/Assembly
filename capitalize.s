.globl main
.section .note.GNU-stack,"",@progbits

.macro funcstart
    push %rbp
    mov %rsp, %rbp
.endm

.macro funcend
    mov %rbp, %rsp
    pop %rbp
.endm

.section .text

main:
    mov %rdi, %rcx
    call mainloop
    call exit

mainloop:
    add $8, %rsi
    push %rsi
    
    call printarg

    dec %rcx
    pop %rsi

    cmp $0, %rcx
    je break

    break:
        ret

exit:
    mov $60, %rax
    syscall

print:
    mov $1, %rax
    mov $1, %rdi
    syscall
    ret

printline:
    push %rsi
    call strlen
    mov %rax, %rdx
    pop %rsi
    mov $1, %rax
    mov $1, %rdi
    syscall
    call newline
    ret

newline:
    mov $1, %rdx
    push $10
    mov %rsp, %rsi
    call print
    pop %rdx
    ret

printspace:
    push $32
    mov %rsp, %rsi
    mov $1, %rdx
    call print
    pop %rdx
    ret

printarg:
    funcstart
    push (%rsi)
    mov (%rsp), %rsi
    call capitalizeString
    pop %rsi
    funcend
    ret

capitalizeString:
    jmp checkLower
    checkLower:
        call isLowerLetter
        cmp $1, %rax
        je capitalize
        jne checkEnd

    checkEnd:
        cmpb $0, (%rsi)
        je finishCap
        inc %rsi
        jne capitalizeString

    capitalize:
        call capitalizeChar
        inc %rsi
        jmp capitalizeString
        
    finishCap:
        ret

capitalizeChar:
    subq $32, (%rsi)

isLowerLetter:
    cmpb $'a', (%rsi)
    jb lowerFalse

    cmpb $'z', (%rsi)
    ja lowerFalse

    jmp lowerTrue

    lowerTrue:
        mov $1, %rax
        ret

    lowerFalse:
        mov $0, %rax
        ret

strlen:
    push %rsi
    start:
    cmpb $0, (%rsi)
    je endLen
    inc %rsi
    jmp start
    endLen:
        mov %rsi, %rax
        pop %rsi
        sub %rsi, %rax
        ret
