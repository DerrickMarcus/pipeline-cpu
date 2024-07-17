# MIPS Assembly 2024
# insert_sort.asm
.data
buffer: .space 4004 # 1001 numbers, buffer size=4004
input_file: .asciiz "a.in"
output_file: .asciiz "a.out"


.text
main:
    la $a0, input_file # load address of .in file to a0
    li $a1, 0 # read, flag=0
    li $a2, 0 # mode is ignored
    li $v0, 13 # open a.in
    syscall

    move $a0, $v0 # load file descripter to a0
    la $a1, buffer # load address of buffer to a1
    li $a2, 4004
    li $v0, 14 # read a.in
    syscall
    li $v0, 16 # close a.in
    syscall

    la $a0, buffer # load address of buffer to a0
    lw $a1, 0($a0) # for insertion_sort: a1=N=buffer[0], number of elements to be sorted
    addi $a0, $a0, 4 # for insertion_sort: a0=address of buffer[1],v[0]
    addi $s0, $0, 0 # compare_count=0
    jal insertion_sort_ready # call insertion_sort


end:
    la $t0, buffer # load address of buffer to t0
    lw $t1, 0($t0) # t1=N
    sw $s0, 0($t0) # buffer[0]=compare_count

    la $a0, output_file # load addres of .out file to a0
    li $a1, 1 # write, flag = 1
    li $a2, 0 # mode is ignored
    li $v0, 13 # open a.out
    syscall

    move $a0, $v0 # load file descripter to a0
    la $a1, buffer # load address of buffer to a1
    addi $t1, $t1, 1 # t1=N+1
    sll $a2, $t1, 2 # a2=4*t1=4*(N+1), number of bytes
    li $v0, 15 # write to a.out
    syscall
    li $v0, 16 # close a.out
    syscall
    li $v0, 10 # exit
    syscall


# function insert_sort: a0=address of v[0], a1=N
insertion_sort_ready:
    addi $sp, $sp, -12
    sw $ra, 8($sp) # store ra
    sw $a0, 4($sp) # store a0
    sw $a1, 0($sp) # store a1
    addi $s1, $0, 1 # s1=i, times of loops, initialised as 1


insertion_sort_loop:
    slt $t1, $s1, $a1 # t1=(i<N)
    beq $t1, $0, insertion_sort_end # i>=N, break
    addi $a2, $s1, 0 # for search: a2=i
    jal search_ready # call search
    addi $a3, $v0, 0 # for insert: a3=place, place to insert
    jal insert_ready # call insert
    addi $s1, $s1, 1 # i++
    j insertion_sort_loop # next loop


insertion_sort_end:
    lw $a1, 0($sp) # restore a1
    lw $a0, 4($sp) # restore a0
    lw $ra, 8($sp) # restore ra
    addi $sp, $sp, 12
    jr $ra # return


# function search: a0=address of v[0], a2=i=index of insert number
search_ready:
    sll $t1, $a2, 2 # t1=4*i
    add $t1, $a0, $t1 # t1=buffer of v[i]
    lw $t1, 0($t1) # t1=v[i]=tmp
    addi $t2, $a2, -1 # t2=j, times of loops, initialised as i-1


search_loop:
    slt $t3, $t2, $0 # t3=(j<0)
    bne $t3, $0, search_end # j<0, break
    addi $s0, $s0, 1 # compare_count++
    sll $t3, $t2, 2 # t3=4*j
    add $t3, $a0, $t3 # t3=address of v[j]
    lw $t3, 0($t3) # t3=v[j]
    slt $t4, $t1, $t3 # t4=(v[j]>tmp)
    beq $t4, $0, search_end # if v[j]<=tmp, break
    addi $t2, $t2, -1 # j--
    j search_loop # next loop


search_end:
    addi $v0, $t2, 1 # return j+1
    jr $ra


# function insert:a0=address of v[0], a2=i=index of insert number, a3=k=place to insert
insert_ready:
    sll $t1, $a2, 2 # t1=4*i
    add $t1, $a0, $t1 # t1=address of v[i]
    lw $t1, 0($t1) # t1=tmp=v[i]
    addi $t2, $a2, -1 # t2=j, times of loops, initialised as i-1


insert_loop:
    slt $t3, $t2, $a3 # t3=(j<k)
    bne $t3, $0, insert_end # j<k, break
    sll $t3, $t2, 2 # t3=4*j
    add $t3, $a0, $t3 # t3=address ofv[j]
    lw $t4, 0($t3) # t4=v[j]
    sw $t4, 4($t3) # v[j+1]=v[j]
    addi $t2, $t2, -1 # j--
    j insert_loop # next loop


insert_end:
    sll $t2, $a3, 2 # t2=4*k
    add $t2, $a0, $t2 # t2=address of v[k]
    sw $t1, 0($t2) # v[k]=tmp
    jr $ra # return
