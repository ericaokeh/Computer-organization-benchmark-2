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