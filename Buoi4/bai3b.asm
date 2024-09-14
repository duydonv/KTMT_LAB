.text
li $s1, 100
li $s2, 99
slt $t0, $s2, $s1 #s2<s1 gan $t0 bang 1
bne $t0, $zero, exit
L:
#Lenh trong nhan L
exit: