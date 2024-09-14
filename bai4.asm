.text
addi $s1, $zero, 0x7fffffff
addi $s2, $zero, 1 
start:
li $t0,0 #No Overflow is default status
addu $s3,$s1,$s2 # s3 = s1 + s2
xor $t1,$s1,$s2 #Test if $s1 and $s2 have the same sign. Thuc hien lanh xor giua 2 thanh ghi: so sanh tung bit 1 
#vay nen neu 2 bit dau khac nhau (khac dau) thi ket qua cua xor se la 1 so am
bltz $t1,EXIT #If not, exit. Nhay den nhan Exit neu gia tri thanh ghi $t1 nho hon 0
xor $t2, $s1, $s3
bgtz $t2,EXIT #s1 and $s2 are positive
li $t0,1 #the result is overflow
EXIT: