.text
addi $s1, $zero, -999999
addi $s2, $zero, -100000
start:
li $t0,0 #No Overflow is default status
addu $s3,$s1,$s2 # s3 = s1 + s2
xor $t1,$s1,$s2 #Test if $s1 and $s2 have the same sign. Thuc hien lanh xor giua 2 thanh ghi: so sanh tung bit 1 
#vay nen neu 2 bit dau khac nhau (khac dau) thi ket qua cua xor se la 1 so am
bltz $t1,EXIT #If not, exit. Nhay den nhan Exit neu gia tri thanh ghi $t1 nho hon 0
slt $t2,$s3,$s1
bltz $s1,NEGATIVE #Test if $s1 and $s2 is negative?
beq $t2,$zero,EXIT #s1 and $s2 are positive
# if $s3 > $s1 then the result is not overflow
j OVERFLOW
NEGATIVE:
bne $t2,$zero,EXIT #s1 and $s2 are negative
# if $s3 < $s1 then the result is not overflow
OVERFLOW:
li $t0,1 #the result is overflow
EXIT: