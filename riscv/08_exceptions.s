.globl main

.data # global data segment 
A: .word 0x0000000b # 32 bit illegal instruction (all 1s)

.text 

handle_illegal_instruction: 
    # skip, log, etc, here just return 
    csrr t0, mepc # get PC where the exception occured 
    addi t0, t0, 4 # skip this instruction 
    csrw mepc, t0 # write updated PC to meps

    # restore registers 
    lw ra, 12(sp) 
    lw t0, 8(sp) 
    lw t1, 4(sp) 
    lw t2, 0(sp) 
    addi sp, sp, 16 # dealloc 

    mret # return from exception and resume at (new) mepc

trap_handler: 
    # save regs that will be used in handler 
    addi sp, sp, -16 
    sw ra, 12(sp) 
    sw t0, 8(sp) 
    sw t1, 4(sp) 
    sw t2, 0(sp)

    # load mcause to identify the trap 
    csrr t1, mcause # read 
    li t2, 2 # load 2 (code of illegal instruction) 
    
    beq t1, t2, handle_illegal_instruction

    # unknown exeption, exit 
    j exit

main: 
    # set exception handler address in mtvec 
    la t0, trap_handler # load addr 
    csrw mtvec, t0 # set mtvec to point to the trap handler 

    li t0, 0x1001
    lw t1, 0(t0)           

    # trigger illegal instruction (using undefined opcode) 
    la t3, A # load addr
    lw t3, 0(t3) # illegal instruct value in t3
    auipc t4, 0 # add upper immediate to PC
    addi t4, t4, 0x00C # t4 = PC + 12 = illegal instruct address (text grows 0 -> high addr)
    sw t3, 0(t4) # store illegal instruct in the next (no op) instruction 
    nop

    # continue doing work 
    addi t1, t1, 1
    j exit


exit: 
    nop