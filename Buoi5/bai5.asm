.data
string: .space 21

.text
Dinh_nghia: 
	la $s1, string # a0 = Address(string[0])
	xor $s0, $zero, $zero # s0 = length = 0
	li $t0, 19 # t0 = i = 19
get_char: #Duyet tung phan tu 1
	li $v0, 12
	syscall
check_char: 
 	beq $v0, $zero, end_of_str # Is null char?
 	beq $v0, 10, end_of_str #Kiem tra xem co la ky tu enter khong
 	addi $s0, $s0, 1 # v0=v0+1->length=length+1
 	beq $s0, 21, end_of_str #Qua 20 la dung
 	add $t1, $s1, $t0
 	sb $v0, 0($t1) #Luu ky tu vao mang, o day em luu vao cuoi mang luon
 	addi $t0, $t0, -1 # t0=t0+1->i = i - 1
 	j get_char
end_of_str: 

addi $t0, $t0, 1
li $v0, 11
li $a0, '\n' #Phan cach ra cho dep
syscall

in_nguoc:
	add $t1, $s1, $t0
	li $v0, 11
	lb $a0, 0($t1)
	syscall
	beq $t0, 19, end_printf #In xong phan tu 20 (string[19]) la dung
	addi $t0, $t0, 1
	j in_nguoc
end_printf:


