# riscv assembly calculates the sum of the first 10 natural numbers

# data section 
.data

# text section
.text
.globl main # entry point for the program

main: 
    jal for_loop

    j do_while

end_loop: 
    # final result, halt the program
    nop # also breaks debugger

temp_registers: 
    # a = b + c - d; 
    # s0 = a, s1 = b, s2 = c, s3 = d, t0 = t
    add t0, s1, s2 # t = b + c 
    sub s0, t0, s3 # a = t - d

    # back to main 
    ret

immediate_operands: 
    addi s0, s0, 4 # a = a + 4  
    addi s1, s0, -12 # b = a - 12, two's complement
    ret

immediate_init: 
    addi s4, zero, 0 # i = 0, add immediate (12 bits) 
    addi s5, zero, 2032 # x = 2032 
    addi s6, zero, -78 # y = -78
    ret 

32_bit_const: 
    lui s2, 0xABCDE # load upper immediate (20 upper bits, rest 0) 
    addi s2, s2, 0x123 # add immediate, sign extended (here 0) 
    ret 

32_bit_sign_ext: 
    lui s0, 0xFEED8 # 0xFEED8000
    addi s0, s0, -1657 # 0xFEEDA987
    ret

read_memory: 
    lw s0, 8(zero) # s0 = data at mem addr zero + 8

write_memory: 
    addi t0, zero, 42 # t0 = 42 decimal, 2A hex
    sw t0, 3(t0) # store word, data value at mem address 0x2A + 0x03 = 0x2D
    ret 

endian_mem_write: 
    lui t0, 0xA1B1C # load upper immediate 
    addi t0, t0, 0x1D1
    sw t0, 2(zero) 

    # load lowest byte (8 bits = 2 hex), prevent byte extend
    lbu t1, 2(zero)
    ret

logical_ops: # bitwise
    lui t0, 0xA1B1C
    and t2, t1, t0
    or t2, t1, t0
    xor t2, t1, t0
    ret

shifts: 
    lui t0, 0xA1B1C
    addi t0, t0, 0x1D1

    # logical, fills 0 
    slli t1, t0, 7 # shift logical left immediate; dest, source, amount
    srli t1, t0, 7 
    srai t1, t0, 3 # shift right arithmetic (fills 1 on the left side)
    
    # extract bits 15:8 from s7 and save into s6
    srli t2, t0, 8 # shift right logical and remove last 8 bits 
    andi t2, t2, 0xFF # leave only lowest byte (8 bits) 
    ret 

multiplications: 
    lui t0, 0xA1B1C 
    addi t0, t0, 0x1D1

    # multiple high (31:16 bit) signed upper part
    mulh t1, t0, t0 
    mulhu t1, t0, t0 # treat as unsigned lower part 

    # lower part (15:0 bit) is same for signed and unsigned
    mul t1, t0, t0 
    ret
    
branching: 
    addi s0, zero, 4 # s0 = 4
    addi s1, zero, 1 
    slli s1, s1, 2 # s1 = 4
    beq s0, s1, target # branch if equal, no linking, simple jump
    addi s1, s1, 1 # not executed
    ret
target: 
    add s1, s1, s0 # s1 = 8 
    ret 

conditional_branching: 
    addi s0, zero, 4 # s0 = 4
    addi s1, zero, 1 
    slli s1, s1, 2 # s1 = 4
    beq s0, s1, target2 # branch not taken
    addi s1, s1, 1 # not executed
    ret # hit here
target2: 
    add s1, s1, s0 # s1 = 8 
    ret 

unconditional_branching: 
    j target3 # unconditional 
    srai s1, s1, 2
    addi s1, s1, 1
target3: 
    add s1, s1, s0
    ret 

if_statements: 
    bne s0, s1, L1 # branch if not equal
    add s2, s3, s4 
L1: sub s0, s1, s4 
    ret

if_else: 
    bne s0, s1, L2_else # branch if not equal 
    add s2, s3, s4
    j L2_done
L2_else: 
    sub s0, s1, s4
L2_done: 
    ret

switch_case: 
case1:
    addi t0, zero, 1
    bne s0, t0, case2 # case(s0 == 1) 
    addi s1, zero, 20 
    j switch_done
case2: 
    addi t0, zero, 2
    bne s0, t0 case3 # case(s0 == 2) 
    addi s1, zero, 50
    j switch_done
case3: 
    addi t0, zero, 3
    bne s0, t0 default # case(s0 == 3) 
    addi s1, zero, 50
    j switch_done
default: 
    add s1, zero, zero 
switch_done: 
    ret

while_loop: 
    beq s0, t0, while_done # branch if equal 
    addi s0, s0, 1 
    j while_loop 
while_done: 
    ret

do_while: 
    addi s0, s0, 1
    bne s0, t0, do_while # branch if not equal
    ret # done 

for_loop: 
    addi t0, zero, 0 # iterator
    addi s0, zero, 5
for: 
    bge t0, s0, for_done # branch if >= for(i < 5) 
    addi t0, t0, 1 
    j for 
for_done:
    ret




