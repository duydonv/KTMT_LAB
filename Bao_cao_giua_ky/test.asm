.data
string: .space 1000
Message1: .asciiz "Nhap vao chuoi: "
Message2: .asciiz "Cac ky tu so trong chuoi theo thu tu nguoc lai: "

.text
#Nhap vao chuoi 
 li $v0, 4
 la $a0, Message1
 syscall #In ra man hinh chuoi "Nhap vao chuoi: "
 li $v0, 8
 la $a0, string
 li $a1, 1000  #Gioi han so phan tu toi da cua chuoi nhap vao la 1000
 syscall

#Trich xuat ky tu so va luu vao stack

#---------------------------------------------------------------------
# $t0: Con tro tro toi ky tu dang xet trong chuoi string
# $t1: Bien chua ky tu dang xet
# $sp: stack pointer
# $t2: Con tro toi vi tri luu vao stack
#---------------------------------------------------------------------
#Khoi tao cac bien
 la $t0, string # $t2 = dia chi cua chuoi string
 addi $sp, $sp, -1000 #Lui con tro stack xuong 1000 de luu cac ky tu so trong chuoi
 addi $t2, $sp, 0 # $t2 = Dia chua cua $sp hien tai (dau cua stack luu cac ky tu so)
extract_loop:
 lb $t1, 0($t0) #Luu ky tu duoc tro toi boi $t0 vao $t1
 beq $t1, $zero, end_extract_loop #Neu ky tu dang xet la ky tu ket thuc xau => ket thuc qua trinh trich xuat
 addi $t0, $t0, 1 #Cong con tro toi ky tu dang xet len 1 => chuyen qua ky tu tiep theo
 blt $t1, 48, luu_ky_tu_vao_stack #Neu gia tri luu trong $t4 < 48 (Ma ASCII cua 0) => khong phai ky tu so => chuyen sang duyet phan tu tiep theo trong chuoi
 bgt $t1, 57, luu_ky_tu_vao_stack #Neu gia tri luu trong $t4 > 57 (Ma ASCII cua 9) => khong phai ky tu so => chuyen sang duyet phan tu tiep theo trong chuoi
 j extract_loop
 #Luu ky tu so vao stack
 luu_ky_tu_vao_stack:
 sb $t1, 0($t2) #Luu gia tri trong $t1 vao dia chi duoc luu trong $t2
 addi $t2, $t2, 1 # Cong con tro toi vi tri luu vao stack len 1 => Chuyen sang vi tri tiep theo de luu 
 j extract_loop
 end_extract_loop:
 
#Hien thi ky tu so ra man hinh theo thu tu nguoc lai
 
#--------------------------------------------------------------------- 
# $sp: stack pointer
# $t2: Con tro toi ky tu in ra man hinh trong stack 
# O day ta in tu cuoi chuoi ve dau => thu duoc day dao
#---------------------------------------------------------------------
 li $v0, 4
 la $a0, Message2
 syscall #In ra man hinh chuoi "Cac ky tu so trong chuoi theo thu tu nguoc lai: "
printf_loop:
 addi $t2, $t2, -1
 li $v0, 11
 lb $a0, 0($t2) #Luu gia tri duoc luu trong dia chi $t2 vao $a0 de in ra man hinh
 syscall
 beq $sp, $t2, end_printf_loop #Neu $t2, $sp tro toi cung 1 vi tri (ky tu nay da in ra man hinh) thi ket thuc qua trinh in ky tu trong stack ra man hinh
 j printf_loop #Nguoc lai, thi tiep tuc qua trinh in
end_printf_loop:
 li $v0, 10
 syscall #Exit

