section .data
    ; Constants for benchmarks
    INT_ADD_COUNT    equ 1010
    INT_MUL_COUNT    equ 5000000000    ; 5 × 10^9
    INT_DIV_COUNT    equ 2000000000    ; 2 × 10^9
    MEM_OP_COUNT     equ 5000000000    ; 5 × 10^9
    HD_READ_COUNT    equ 1000000000    ; 10^9
    HD_CHUNK_SMALL   equ 100
    HD_CHUNK_LARGE   equ 10000

    ; Timing variables
    time_start       dq 0
    time_end         dq 0
    time_diff        dq 0

section .bss
    ; Memory for array operations
    array            resq 1000000      ; Reserve space for array operations
    buffer           resb 10000        ; Buffer for file operations

section .text
    global main
    extern printf
    extern fopen
    extern fclose
    extern fread
    extern fwrite
    extern time

main:
    push rbp
    mov rbp, rsp
    
    mov rsp, rbp
    pop rbp
    ret

; Function to get current time
get_time:
    push rbp
    mov rbp, rsp
    
    xor edi, edi        ; NULL argument for time()
    call time
    mov [time_start], rax
    
    mov rsp, rbp
    pop rbp
    ret

; Function to calculate time difference
get_time_diff:
    push rbp
    mov rbp, rsp
    
    xor edi, edi        ; NULL argument for time()
    call time
    mov [time_end], rax
    
    mov rax, [time_end]
    sub rax, [time_start]
    mov [time_diff], rax
    
    mov rsp, rbp
    pop rbp
    ret 