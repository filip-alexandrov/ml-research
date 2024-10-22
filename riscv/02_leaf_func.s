main: 
    # temp info 
    mv t0, zero 
    mv t1, zero 

    # up to 8 arguments stored in registers a0 - a7
    addi a0, zero, 2 # argument 0 = 2 
    addi a1, zero, 3 # argument 1 = 3 
    addi a2, zero, 4 # argument 2 = 4 
    addi a3, zero, 5 # argument 3 = 5 

    # save my non-preserved regs
    addi sp, sp, -12 # 3 words
    sw ra, 8(sp) # preserved, but child won't see it (jal auto changes it)
    sw t0, 4(sp)
    sw t1, 0(sp)

    # jump and link (ra = PC + 4)
    jal diffofsums # call function 
    add s7, a0, zero # y = returned value (only a0 is considered returned)

    # restore non saved regs 
    lw ra, 8(sp)
    lw t0, 4(sp) 
    lw t1, 0(sp)

    # dealloc 
    addi sp, sp, 8
    ret



diffofsums: 
    # s3 will be changed (preserved reg) => save it on the stack (stored reg) 
    addi sp, sp, -4 # make space on the stack for 1 registers (words) 
    sw s3, 0(sp) # save s3, stack moves high addr -> low addr

    # use and change the regs
    add t0, a0, a1 # t0 = f+g
    add t1, a2, a3 # t1 = h+i
    sub s3, t0, t1 # result = (f+g) - (h+i) 
    add a0, s3, zero # put return value in a0 

    # load parent's data 
    lw s3, 0(sp) # restore s3 

    addi sp, sp, 4 # dealloc stack

    jr ra # return to caller