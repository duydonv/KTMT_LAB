.data
x : .word 100 
y: .word -40 
text1 : .asciiz "The sum of "
text2 : .asciiz " and "
text3 : .asciiz " is "
.text
la $t8, x
lw $s0, 0($t8)
la $t8, y
lw $s1, 0($t8)
add $s2, $s0, $s1
li $v0, 4
la $a0, text1
syscall
li $v0, 1
add $a0, $0, $s0
syscall
li $v0, 4
la $a0, text2
syscall
li $v0, 1
add $a0, $0, $s1
syscall
li $v0, 4
la $a0, text3
syscall
li $v0, 1
add $a0, $0, $s2
syscall