# data memory starts from 0x0, where is buffer
# relatively more instruction types(with directives)

main:
    li $sp, 256 # set the stack pointer $sp
    li $a0, 0 # load address of buffer to a0
    lw $a1, 0($a0) # for insertion_sort: a1=N=buffer[0], number of elements to be sorted
    addi $a0, $a0, 4 # for insertion_sort: a0=address of buffer[1],v[0]
    li $t0, 0 # compare_count=0
    jal insertion_sort_ready #  call insertion_sort


end:
    li $s0, 0
    sw $t0, 0($s0) # buffer[0]=compare_count

exit:
    j exit


# function insert_sort: a0=address of v[0], a1=N
insertion_sort_ready:
    addi $sp, $sp, -12
    sw $ra, 8($sp) # store ra
    sw $a0, 4($sp) # store a0
    sw $a1, 0($sp) # store a1
    li $t1, 1 # t1=i, times of loops, initialised as 1


insertion_sort_loop:
    bge $t1, $a1, insertion_sort_end # i>=N, break
    move $a2, $t1 # for search: a2=i
    jal search_ready # call search
    move $a3, $v0 # for insert: a3=place, place to insert
    jal insert_ready # call insert
    addi $t1, $t1, 1 # i++
    j insertion_sort_loop # next loop


insertion_sort_end:
    lw $a1, 0($sp) # restore a1
    lw $a0, 4($sp) # restore a0
    lw $ra, 8($sp) # restore ra
    addi $sp, $sp, 12
    jr $ra # return


# function search: a0=address of v[0], a2=i=index of insert number
search_ready:
    sll $t2, $a2, 2 # t2=4*i
    add $t2, $a0, $t2 # t2=address of v[i]
    lw $t3, 0($t2) # t3=v[i]=tmp
    addi $t4, $a2, -1 # t4=j,times of loops, initialised as i-1


search_loop:
    blt $t4, 0, search_end # j<0, break
    addi $t0, $t0, 1 # compare_count++
    sll $t5, $t4, 2 # t5=4*j
    add $t5, $a0, $t5 # t5=address of v[j]
    lw $t6, 0($t5) # t6=v[j]
    ble $t6, $t3, search_end # v[j]<=tmp, break
    addi $t4, $t4, -1 # j--
    j search_loop # next loop


search_end:
    addi $v0, $t4, 1 # return j+1
    jr $ra


# function insert:a0=address of v[0], a2=i=index of insert number, a3=k=place to insert
insert_ready:
    sll $t2, $a2, 2 # t2=4*i
    add $t2, $a0, $t2 # t2=address of v[i]
    lw $t3, 0($t2) # t3=v[i]=tmp
    addi $t4, $a2, -1 # t4=j,times of loops, initialised as i-1


insert_loop:
    blt $t4, $a3, insert_end # j<k, break
    sll $t5, $t4, 2 # t5=4*j
    add $t5, $a0, $t5 # t5=buffer of v[j]
    lw $t6, 0($t5) # t6=v[j]
    sw $t6, 4($t5) # v[j+1]=v[j]
    addi $t4, $t4, -1 # j--
    j insert_loop # next loop


insert_end:
    sll $t5, $a3, 2 # t5=4*k
    add $t5, $a0, $t5 # t5=address of v[k]
    sw $t3, 0($t5) # v[k]=tmp
    jr $ra # return
