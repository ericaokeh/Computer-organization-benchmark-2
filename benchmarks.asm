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

    ; Output messages
    msg_int_bench    db "32-bit Integer Operation Benchmark Time: ", 0
    msg_float_bench  db "64-bit Floating Point Operation Benchmark Time: ", 0
    msg_mem_bench    db "Memory Operation Benchmark Time: ", 0
    msg_hd1_bench    db "Hard Drive Benchmark 1 Time: ", 0
    msg_hd2_bench    db "Hard Drive Benchmark 2 Time: ", 0
    msg_seconds      db " seconds", 10, 0

    ; File operations
    filename         db "benchmark_data.bin", 0
    mode_write       db "w", 0
    mode_read        db "r", 0

    ; Floating point constants
    one             dq 1.0
    two             dq 2.0
    thousand        dq 1000.0

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
    
    ; Call integer benchmark
    call integer_benchmark
    
    ; Call floating point benchmark
    call float_benchmark
    
    mov rsp, rbp
    pop rbp
    ret

; Integer operation benchmark
integer_benchmark:
    push rbp
    mov rbp, rsp
    
    ; Get start time
    call get_time
    
    ; Integer Addition
    mov ecx, INT_ADD_COUNT
    mov eax, 1
    mov ebx, 2
add_loop:
    add eax, ebx
    dec ecx
    jnz add_loop
    
    ; Integer Multiplication
    mov ecx, INT_MUL_COUNT
    mov eax, 1
    mov ebx, 2
mul_loop:
    imul eax, ebx
    dec ecx
    jnz mul_loop
    
    ; Integer Division
    mov ecx, INT_DIV_COUNT
    mov eax, 1000
    mov ebx, 2
div_loop:
    cdq
    idiv ebx
    dec ecx
    jnz div_loop
    
    ; Get end time and print
    call get_time_diff
    lea rdi, [msg_int_bench]
    call printf
    
    mov rsp, rbp
    pop rbp
    ret

; Floating point operation benchmark
float_benchmark:
    push rbp
    mov rbp, rsp
    
    ; Get start time
    call get_time
    
    ; Floating Point Addition
    mov ecx, INT_ADD_COUNT
    movsd xmm0, qword [one]
    movsd xmm1, qword [two]
fadd_loop:
    addsd xmm0, xmm1
    dec ecx
    jnz fadd_loop
    
    ; Floating Point Multiplication
    mov ecx, INT_MUL_COUNT
    movsd xmm0, qword [one]
    movsd xmm1, qword [two]
fmul_loop:
    mulsd xmm0, xmm1
    dec ecx
    jnz fmul_loop
    
    ; Floating Point Division
    mov ecx, INT_DIV_COUNT
    movsd xmm0, qword [thousand]
    movsd xmm1, qword [two]
fdiv_loop:
    divsd xmm0, xmm1
    dec ecx
    jnz fdiv_loop
    
    ; Get end time and print
    call get_time_diff
    lea rdi, [msg_float_bench]
    call printf
    
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