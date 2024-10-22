.globl main # entry point for the program

f1: 
    addi sp, sp, -12 
    sw ra, 8(sp) # save preserved regs used by f1, incl ra (f2 cannot see ra although its preserved)
    sw s4, 4(sp) 
    sw s5, 0(sp) 

    add s5, a0, a1 
    sub t3, a0, a1
    mul s5, s5, t3
    addi s4, zero, 0 # i = 0

for: 
    bge s4, a0, return # if i >= a, exit loop 
    addi sp, sp, -8 # alloc for 2 regs
    
    sw a0, 4(sp) # save my non-preserved registers, func arg
    sw a1, 0(sp) 

    add a0, a1, s4 # create new func arg 
    jal f2
    add s5, s5, a0 # save the result of f1

    lw a0, 4(sp) # restore the nonpreserved 
    lw a1, 0(sp) 

    addi sp, sp, 8 # dealloc
    
    addi s4, s4, 1 # i++
    j for # continue loop 

return: 
    add a0, zero, s5 # return value 

    lw ra, 8(sp) # restore paret's preserved regs
    lw s4, 4(sp) 
    lw s5, 0(sp) 

    jr ra


f2:
    addi sp, sp, -4 # alloc stack
    sw s4, 0(sp) # save prserved regs used by f2

    addi s4, s0, 5

    add a0, s4, a0 # return value

    lw s4, 0(sp) # restore preserved parents regs 
    addi sp, sp, 4 # dealloc stack 

    jr ra # return to f2

main: 
    li a0, 3
    jal f1