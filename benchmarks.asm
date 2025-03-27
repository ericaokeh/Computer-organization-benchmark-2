section .data
    ; Constants for benchmarks
    INT_ADD_COUNT    equ 1010
    INT_MUL_COUNT    equ 5000000000    ; 5 × 10^9
    INT_DIV_COUNT    equ 2000000000    ; 2 × 10^9
    MEM_OP_COUNT     equ 5000000000    ; 5 × 10^9
    HD_READ_COUNT    equ 1000000000    ; 10^9
    HD_CHUNK_SMALL   equ 100
    HD_CHUNK_LARGE   equ 10000
    HD_CHUNK_MEDIUM  equ 1024

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
    
    ; Call memory benchmark
    call memory_benchmark
    
    ; Call hard drive benchmark 1
    call hd_benchmark1
    
    ; Call hard drive benchmark 2
    call hd_benchmark2
    
    ; Call hard drive benchmark 3
    call hd_benchmark3
    
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

; Memory operation benchmark
memory_benchmark:
    push rbp
    mov rbp, rsp
    
    ; Get start time
    call get_time
    
    ; Memory Read
    mov rcx, MEM_OP_COUNT
    mov rsi, array
read_loop:
    mov eax, [rsi]
    add rsi, 4
    dec rcx
    jnz read_loop
    
    ; Memory Write
    mov rcx, MEM_OP_COUNT
    mov rdi, array
write_loop:
    mov [rdi], eax
    add rdi, 4
    dec rcx
    jnz write_loop
    
    ; Get end time and print
    call get_time_diff
    lea rdi, [msg_mem_bench]
    call printf
    
    mov rsp, rbp
    pop rbp
    ret

; Hard drive benchmark 1 (100-byte chunks)
hd_benchmark1:
    push rbp
    mov rbp, rsp
    
    ; Get start time
    call get_time
    
    ; Open file for reading
    lea rdi, [filename]
    lea rsi, [mode_read]
    call fopen
    
    ; Read file in small chunks
    mov rcx, HD_READ_COUNT
    mov rsi, buffer
read_small_loop:
    mov rdi, rsi
    mov rdx, HD_CHUNK_SMALL
    mov rsi, rax
    call fread
    add rsi, HD_CHUNK_SMALL
    sub rcx, HD_CHUNK_SMALL
    jg read_small_loop
    
    ; Close file
    mov rdi, rax
    call fclose
    
    ; Open file for writing
    lea rdi, [filename]
    lea rsi, [mode_write]
    call fopen
    
    ; Write file in small chunks
    mov rcx, HD_READ_COUNT
    mov rsi, buffer
write_small_loop:
    mov rdi, rax
    mov rdx, HD_CHUNK_SMALL
    call fwrite
    add rsi, HD_CHUNK_SMALL
    sub rcx, HD_CHUNK_SMALL
    jg write_small_loop
    
    ; Close file
    mov rdi, rax
    call fclose
    
    ; Get end time and print
    call get_time_diff
    lea rdi, [msg_hd1_bench]
    call printf
    
    mov rsp, rbp
    pop rbp
    ret

; Hard drive benchmark 2 (1KB chunks)
hd_benchmark2:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 32

    ; Record start time
    call    get_time
    mov     [rbp-8], rax    ; start_time

    ; Open file for reading
    lea     rdi, [rel filename]
    lea     rsi, [rel mode_read]
    call    fopen
    mov     [rbp-16], rax   ; file handle

    ; Read file in 1KB chunks
    mov     rcx, HD_READ_COUNT
.read_loop:
    push    rcx
    mov     rdi, [rbp-16]   ; file handle
    lea     rsi, [rel buffer]
    mov     rdx, 1          ; size
    mov     rcx, HD_CHUNK_MEDIUM  ; count (1KB)
    call    fread
    pop     rcx
    loop    .read_loop

    ; Close file
    mov     rdi, [rbp-16]
    call    fclose

    ; Open file for writing
    lea     rdi, [rel filename]
    lea     rsi, [rel mode_write]
    call    fopen
    mov     [rbp-16], rax   ; file handle

    ; Write file in 1KB chunks
    mov     rcx, HD_READ_COUNT
.write_loop:
    push    rcx
    mov     rdi, [rbp-16]   ; file handle
    lea     rsi, [rel buffer]
    mov     rdx, 1          ; size
    mov     rcx, HD_CHUNK_MEDIUM  ; count (1KB)
    call    fwrite
    pop     rcx
    loop    .write_loop

    ; Close file
    mov     rdi, [rbp-16]
    call    fclose

    ; Record end time and calculate duration
    call    get_time
    mov     rdi, [rbp-8]    ; start_time
    mov     rsi, rax        ; end_time
    call    get_time_diff
    mov     [rbp-24], rax   ; duration

    ; Print benchmark results
    lea     rdi, [rel msg_hd2_bench]
    mov     rsi, [rbp-24]
    xor     rax, rax
    call    printf

    mov     rsp, rbp
    pop     rbp
    ret

; Hard drive benchmark 3 (10KB chunks)
hd_benchmark3:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 32

    ; Record start time
    call    get_time
    mov     [rbp-8], rax    ; start_time

    ; Open file for reading
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