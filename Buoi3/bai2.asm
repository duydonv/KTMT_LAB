.data
i: .word 0
n: .word 3
step: .word 1
sum: .word 0
A: .word 1, 2, 3, 6, 19, 0
.text
la $t8, i
lw $s1, 0($t8)
la $t8, n
lw $s3, 0($t8)
la $t8, step
lw $s4, 0($t8)
la $t8, sum
lw $s5, 0($t8)
la $s2, A
lw $t0,0($s2)
add $s5,$s5,$t0
loop: add $s1,$s1,$s4 #i=i+step
add $t1,$s1,$s1 #t1=2*s1
add $t1,$t1,$t1 #t1=4*s1
add $t1,$t1,$s2 #t1 store the address of A[i]
lw $t0,0($t1) #load value of A[i] in $t0
add $s5,$s5,$t0 #sum=sum+A[i]
bne $t0,$zero,loop