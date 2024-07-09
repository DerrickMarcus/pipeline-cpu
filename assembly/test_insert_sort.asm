# 汇编大作业2024
# insert_sort.asm
main:
    la $a0, 0 # buffer地址加载到a0
    lw $a1, 0($a0) # insertion_sort参数a1=N=buffer[0]，排序元素个数
    addi $a0, $a0, 4 # insertion_sort参数a0=buffer[1]的地址，即v[0]的地址
    li $t0, 0 # compare_count=0
    jal insertion_sort_ready # 调用insertion_sort


end:
    j end


# insert_sort函数参数：a0为v[0]地址，a1为序列个数N
insertion_sort_ready:
    addi $sp, $sp, -12 # 栈指针向下移动12
    sw $ra, 8($sp) # 保存ra
    sw $a0, 4($sp) # 保存a0
    sw $a1, 0($sp) # 保存a1
    li $t1, 1 # 循环次数计数i，初始为1


insertion_sort_loop:
    bge $t1, $a1, insertion_sort_end # i>=N退出循环，i<N继续循环
    move $a2, $t1 # search参数a2=i
    jal search_ready # 调用search
    move $a3, $v0 # insert参数a3=place，即插入位置k
    jal insert_ready # 调用insert
    addi $t1, $t1, 1 # i++
    j insertion_sort_loop # 下一轮循环


insertion_sort_end:
    lw $a1, 0($sp) # 恢复a1
    lw $a0, 4($sp) # 恢复a0
    lw $ra, 8($sp) # 恢复ra
    addi $sp, $sp, 12 # 恢复栈指针位置
    jr $ra # 返回


# search函数参数：a0为v[0]地址，a2为待插入元素下标i
search_ready:
    sll $t2, $a2, 2 # t2=4*i
    add $t2, $a0, $t2 # t2=v[i]的地址
    lw $t3, 0($t2) # t3=v[i]=tmp
    addi $t4, $a2, -1 # 循环次数计数j，初始为i-1


search_loop:
    blt $t4, 0, search_end # j<0退出循环，j>=0继续循环
    addi $t0, $t0, 1 # compare_count++
    sll $t5, $t4, 2 # t5=4*j
    add $t5, $a0, $t5 # t5=v[j]的地址
    lw $t6, 0($t5) # t6=v[j]
    ble $t6, $t3, search_end # v[j]<=tmp,break
    addi $t4, $t4, -1 # j--
    j search_loop # 下一轮循循环


search_end:
    addi $v0, $t4, 1 # return j+1
    jr $ra # 返回


# insert函数参数：a0为v[0]地址，a2为待插入元素下标i，a3为插入位置k
insert_ready:
    sll $t2, $a2, 2 # t2=4*i
    add $t2, $a0, $t2 # t2=v[i]的地址
    lw $t3, 0($t2) # t3=v[i]=tmp
    addi $t4, $a2, -1 # 循环次数计数j，初始为i-1


insert_loop:
    blt $t4, $a3, insert_end # j<k退出循环，j>=k继续循环
    sll $t5, $t4, 2 # t5=4*j
    add $t5, $a0, $t5 # t5=v[j]的地址
    lw $t6, 0($t5) # t6=v[j]
    sw $t6, 4($t5) # v[j+1]=v[j]
    addi $t4, $t4, -1 # j--
    j insert_loop # 下一轮循环


insert_end:
    sll $t5, $a3, 2 # t5=4*k
    add $t5, $a0, $t5 # t5=v[k]的地址
    sw $t3, 0($t5) # v[k]=tmp
    jr $ra # 返回
