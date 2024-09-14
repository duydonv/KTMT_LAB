.data
A: .word 10 9 8 7 6 5 4 3 2 1 
Aend: .word 
.text
main: 
	la $a0,A #$a0 = Address(A[0])
	la $a1,Aend
 	addi $a1,$a1,-4 #$a1 = Address(A[n-1])
 	j khoi_tao #sort
after_sort: 
	li $v0, 10 #exit
 	syscall
end_main:
khoi_tao:
	addi $s0, $a0, 0 #Khoi tao i= vi tri phan tu dau tien	
check: 
	beq $s0, $a1, after_sort
	addi $s1, $a1, 0 #Khoi tao j = vi tri phan tu cuoi cung
j_loop:
	beq $s1, $s0, i_loop 
	addi $s2, $s1, -4
	lw $s3, 0($s1)
	lw $s4, 0($s2)
	slt $t5, $s3, $s4 # A[j]<A[j-1]
	beq $t5, $zero, no_swap
	sw $s4, 0($s1)
	sw $s3, 0($s2)
	addi $s1, $s1, -4
	j j_loop
no_swap: 
	addi $s1, $s1, -4
	j j_loop
i_loop: 
	addi $s0, $s0, 4
	j check
	