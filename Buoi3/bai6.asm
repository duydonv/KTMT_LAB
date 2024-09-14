.data 
i : .word -1  #Khai bao i nhu nay de sau neu vao vong lap ta co the cong chi so ngay dau luon
n : .word 5
step: .word 1
max : .word 0 
a:  .word -1,-12, 24, -40, 54, -27
.text 
la $t8, i 
lw $s1, 0($t8) 
la $t8, n 
lw $s3, 0($t8) 
la $t8, step
lw $s4, 0($t8)
la $t8, max
lw $s5, 0($t8)
la $s2, a
lw $t0, ($s2)

loop: 
	add $s1,$s1,$s4 #i=i+step
	add $t1,$s1,$s1 #t1=2*s1
	add $t1,$t1,$t1 #t1=4*s1
	add $t1,$t1,$s2 #t1 store the address of A[i]
	lw $t0,0($t1) #load value of A[i] in $t0
	slt $t3, $t0, $zero
	bne $t3, $zero, dao_dau
	j so_sanh
dao_dau:
	sub $t0, $zero, $t0
so_sanh:
	slt $t4, $s5, $t0
	bne $t4, $zero, gan_max
	j kiem_tra
gan_max:
	add $s5, $zero, $t0
kiem_tra:
	bne $s1, $s3, loop
end:



