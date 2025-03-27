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