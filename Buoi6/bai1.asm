.data
A: .space 100 # Khoi tao mang A
mess1: .asciiz "Nhap so phan tu cua mang: "
mess2: .asciiz "Nhap phan tu thu "
mess3: .asciiz ": "
mess4: .asciiz "Tong max la "
mess5: .asciiz " voi day tien to co "
mess6: .asciiz " phan tu"
.text
main: 
	li $v0, 4
	la $a0, mess1
	syscall
	li $v0, 5
	syscall
	add $a1, $v0, $zero
	la $a0,A #a0 luu dia chi mang A
	j insertA
	nop
insertA_continue:
	j mspfx
	nop
continue:
	add $s0, $zero, $v0
	li $v0, 4
	la $a0, mess4
	syscall
	li $v0, 1
	add $a0, $zero, $v1
	syscall
	li $v0, 4
	la $a0, mess5
	syscall
	li $v0, 1
	add $a0, $zero, $s0
	syscall
	li $v0, 4
	la $a0, mess6
	syscall
lock: 
	j mspfx_end
	nop
end_of_main:
insertA:
	add $t0, $zero, $zero
	add $a2, $zero, $a0 #Luu tam dia chi cua mang A sang thanh ghi khac
loopInsertA:
	add $t2,$t0,$t0 
	add $t2,$t2,$t2
	add $t3,$t2,$a2 
	li $v0, 4
	la $a0, mess2
	syscall
	li $v0, 1
	add $a0, $zero, $t0
	addi $a0, $a0, 1
	syscall
	li $v0, 4
	la $a0, mess3
	syscall
	li $v0, 5
	syscall
	sw $v0, 0($t3)
	addi $t0,$t0,1
	slt $t5,$t0,$a1 #set $t5 to 1 if i<n
	bne $t5,$zero,loopInsertA #repeat if i<n
endLoopInsertA:
	add $a0, $zero, $a2
	j insertA_continue
end_insertA:
mspfx: 
	addi $v0,$zero,0 #initialize length in $v0 to 0
 	addi $v1,$zero,0 #initialize max sum in $v1 to 0
 	addi $t0,$zero,0 #initialize index i in $t0 to 0
	addi $t1,$zero,0 #initialize running sum in $t1 to 0
loop: 
	add $t2,$t0,$t0 #put 2i in $t2
 	add $t2,$t2,$t2 #put 4i in $t2
 	add $t3,$t2,$a0 #put 4i+A (address of A[i]) in $t3
	lw $t4,0($t3) #load A[i] from mem(t3) into $t4
	add $t1,$t1,$t4 #add A[i] to running sum in $t1
	slt $t5,$v1,$t1 #set $t5 to 1 if max sum < new sum
	bne $t5,$zero,mdfy #if max sum is less, modify results
	j test #done?
mdfy: 
	addi $v0,$t0,1 #new max-sum prefix has length i+1
	addi $v1,$t1,0 #new max sum is the running sum
test: 
	addi $t0,$t0,1 #advance the index i
	slt $t5,$t0,$a1 #set $t5 to 1 if i<n
	bne $t5,$zero,loop #repeat if i<n
done: j continue
mspfx_end: