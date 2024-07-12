# data memory starts from 0x0, where is buffer
# relatively fewer instruction types

main:
    li $sp, 256 # set the stack pointer $sp
    la $a0, 0 # load address of buffer to a0
    lw $a1, 0($a0) # for insertion_sort: a1=N=buffer[0], number of elements to be sorted
    addi $a0, $a0, 4 # for insertion_sort: a0=address of buffer[1],v[0]
    addi $s0, $0, 0 # compare_count=0
    jal insertion_sort_ready # call insertion_sort

    lw $a0, 0($zero) # a0=N
    sw $s0, 0($zero) # buffer[0]=compare_count
    j BCD


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




# ************************************************************
BCD:
    li $t0, 400 # first address to store BCD display
    li $t1, 0x3f # 0: 0x3f=63
    sw $t1, 0($t0)
    li $t1, 0x06 # 1: 0x06=6
    sw $t1, 4($t0)
    li $t1, 0x5b # 2: 0x5b=91
    sw $t1, 8($t0)
    li $t1, 0x4f # 3: 0x4f=79
    sw $t1, 12($t0)
    li $t1, 0x66 # 4: 0x66=102
    sw $t1, 16($t0)
    li $t1, 0x6d # 5: 0x6d=109
    sw $t1, 20($t0)
    li $t1, 0x7d # 6: 0x7d=125
    sw $t1, 24($t0)
    li $t1, 0x07 # 7: 0x07=7
    sw $t1, 28($t0)
    li $t1, 0x7f # 8: 0x7f=127
    sw $t1, 32($t0)
    li $t1, 0x6f # 9: 0x6f=111
    sw $t1, 36($t0)
    li $t1, 0x77 # A: 0x77=119
    sw $t1, 40($t0)
    li $t1, 0x7c # B: 0x7c=124
    sw $t1, 44($t0)
    li $t1, 0x39 # C: 0x39=57
    sw $t1, 48($t0)
    li $t1, 0x5e # D: 0x5e=94
    sw $t1, 52($t0)
    li $t1, 0x79 # E: 0x79=121
    sw $t1, 56($t0)
    li $t1, 0x71 # F: 0x71=113
    sw $t1, 60($t0)


display_ready:
    # a0=N, total numbers to display
    li $s0, 0 # s0=0, address of buffer
    li $s1, 400 # s1=400, address of BCD display
    li $s2, 0x40000010 # s2=0x40000010, address of BCD7
    li $t0, 0 # t0=index of number to display, initialised as 0
    li $t1, 0x989680 # t1: total times that each 4-bit number displays in 1s

display_loop:
    bgt $t0, $a0, display_end # if index>N, break
    sll $t2, $t0, 2
    add $t2, $s0, $t2 # t2=address of buffer[index]
    lw $t2, 0($t2) # t2=buffer[index], number to display
    li $t3, 0 # t3=times of 4-bit number already displayed, initialised as 0

    select_begin:
        andi $s3, $t2, 0xf000 # s3=data[15:12]
        srl $s3, $s3, 12
        sll $s3, $s3, 2
        add $s3, $s1, $s3
        lw $s3, 0($s3)
        addi $s3, $s3, 0x800 # s3=tube[11:0]

        andi $s4, $t2, 0xf00 # s4=data[11:8]
        srl $s4, $s4, 8
        sll $s4, $s4, 2
        add $s4, $s1, $s4
        lw $s4, 0($s4)
        addi $s4, $s4, 0x400 # s4=tube[11:0]

        andi $s5, $t2, 0xf0 # s5=data[7:4]
        srl $s5, $s5, 4
        sll $s5, $s5, 2
        add $s5, $s1, $s5
        lw $s5, 0($s5)
        addi $s5, $s5, 0x200 # s5=tube[11:0]

        andi $s6, $t2, 0xf # s6=data[3:0]
        sll $s6, $s6, 2
        add $s6, $s1, $s6
        lw $s6, 0($s6)
        addi $s6, $s6, 0x100 # s6=tube[11:0]

    select_1:
        sw $s3, 0($s2)
        addi $t3, $t3, 1
        nop
        nop
        nop
    select_2:
        sw $s4, 0($s2)
        addi $t3, $t3, 1
        nop
        nop
        nop
    select_3:
        sw $s5, 0($s2)
        addi $t3, $t3, 1
        nop
        nop
        nop
    select_4:
        sw $s6, 0($s2)
        addi $t3, $t3, 1
        ble $t3, $t1, select_1 # if times>=t1, break
    over_1s:
    addi $t0, $t0, 1 # index++
    j display_loop # next loop

display_end:
    j exit

exit:
    j exit

# ************************************************************