.eqv IN_ADRESS_HEXA_KEYBOARD 0xFFFF0012
.eqv OUT_ADRESS_HEXA_KEYBOARD 0xFFFF0014
.text
main: li $t1, IN_ADRESS_HEXA_KEYBOARD #So hang cua phim duoc nhap vao
 li $t2, OUT_ADRESS_HEXA_KEYBOARD #Thanh ghi nhan so hang so cot cua phim duoc nhan
polling:
 li $a0, 0 #Khoi tao gia tri thanh $a0 = 0
check_row_1:
 li $t3, 0x01 #Kiem tra hang 1
 sb $t3, 0($t1 ) # must reassign expected row
 lbu $a0, 0($t2) # read scan code of key button
 bnez $a0, print 
check_row_2:
 li $t3, 0x02 #Kiem tra hang 2
 sb $t3, 0($t1 ) # must reassign expected row
 lbu $a0, 0($t2) # read scan code of key button
 bnez $a0, print 
check_row_3:
 li $t3, 0x04 #Kiem tra hang 3
 sb $t3, 0($t1 ) # must reassign expected row
 lbu $a0, 0($t2) # read scan code of key button
 bnez $a0, print 
check_row_4: 
 li $t3, 0x08 #Kiem tra hang 4
 sb $t3, 0($t1 ) # must reassign expected row
 lbu $a0, 0($t2) # read scan code of key button
 bnez $a0, print 
sleep: 
 li $a0, 500 # sleep 500ms de chuong trinh dam bao khong xay ra loi
 li $v0, 32
 syscall  
 back_to_polling: j polling # continue polling
 
print: 
 li $v0, 34 # print integer (hexa)
 syscall
 #In ky tu xuong dong
 li $v0, 11
 li $a0, '\n'
 syscall
 j polling

