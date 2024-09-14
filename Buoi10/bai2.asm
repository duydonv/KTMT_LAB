.eqv MONITOR_SCREEN 0x10010000 #Dia chi bat dau cua bo nho man hinh
.eqv RED 0x00FF0000 #Cac gia tri mau thuong su dung
.eqv GREEN 0x0000FF00
.eqv BLUE 0x000000FF
.eqv WHITE 0x00FFFFFF
.eqv YELLOW 0x00FFFF00
.eqv BLACK 0X00000000

.text
 li $k0, MONITOR_SCREEN #Nap dia chi bat dau cua man hinh
 #Hien thi o vuong goc phai thanh mau do
 li $t0, RED
 sw $t0, 28($k0)
 addi $t1,$k0,28 #Dia chi cua o vuong muon hien thi 
loop:
 #dua mau cua o do hien tai ve mau den
 li $t0, BLACK
 sw $t0, 0($t1)
 nop
 #dua mau cua o leien truoc ve mau do
 addi $t1, $t1, -4
 li $t0, RED
 sw $t0, 0($t1)
 nop
 beq $t1, $k0, exit #Neu dia chia da trung voi dia chi co so (goc trai) thi ket thuc
 j loop
 
exit:
 li $v0, 10
 syscall
 
