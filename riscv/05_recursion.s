.globl main

factorial: 
    addi sp, sp, -8 # alloc for my a0, ra
    sw a0, 4(sp) 
    sw ra, 0(sp) 

    addi t0, zero, 1 # temporary = 1 

    bgt a0, t0, else # if n > 1 go to else
    addi a0, zero, 1 # otherwise return 1 
    addi sp, sp, 8 # restore sp, no changes to the retisters 
    jr ra 
else: 
    addi a0, a0, -1 # n = n - 1 
    jal factorial

    lw t1, 4(sp) # restore my argument in temp
    lw ra, 0(sp) 
    addi sp, sp, 8 # dealloc 

    mul a0, t1, a0 # a0 = <my arg> * <return val>, a0 is returned to the parent 
    jr ra


main: 
    li a0, 3
    jal factorial


