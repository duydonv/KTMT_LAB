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
 Message7: .asciiz "Loi, so sinh vien phai lon hon 0\n"
 Message8: .asciiz "\nDanh sach sinh vien khi sap xep theo diem giam dan\n"
 Message9: .asciiz "Ho va ten                "
 Message10: .asciiz "Diem toan\n" 
.text
#Nhap so sinh vien
 li $v0, 4
 la $a0, Message1
 syscall
 #Kiem tra xem so sinh vien nhap vao co thoa man
 check_so_sv:
  li $v0, 5
  syscall
  bgtz $v0, luu_so_sv #$v0>0 => luu so sv
  li $v0, 4
  la $a0, Message7
  syscall
  la $a0, Message6
  syscall
  j check_so_sv	
 luu_so_sv:
  la $v1, x #Luu dia chi cua bien x-so sinh vien vao $v1  
  sw $v0, 0($v1) #luu so sinh vien vua nhap vao bien x
 
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
# Bubble Sort để sắp xếp danh sách sinh viên theo điểm giảm dần
sap_xep:
    lw $s0, x # Load số sinh viên vào $s0
    li $t0, 0 # Index i
    li $t1, 0 # Index j
    la $t6, names # Address của mảng tên
    la $t7, marks # Address của mảng điểm
    sub $s0, $s0, 1 # Giảm số lượng lần lặp của i (s0 = s0 - 1)

bubble_outer_loop:
    beq $t0, $s0, end_sort # Nếu i == số sinh viên - 1, kết thúc sắp xếp
    li $t1, 0 # Reset j mỗi lần lặp của i

bubble_inner_loop:
    addi $t2, $t1, 1 # t2 = j + 1
    bge $t2, $s0, update_i # Nếu j + 1 >= số sinh viên, cập nhật i
    sll $t3, $t1, 2 # t3 = j * 4 (địa chỉ của điểm[j])
    sll $t4, $t2, 2 # t4 = (j + 1) * 4 (địa chỉ của điểm[j+1])
    add $t3, $t3, $t7 # t3 = address of marks[j]
    add $t4, $t4, $t7 # t4 = address of marks[j+1]
    lw $a0, 0($t3) # Load marks[j]
    lw $a1, 0($t4) # Load marks[j+1]
    ble $a0, $a1, increment_j # Nếu marks[j] <= marks[j+1], tăng j

    # Hoán đổi điểm
    sw $a0, 0($t4) # marks[j+1] = marks[j]
    sw $a1, 0($t3) # marks[j] = marks[j+1]

    # Hoán đổi tên
    sll $t5, $t1, 5 # t5 = j * 25 (địa chỉ của names[j])
    sll $t6, $t2, 5 # t6 = (j + 1) * 25 (địa chỉ của names[j+1])
    add $t5, $t5, $t6 # t5 = address of names[j]
    add $t6, $t6, $t6 # t6 = address of names[j+1]
    li $t7, 25 # Độ dài tên
    jal swap_names # Gọi hàm swap_names

increment_j:
    addi $t1, $t1, 1 # tăng j
    j bubble_inner_loop

update_i:
    addi $t0, $t0, 1 # tăng i
    j bubble_outer_loop

end_sort:
    # Tiếp tục với phần còn lại của chương trình

# Hàm swap_names để hoán đổi tên
swap_names:
    # Thêm code để hoán đổi tên ở đây
    jr $ra # Trở về chỗ gọi hàm


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
 li $v0, 10 
 syscall  #Exit
