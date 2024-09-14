.data
Message1: .asciiz "Largest: "
Message2: .asciiz "Smallest: "
Message3: .asciiz ", "
Message4: .asciiz "\n"
.text
Khai_bao:
 li $s0, 1
 li $s1, 2
 li $s2, 3
 li $s3, 10
 li $s4, 5
 li $s5, -6
 li $s6, 7
 li $s7, 8
luu_gia_tri_vao_stack:
 sw $s0, 0($sp)
 sw $s1, -4($sp)
 sw $s2, -8($sp)
 sw $s3, -12($sp) 
 sw $s4, -16($sp) 
 sw $s5, -20($sp) 
 sw $s6, -24($sp) 
 sw $s7, -28($sp)  
 li $t7, 1 #Gan i=1
 add $t1, $s0, $zero #max=$s0
 li $t2, 0 #i_min=0
 add $t3, $s0, $zero #min=$s10
 li $t4, 0 #i_max=0
 li $a2, -4
 jal loop
printf:
 li $v0, 4
 la $a0, Message1
 syscall
 li $v0, 1
 add $a0, $zero, $t1
 syscall
 li $v0, 4
 la $a0, Message3
 syscall
 li $v0, 1
 add $a0, $zero, $t2
 syscall
 
 li $v0, 4
 la $a0, Message4
 syscall
 
 li $v0, 4
 la $a0, Message2
 syscall
 li $v0, 1
 add $a0, $zero, $t3
 syscall
 li $v0, 4
 la $a0, Message3
 syscall
 li $v0, 1
 add $a0, $zero, $t4
 syscall
exit:
 li $v0, 10
 syscall 
loop:
 mul $t6, $t7, $a2
 add $t5, $sp, $t6
 lw $t0, 0($t5)
max:
 slt $a0, $t1, $t0 #so sanh max, a[i]
 beq $a0, $zero, min
 add $t1, $zero, $t0
 add $t2, $zero, $t7
min:
 slt $a1, $t0, $t3 #so sanh min, a[i]
 beq $a1, $zero, cap_nhat
 add $t3, $zero, $t0
 add $t4, $zero, $t7
cap_nhat:
 addi $t7, $t7, 1
 beq $t7, 8, done
 j loop
done:
 jr $ra 
 
