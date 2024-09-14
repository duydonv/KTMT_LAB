.text
addi $s1,$zero, 2341234
slt $t0, $s1, $zero
bne $t0, $zero, dao_dau
add $s0, $s1, $zero
j end
dao_dau:
	sub $s0, $zero, $s1
end: