.data	
I : .word 1
J : .word 4
m : .word 1
n : .word 3
.text
start:
la $t8, I
la $t9, J
lw $s1, 0($t8)
lw $s2, 0($t9)
la $t8, m
la $t9, n
lw $s3, 0($t8)
lw $s4, 0($t9)
addi $t1, $0, 1 #Gan gia tri cua thanh $t1 = 1
addi $t2, $0, 2 #Gan gia tri cua thanh $t2 = 2
addi $t3, $0, 3 #Gan gia tri cua thanh $t1 = 3
add $s5, $s1, $s2 
add $s6, $s3, $s4
slt $t0,$s6, $s5 # m+n<i+j
beq $t0,$zero,else # branch to else if i<j
addi $t1,$t1,1 # then part: x=x+1
addi $t3,$zero,1 # z=1
j endif # skip “else” part
else: addi $t2,$t2,-1 # begin else part: y=y-1
add $t3,$t3,$t3 # z=2*z
endif: