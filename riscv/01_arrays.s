main: 
    # get base address of the array 
    li s0, 0x000 # bottom of the stack, base addr
    mv s1, zero # i
    addi t2, zero, 200 # t2 = 200 
for: 
    bge s1, t2, done # if i >= 200 then done
    slli t0, s1, 2 # t0 = i * 4 multiply of the addr 
    add t0, t0, s0 # address of [i] element
    lw t1, 0(t0) # t1 = arr[i] element 
    addi t1, t1, 10 # arr[i] + 10 
    sw t1, 0(t0) # save changes 
    addi s1, s1, 1 # i = i + 1 (after iter completed) 
    j for # repeat
done: 
    nop




