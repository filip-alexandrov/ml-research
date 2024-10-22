# many sections, etc not supported by the venus simulator (bare metal sim)
.globl main # entrypoint 
.equ N, 5 # const value 

.data # global data segment 
A: .word 5, 42, -88, -5033, 720, 314 # array of words 
str1: .string "RISC-V"
.align 2 # align on 2^2 byte boundary (string aligned on 1 byte) 
B: .word 0x32A

# .bss # global data init to 0 
C: .space 4 # reserve N = 4 bytes to store the data
D: .space 1 # reserve 1 byte

.balign 4 # align next instruction on 4-byte boundary (performance, caching, etc) 

# all instructions size = word (32 bit) auto align in mem 
.text # code
main: 
    la t0, A # t0 = Address of A, load address
    la t1, str1
    la t2, B
    la t3, C
    la t4, D 

    lw t5, N * 4 (t0) # t5 = A[N] = A[5] = 720, N*4 executed first
    lw t6, 0(t2) # t6 = B = 810 

    add t5, t5, t6 # 720 * 810 

    sw t5, 0(t3) # C = 1530 
    lb t5, N-1(t1) # t5 = str1[N - 1] = str1[4] = "-"
    sb t5, 0(t4) # D = strl[N-1] store byte

    la t5, str2 # t5 = addr of str2
    lb t6, 8(t5) # load byte: t6 = str2[8] = 'r' 
    sb t6, 0(t1) # str1[0] = 'r', store byte

    jr ra # return


.section .rodata
str2: .string "Hello world!" 
.end # end of assembly file
