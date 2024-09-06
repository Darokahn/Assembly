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

.section .data

string:
    .ascii "hello world!!"
    .byte 0

.section .text

main:
    /*
    mov %rdi, %rcx # move the arg count into the counting register
    mov %rsi, %r8 # preserve the value of rsi (I would do this on stack but I am lazy)
    mov $0, %r9 # initialize a counter for argument position
    */

    mov (%rsi), %rsi

    push %rdi

    jmp loop

    loop:
        cmpq $2, (%rsp)       
        jl exit
        je last
        call printarg
        call printspace
        inc %rsi
        subq $1, (%rsp)
        jmp loop
    last:
        call printarg
        call newline
        call exit
    end:
        call exit
    
exit:
    mov $60, %rax
    syscall

print:
    push %rsi
    call strlen
    mov %rax, %rdx
    pop %rsi
    mov $1, %rax
    mov $1, %rdi
    syscall
    ret

printarg:
    call advancestr
    inc %rsi
    call capitalizeString
    call print
    ret

printline:
    call print
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
    push %rsi
    push $32
    mov %rsp, %rsi
    mov $1, %rdx
    call print
    pop %rdx
    pop %rsi
    ret

capitalizeString:
    push %rsi
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
        jne checkLower

    capitalize:
        call capitalizeChar
        inc %rsi
        jmp checkLower
        
    finishCap:
        pop %rsi
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

advancestr:
    start:
        cmpb $0, (%rsi)
        je endAdv
        inc %rsi
        jmp start
    endAdv:
        ret

strlen:
    push %rsi
    call advancestr
    mov %rsi, %rax
    pop %rsi
    sub %rsi, %rax
    ret
