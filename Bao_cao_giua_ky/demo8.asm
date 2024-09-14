.data
 x: .word 0 #So sinh vien
 names: .space 1250 #Khoi tao mang ten
 temp_name: .space 25 #Khoi tao bien trung gian de doi tem
 marks: .word 50 #Khoi tao mang diem
 Message1: .asciiz "Nhap vao so sinh vien: "
 Message2: .asciiz "Nhap vao ho va ten cua sinh vien thu "
 Message3: .asciiz "Nhap vao diem cua sinh vien thu "
 Message4: .asciiz ": "
 Message5: .asciiz "Loi, diem nhap vao phai thuoc [0, 10]\n"
 Message6: .asciiz "Vui long nhap lai: "
 Message7: .asciiz "Loi, vui long nhap lai so sinh vien"
 Message8: .asciiz "\nDanh sach sinh vien khi sap xep theo diem giam dan\n"
 Message9: .asciiz "Ho va ten                "
 Message10: .asciiz "Diem toan\n" 
 Message11: .asciiz "Ban co muon thuc hien chuong trinh 1 lan nua khong?"
 Message12: .asciiz "Diem nhap vao khong hop le"
.text
main:
nhap_vao_so_sinh_vien:
  li $v0, 51
  la $a0, Message1
  syscall
  beqz $a1, check_tinh_hop_ly #Trang thai tra ve la OK => chuyen qua kiem tra tinh hop ly cua so nhap vao
 #Kiem tra xem trang thai tra ve co hop ly khong
 check_dinh_dang:
  li $v0, 51
  la $a0, Message7
  syscall
  bnez $a1, check_dinh_dang #Trang thai nhap vao loi => Nhap lai 
 check_tinh_hop_ly:
  blez $a0, check_dinh_dang #Neu diem nhap vao <= 0 (lop it nhat co 1 sinh vien) => Nhap lai 
 luu_so_sv:
  la $v1, x #Luu dia chi cua bien x-so sinh vien vao $v1  
  sw $a0, 0($v1) #luu so sinh vien vua nhap vao bien x
 
#Nhap ten va diem
 
#---------------------------------------------------------------------
# $t0: Bien dem i 
# $s0: So sinh vien
# $t6: con tro tro den dia chi cua mang ten
# $t7: con tro tro den dia chi cua mang diem
# $t2: con tro den dia chi luu ten 
# $t4: con tro den dia chi luu diem
#---------------------------------------------------------------------
 li $t0, 0 #khoi tao bien dem i = 0    
 lw $s0, x #Luu so sinh vien vao $s0 
 la $t6, names #Gan dia chi mang ten vao $t6
 la $t7, marks #Gan dia chi mang diem vao $t7
input_loop:
 beq $t0, $s0, sap_xep #kiem tra neu nhap du roi thi chuyen qua sap xep i = so sinh vien
 
#Nhap ten sinh vien
 #Chuoi lenh syscall de in ra man hinh chuoi "Nhap vao ho va ten sinh vien thu i: "
 li $v0, 4
 la $a0, Message2
 syscall
 li $v0, 1 
 addi $a0, $t0, 1
 syscall
 li $v0, 4
 la $a0, Message4
 syscall
 mul $t1, $t0, 25
 add $t2, $t6, $t1 #Luu dia chi muon luu ten vao $t2 names[i]=name[0]+i*25
 li $v0, 8
 add $a0, $t2, $zero
 li $a1, 25
 syscall
 
#Nhap diem Toan cua sinh vien
 #Chuoi 3 lenh syscall ben duoi de in ra man hinh chuoi "Nhap vao diem cua sinh vien thu i: "
 li $v0, 4
 la $a0, Message3
 syscall
 li $v0, 1 
 addi $a0, $t0, 1
 syscall
 li $v0, 4
 la $a0, Message4
 syscall
 mul $t3, $t0, 4
 add $t4, $t7, $t3 #Luu dia chi muon luu ten vao $t4
 #Kiem tra diem nhap vao co thoa man hay khong
 mark_input_loop:
  li $v0, 5
  syscall
  blt $v0, 0, bao_loi #diem<0 => Loi
  bgt $v0, 10, bao_loi # diem>10 => Loi
  j luu_diem
 bao_loi:
  li $v0, 4
  la $a0, Message5
  syscall
  la $a0, Message6
  syscall
  j mark_input_loop #Nhap lai diem
 luu_diem:
  sw $v0, 0($t4)
 addi $t0, $t0, 1 #Tang bien diem len 1, chuyen qua nhap sinh vien tiep theo
 j input_loop
 
#Sap xep danh sach sinh vien dua theo diem: dung selection sort de han che so lan hoan vi
 
#--------------------------------------------------------------------- 
# $t0: chi so cua phan tu min
# $t1: bien dem i
# $t4: Con tro tro den diem tiep theo
# $t5: gia tri cua phan tu tiep theo
# $t6: con tro tro den dia chi cua mang ten
# $t7: con tro tro den dia chi cua mang diem
# $a1: con tro tro den phan tu cuoi cung cua phan chua sap xep
# $a0: con tro tro den phan tu cuoi cung cua mang ten ung voi diem duoc tro boi $a1
# $v0: con tro tro toi phan tu nho nhat trong phan chua chua sap xep
# $v1: gia tri cua phan tu nho nhat trong phan chua sap xep 
#---------------------------------------------------------------------
sap_xep:
 add $a1, $t4, $zero #Gan dia chi cuoi cua mang diem vao $a1 - do tu phan nhap o tren thi $t4 dang la vi tri cua phan tu cuoi cung trong mang 
 add $a0, $t2, $zero #Tuong tu gan dia chia cuoi cua mang ten vao $a0
min:
 beq $t7, $a1, end_sort #ket thuc khi phan chua sap xep chi con 1 phan tu
 addi $v0, $t7, 0 #gan con tro den phan tu nho nhat tro den phan tu dau tien
 lw $v1, 0($v0) #gan min = gia tri cua phan tu dau tien
 addi $t4, $t7, 0 # $t4 = dia chi dau cua mang diem
 li $t1, 0 #Gian bien dem i = 0
 li $t0, 0 #Gan chi so phan tu min = 0
min_loop:
 beq $t4, $a1, after_min #neu phan tu tiep theo la phan tu cuoi cung cua phan chua sap xep thi qua buoc xu ly khi tim duoc phan tu min
 addi $t1, $t1, 1 #i=i+1
 addi $t4, $t4, 4 #Luu dia chi phan tu tiep theo vao $t4
 lw $t5, 0($t4) #Luu gia tri cua phan tu tiep theo vao $t5
 slt $s1, $v1, $t5 #min < $t5 - phan tu tiep theo?
 bne $s1, $zero, min_loop #Neu min < phan tu tiep theo thi lap lai vong lap
 #Cap nhat vi tri, gia tri, chi so cua phan tu min moi
 addi $v0, $t4, 0 #Cap nhap con tro vi tri
 addi $v1, $t5, 0 #Cap nhat gia tri
 addi $t0, $t1, 0 #Cap nhat chi so
 j min_loop
after_min:
 beq $v0, $a1, end_of_name_swap # Neu phan tu min la phan tu cuoi cung (cung vi tri) thi ta khong can thuc hien thao tac hoan vi

#Hoan vi lai so diem
 sw $t5, 0($v0) #Luu gia tri phan tu cuoi cua phan chua sx vao vi tri phan tu min
 sw $v1, 0($a1) #Luu gia tri min vao cuoi phan chua sx
 
#Hoan vi ten di cung
#luu ten ung voi diem min sang bien ten trung gian
name_swap_1:
 la $s5, temp_name #Gan dia chi cua ten trung gian vao $s5
 mul $t1, $t0, 25
 add $s3, $t6, $t1 #Gan dia chi cua ten ung voi diem min (dang xet) vao $s3
 li $s2, 0 #khoi tao j=0
name_swap_loop_1:
 add $s4, $s3, $s2  #names[i][j]=names[i][0]+j - xet ve vi tri
 lb $t2, 0($s4) #Luu ky tu duoc tro toi boi $t4 vao $t2
 add $s6, $s5, $s2 #temp_name[j]=temp_name[0]+j - xet ve vi tri
 sb $t2, 0($s6) #Luu ky trong $t2 vao vi tri duoc tro toi boi $s6
 #beq $t2, $zero, name_swap_2
 addi $s2, $s2, 1
 beq $s2, 25, name_swap_2 #Kiem tra xem da copy du 25 ky tu chua
 j name_swap_loop_1
 
 #Luu ten o cuoi phan chua sap xep vao vi tri diem min - tuong tu 
name_swap_2:
 mul $t1, $t0, 25
 add $s5, $t6, $t1 #Gan dia chi cua ten ung voi diem min (dang xet) vao $s5
 addi $s3, $a0, 0 #Gan dia chi cua ten ung voi diem cuoi vao $s3
 li $s2, 0 #khoi tao j=0
name_swap_loop_2:
 add $s4, $s3, $s2  
 lb $t2, 0($s4)
 add $s6, $s5, $s2
 sb $t2, 0($s6)
 #beq $t2, $zero, name_swap_3
 addi $s2, $s2, 1
 beq $s2, 25, name_swap_3 #Kiem tra xem da copy du 25 ky tu chua?
 j name_swap_loop_2
 
 #luu ten dang luu o bien trung gian vao vi tri cuoi - tuong tu
name_swap_3:
 addi $s5, $a0, 0 #Gan dia chi cua ten ung voi diem cuoi vao $s5
 la $s3, temp_name #Gan dia chi cua ten trung gian vao $s3
 li $s2, 0 #khoi tao j=0
name_swap_loop_3:
 add $s4, $s3, $s2  
 lb $t2, 0($s4)
 add $s6, $s5, $s2
 sb $t2, 0($s6)
#beq $t2, $zero, end_of_name_swap
 addi $s2, $s2, 1
 beq $s2, 25, end_of_name_swap #Kiem tra xem da copy du 25 ky tu chua?
 j name_swap_loop_3
 #O tren lua chon copy toan bo 25 ky tu trong ten thay vi chi copy den cuoi ten de tranh truong hop ten in ra se gom ten 
 #va 1 doan cuoi cua ten khac
 
 end_of_name_swap:
 addi $a0, $a0, -25 # sau buoc hoan vi ten tren thi ten cuoi cung ung voi diem nho nhat, tru 25 de chuyen qua ten lien truoc va tiep tuc sx
 addi $a1, $a1, -4  # Giam so luong phan tu chua sx di 1
 j min
end_sort:

# In danh sach da sap xep ra man hinh

#---------------------------------------------------------------------
# $t0: Bien dem i 
# $s0: So sinh vien
# $t6: con tro tro den dia chi cua mang ten
# $t7: con tro tro den dia chi cua mang diem
# $t2: con tro den dia chi luu ten 
# $t4: con tro den dia chi luu diem
# $s1: Bien dem de in tung ky tu trong ten
# $s2: Dia chi cua ky tu trong ten can in
# $s3: Ky tu trong ten can in
#---------------------------------------------------------------------
#Chuoi lenh syscall de in ra man hinh
#"Danh sach sinh vien khi sap xep theo diem giam dan"
#"Ho va ten                ""Diem toan"
 li $v0, 4
 la $a0, Message8
 syscall
 la $a0, Message9
 syscall
 la $a0, Message10 
 syscall
 li $t0, 0 #Khoi tao bien diem i = 0
printf_loop:
 beq $t0, $s0, end_of_printf #Kiem tra xem neu in du roi thi ket thuc - i = so sinh vien
 
 #In ten sinh vien
name_printf:
 li $s1, 0 #Gan bien dem j = 0 (Chi so ky tu trong ten muon in)
 mul $t1, $t0, 25 
 add $t2, $t6, $t1 #Gan dia chi cua ten muon in vao $t2
name_printf_loop:
 beq $s1, 25, end_of_name_printf_loop #Kiem tra xem so ky tu in duoc = 25 chua (Bao gom ca khoang trang)
 add $s2, $t2, $s1 #Luu dia chi cua ky tu can in trong ten vao $s2
 lb $s3, 0($s2) #luu ky tu duoc luu o dia chi $t2 vao $s3
 beq $s3, 0, space_printf #Kiem tra xem name[j] = '\0'? thi nhay den doan lenh in khoang trang
 beq $s3, 10, space_printf #Kiem tra xem name[j] = '\n'? thi nhay den doan lenh in khoang trang
 #in ky tu thoa man ra man hinh
 li $v0, 11 
 add $a0, $s3, $zero
 syscall
 addi $s1, $s1, 1 #j=j+1
 j name_printf_loop
space_printf: 
#In 1 khoang trang ra man hinh neu ky tu dang xet trong ten la ky tu ta khong mong muon ("\n", "\0")
 li $v0, 11
 li $a0, ' '
 syscall
 addi $s1, $s1, 1
 j name_printf_loop
end_of_name_printf_loop:

 #In diem toan cua sinh vien
 mul $t3, $t0, 4
 add $t4, $t7, $t3 #Luu dia chi cua diem can in vao $t4
 li $v0, 1
 lw $a0, 0($t4)
 syscall
 li $v0, 11
 li $a0, '\n' 
 syscall  #Xuong dong de in tiep sinh vien tiep theo
 addi $t0, $t0, 1
 j printf_loop
end_of_printf:
exit:
 li $v0, 10 
 syscall  #Exit
