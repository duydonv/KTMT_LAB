.eqv KEY_CODE 0xFFFF0004 # ASCII code from keyboard, 1 byte
.eqv KEY_READY 0xFFFF0000 # =1 if has a new keycode ?
 # Auto clear after lw
.eqv DISPLAY_CODE 0xFFFF000C # ASCII code to show, 1 byte
.eqv DISPLAY_READY 0xFFFF0008 # =1 if the display has already to do
 # Auto clear after sw
.text
 li $k0, KEY_CODE
 li $k1, KEY_READY
 
 li $s0, DISPLAY_CODE
 li $s1, DISPLAY_READY
 li $t3, 0 #Bien dem so ky tu dung
 
loop: nop
 
WaitForKey: lw $t1, 0($k1) # $t1 = [$k1] = KEY_READY
 nop
 beq $t1, $zero, WaitForKey # if $t1 == 0 then Polling
 nop
 #-----------------------------------------------------
ReadKey: lw $t0, 0($k0) # $t0 = [$k0] = KEY_CODE
 nop
 #-----------------------------------------------------
WaitForDis: lw $t2, 0($s1) # $t2 = [$s1] = DISPLAY_READY
 nop
beq $t2, $zero, WaitForDis # if $t2 == 0 then Polling 
 nop 
 #-----------------------------------------------------
Encrypt: addi $t0, $t0, 0 # change input key
 #-----------------------------------------------------
ShowKey: sw $t0, 0($s0) # show key
 nop 
 #-----------------------------------------------------
 beq $t3, 1, check_x
 beq $t3, 2, check_i
 beq $t3, 3, check_t
 
check_e:
 beq $t0, 101, tang_dem
 j loop
check_x:
 beq $t0, 120, tang_dem
 beq $t0, 101, reset_e
 li $t3, 0
 j loop
check_i:
 beq $t0, 105, tang_dem
 beq $t0, 101, reset_e
 li $t3, 0
 j loop
check_t:
 beq $t0, 116, exit
 beq $t0, 101, reset_e
 li $t3, 0
 j loop 
 
 
tang_dem:
 addi $t3, $t3, 1
 j loop
#Gap chu e thi check lai tu x luon
reset_e:
 li $t3, 1
 j loop
 
exit:
 li $v0, 10
 syscall
