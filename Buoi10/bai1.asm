.eqv SEVENSEG_LEFT 0xFFFF0011 # Dia chi cua den led 7 doan trai.
.eqv SEVENSEG_RIGHT 0xFFFF0010 # Dia chi cua den led 7 doan phai

.data
# Khai báo biến cho các giá trị hiển thị từ 0 đến 9 
arr: .byte 
0x3F, #So 0 
0x06, #So 1
0x5B, #So 2
0x4F, #So 3
0x66, #So 4
0x6D, #So 5
0x7D, #So 6
0x07, #So 7
0x7F, #So 8
0x6F  #So 9

.text
.globl main
main:
    li $t0, 0                # Khởi tạo chỉ số mảng là 0
    li $t1, 9                # Giá trị cuối cùng của bộ đếm
    #Gan gia tri de LED trai hien thi so 0
    li $t2, SEVENSEG_LEFT 
    li $t3, 0x3F
    sb $t3, 0($t2)

#---------------------------------------------------------------
# $t2 Dia chi cua LED muon gan gia tri de hien thi
# $t3 Gia tri muon hien thi
# $t4 bien delay
#---------------------------------------------------------------

loop_0_to_9:
    # Hiển thị giá trị hiện tại của bộ đếm
    li $t2, SEVENSEG_RIGHT    # Địa chỉ của thanh ghi hiển thị LED phai
    lb $t3, arr($t0)       # Tải giá trị tu mang arr
    sb $t3, 0($t2)           # Ghi giá trị vào thanh ghi hiển thị

    # Delay (doan lap nay se giup so khong bi nhay lien tuc)
    li $t4, 10         # Đặt thời gian đợi
delay: 
    addi $t4, $t4, -1
    bnez $t4, delay

    # Kiểm tra xem đã đến số 9 chưa
    beq $t0, $t1, countdown  # Nếu đến 9, bắt đầu đếm ngược
    addi $t0, $t0, 1         # Tăng chỉ số mảng
    j loop_0_to_9                   # Quay lại vòng lặp

countdown:
    # Hiển thị giá trị hiện tại của bộ đếm
    li $t2, SEVENSEG_RIGHT       # Địa chỉ của thanh ghi hiển thị LED phai
    lb $t3, arr($t0)       # Tải giá trị hiển thị từ mảng
    sb $t3, 0($t2)           # Ghi giá trị vào thanh ghi hiển thị

    # Delay
    li $t4, 10         # Đặt thời gian đợi
delay_cd: 
    addi $t4, $t4, -1
    bnez $t4, delay_cd

    # Kiểm tra xem đã đến số 0 chưa
    beqz $t0, loop_0_to_9            # Nếu đến 0, quay lai dem tu 0 den 9
    addi $t0, $t0, -1        # Giảm chỉ số mảng
    j countdown              # Quay lại vòng lặp đếm ngược
